defmodule TCPSocketServer do
  require Logger

  @moduledoc """
  Documentation for `TCPSocketServer`.
  """

  def open(port), do: open(port, 4)

  def open(port, version) do
    {:ok, socket} = Socket.TCP.listen(port, [as: :binary, version: version, mode: :passive, reuse: true])

    looper(socket)
  end

  defp looper(socket) do
    {:ok, client} = Socket.TCP.accept(socket)
    pid = spawn(TCPServer, :serve, [client])
    :ok = Socket.TCP.process(client, pid)
  
    looper(socket)
  end
  
  def serve(socket) do
    case Socket.Stream.recv(socket, 0) do
      {:ok, msg} ->
        Socket.Stream.send(socket, "received: #{msg}")
        serve(socket)
      _ ->
        Socket.Stream.close(socket)
    end 
  end
end
