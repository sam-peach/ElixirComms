defmodule TcpTest do
  use ExUnit.Case
  doctest Tcp

  test "greets the world" do
    assert Comms.hello() == :world
  end
end
