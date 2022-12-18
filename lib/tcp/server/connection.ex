defmodule Tcp.Server.Connection do
  use GenServer

  require Logger

  def start_link(socket, opts \\ []) do
    GenServer.start_link(__MODULE__, socket, opts)
  end

  def init(socket) do
    Logger.info("Starting connection")
    {:ok, socket}
  end

  def send(pid, data) do
    GenServer.cast(pid, {:send, data})
  end

  # TCP callbacks

  def handle_info({:tcp, socket, data}, state) do
    Logger.info("TCP DATA: #{inspect(data)}")
    {:noreply, state}
  end

  def handle_info({:tcp_closed, socket}, state) do
    Logger.info(" TCP closed")
    Process.exit(self(), :normal)
  end

  # GenServer callbacks

  def handle_cast({:send, data}, socket) do
    :gen_tcp.send(socket, data)
    {:noreply, socket}
  end
end
