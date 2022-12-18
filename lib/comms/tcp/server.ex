defmodule Comms.Tcp.Server do
  alias Comms.Tcp.Server.Connection

  require Logger

  def start_link(port, dispatch, opts \\ []) do
    {:ok, listen_socket} = :gen_tcp.listen(port, opts)

    Logger.info("TCP listening on #{port}")

    Task.start_link(__MODULE__, :loop_acceptor, [listen_socket, dispatch])
  end

  def child_spec([app, port, opts]) do
    %{id: __MODULE__, start: {__MODULE__, :start_link, [app, port, opts]}}
  end

  def loop_acceptor(listen_socket, dispatch) do
    Logger.info("Accepting TCP connections")
    {:ok, socket} = :gen_tcp.accept(listen_socket)

    {:ok, pid} = Connection.start_link(dispatch)

    :gen_tcp.controlling_process(socket, pid)
    loop_acceptor(listen_socket, dispatch)
  end
end
