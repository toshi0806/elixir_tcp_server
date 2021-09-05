defmodule TCPServerTest do
  use ExUnit.Case
  doctest TCPServer

  @port 65020

  setup do
    spawn(TCPServer, :accept, [@port])

    opts = [:binary, packet: :line, active: false]
    {:ok, socket} = :gen_tcp.connect('localhost', @port, opts)
    %{socket: socket}
  end
  
  test "tcpserver", %{socket: socket} do
    assert send_and_recv(socket, "hello") == "received: hello"
  end

  defp send_and_recv(socket, msg)do
    :ok = :gen_tcp.send(socket, msg)
    {:ok, data} = :gen_tcp.recv(socket, 0, 1000)
    data
  end
end
