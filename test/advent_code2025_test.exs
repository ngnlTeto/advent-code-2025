defmodule AdventCode2025Test do
  use ExUnit.Case

  test "day 1" do
    assert AdventCode2025.CLI.main(["1"]) == %{task1: 1081, task2: 6689}
  end
end
