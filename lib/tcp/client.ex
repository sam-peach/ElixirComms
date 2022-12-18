defmodule Tcp.Client do
  use GenServer

  require Logger

  def start_link(host, port, opts \\ []) do
    GenServer.start_link(__MODULE__, [host, port, opts])
  end

  def send(pid, message) do
    GenServer.call(pid, {:send, message})
  end

  def close(pid) do
    GenServer.call(pid, :close)
  end

  def init([host, port, opts]) do
    {:ok, socket} = :gen_tcp.connect(host, port, opts)

    Logger.info(">> Connected to #{Tuple.to_list(host) |> Enum.join(".")}:#{port}")

    {:ok, socket}
  end

  def handle_call({:send, data}, _from, socket) do
    :gen_tcp.send(socket, data)

    {:reply, :ok, socket}
  end

  def handle_call(:close, _from, socket) do
    Logger.info(">> Closing #{inspect(socket)}")
    :gen_tcp.close(socket)

    {:reply, :ok, socket}
  end

  def handle_info({:tcp, _socket, data}, state) do
    IO.inspect(data, label: "TCP received")

    {:noreply, state}
  end

  def handle_info({:tcp_closed, socket}, state) do
    IO.inspect(socket, label: "Closed")

    {:noreply, state}
  end

  def handle_info({:tcp_error, socket, reason}, state) do
    IO.inspect(socket, label: "connection closed dut to #{reason}")

    {:noreply, state}
  end
end
