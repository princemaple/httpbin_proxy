defmodule HttpbinProxyTest do
  use ExUnit.Case
  doctest HttpbinProxy

  test "greets the world" do
    assert HttpbinProxy.hello() == :world
  end
end
