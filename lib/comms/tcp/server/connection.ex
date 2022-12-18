defmodule Comms.Tcp.Server.Connection do
  use GenServer

  require Logger

  def start_link(dispatch) do
    GenServer.start_link(__MODULE__, [dispatch])
  end

  def init([dispatch]) do
    Logger.info("Starting TCP connection handler")
    {:ok, dispatch}
  end

  def send(pid, data) do
    GenServer.cast(pid, {:send, data})
  end

  def handle_info({:tcp, socket, _data} = packet, dispatch) do
    Logger.info("Received TCP data: #{inspect(packet)}")

    dispatch.(packet)
    |> send_response(socket)

    {:noreply, dispatch}
  end

  def handle_info({:tcp_closed, _socket}, _state) do
    Logger.info("TCP closed")
    Process.exit(self(), :normal)
  end

  def handle_info({:tcp_error, socket, reason}, state) do
    IO.inspect(socket, label: "Connection closed dut to #{reason}")

    {:noreply, state}
  end

  def send_response(resp, socket) do
    :gen_tcp.send(socket, to_string(resp))
    :gen_tcp.close(socket)
  end
end
