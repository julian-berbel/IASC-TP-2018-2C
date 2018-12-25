defmodule IascHttpServerTest do
  use ExUnit.Case
  doctest IascHttpServer

  test "greets the world" do
    assert IascHttpServer.hello() == :world
  end
end
