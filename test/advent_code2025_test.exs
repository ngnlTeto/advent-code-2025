defmodule AdventCode2025Test do
  use ExUnit.Case

  test "day 1" do
    assert AdventCode2025.CLI.main(["1"]) == %{task1: 1081, task2: 6689}
  end

  test "day 2" do
    assert AdventCode2025.CLI.main(["2"]) == %{task1: 19_574_776_074, task2: 25_912_654_282}
  end
end
