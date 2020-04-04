defmodule RestModuleTest do
  use ExUnit.Case
  doctest RestModule

  test "greets the world" do
    assert RestModule.hello() == :world
  end
end
