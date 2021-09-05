defmodule TCPServer.Task do
  use Task

  def start_link(arg)  do
    Task.start_link(__MODULE__, :tcp_server_run, [arg])
  end

  def tcp_server_run(arg) do
#    TCPServer.open(arg)
    TCPSocketServer.open(arg)
  end
end
