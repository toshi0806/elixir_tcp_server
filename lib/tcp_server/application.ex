defmodule TCPServer.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    port = String.to_integer(System.get_env("PORT") || "12508")

    children = [
#      {Task.Supervisor, name: TCPServer.WorkerSupervisor, restart: transient},
      {TCPServer.Task, port},
    ]

    opts = [strategy: :one_for_one, name: TCPServer.Supervisor]
    Supervisor.start_link(children, opts)
  end
end

