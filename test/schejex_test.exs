defmodule SchejexTest do
  use ExUnit.Case
  doctest Schejex

  test "the truth" do
    assert 1 + 1 == 2
  end

  test "schedulerStartup" do
      Scheduler.start()
      Request.start("foobar")
  end
end
