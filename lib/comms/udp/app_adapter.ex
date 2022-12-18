defmodule Comms.Udp.AppAdapter do
  alias Comms.Udp.Server

  def dispatch(data, node_pid, app) do
    app.call(data, node_pid)
  end

  def child_spec([app, node_pid, port, opts]) do
    Server.child_spec([node_pid, port, &dispatch(&1, &2, app), opts])
  end
end
