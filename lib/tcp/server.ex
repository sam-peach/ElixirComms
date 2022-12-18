defmodule Tcp.Server do
  alias Tcp.Server.Connection

  require Logger

  def start_link(port, opts \\ []) do
    Task.start_link(__MODULE__, :accept, [port, opts])
  end

  def accept(port, opts) do
    {:ok, listen_socket} = :gen_tcp.listen(port, opts)

    Logger.info(">> Listening on #{port}")

    loop_acceptor(listen_socket)
  end

  def loop_acceptor(listen_socket) do
    Logger.info(">> Accepting connections")
    {:ok, socket} = :gen_tcp.accept(listen_socket)

    {:ok, pid} = Connection.start_link(socket)

    :gen_tcp.controlling_process(socket, pid)
    loop_acceptor(listen_socket)
  end
end
