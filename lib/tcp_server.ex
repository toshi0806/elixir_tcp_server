defmodule TCPServer do
  require Logger

  @moduledoc """
  Documentation for `TCPServer`.
  """

  def open(port), do: open(port, :inet)

  def open(port, family) do
    {:ok, socket} = :gen_tcp.listen(port, [:binary, family, packet: :line, active: false, reuseaddr: true])

    looper(socket)
  end

  defp looper(socket) do
    {:ok, client} = :gen_tcp.accept(socket)
    pid = spawn(TCPServer, :serve, [client])
    :ok = :gen_tcp.controlling_process(client, pid)
  
    looper(socket)
  end
  
  def serve(socket) do
    case :gen_tcp.recv(socket, 0) do
      {:ok, msg} ->
        :gen_tcp.send(socket, "received: #{msg}")
        serve(socket)
      _ ->
        :inet.close(socket)
    end 
  end
end
