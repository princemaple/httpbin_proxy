defmodule ApiDemoTest do
  use ExUnit.Case
  doctest ApiDemo

  test "greets the world" do
    assert ApiDemo.hello() == :world
  end
end
