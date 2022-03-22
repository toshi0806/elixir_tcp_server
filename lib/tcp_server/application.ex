defmodule TCPServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    argc = "BAKEWARE_ARGC" |> System.get_env("0") |> String.to_integer
    args = if argc > 0 do
      for v <- 1..argc, do: System.get_env("BAKEWARE_ARG#{v}")
    else
      []
    end

    {opt, _argv, _error} = OptionParser.parse(args, strict: [port: :integer], aliases: [p: :port])
    port = opt[:port] || 12508

    children = [
      {Task.Supervisor, name: TCPServer.WorkerSupervisor},
      {TCPServer.Task, port},
    ]

    opts = [strategy: :one_for_one, name: TCPServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

