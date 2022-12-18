defmodule Comms.Udp.Server do
  use GenServer

  require Logger

  def start_link(node_pid, port, dispatch, opts \\ []) do
    GenServer.start_link(__MODULE__, [node_pid, port, dispatch, opts])
  end

  def child_spec([node_pid, port, dispatch, opts]) do
    %{id: __MODULE__, start: {__MODULE__, :start_link, [node_pid, port, dispatch, opts]}}
  end

  def init([node_pid, port, dispatch, opts]) do
    Logger.info("UDP: Listening on #{port}!")
    {:ok, socket} = :gen_udp.open(port, opts)

    {:ok, {socket, node_pid, dispatch}}
  end

  def handle_info({:udp, _socket, _ip, _port, _data} = packet, {socket, node_pid, dispatch}) do
    dispatch.(packet, node_pid)

    {:noreply, {socket, node_pid, dispatch}}
  end
end
