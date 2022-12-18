defmodule Comms.Tcp.AppAdapter do
  alias Comms.Tcp.Server

  def dispatch(data, app) do
    app.call(data)
  end

  def child_spec([app, port, opts]) do
    Server.child_spec([port, &dispatch(&1, app), opts])
  end
end
