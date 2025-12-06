defmodule AdventCode2025Test do
  use ExUnit.Case

  test "day 1" do
    assert AdventCode2025.CLI.main(["1"]) == %{task1: 1081, task2: 6689}
  end

  test "day 2" do
    assert AdventCode2025.CLI.main(["2"]) == %{task1: 19_574_776_074, task2: 25_912_654_282}
  end

  test "day 3" do
    assert AdventCode2025.CLI.main(["3"]) == %{task1: 17405, task2: 171_990_312_704_598}
  end

  test "day 4" do
    assert AdventCode2025.CLI.main(["4"]) == %{task1: 1464, task2: 8409}
  end

  test "day 5" do
    assert AdventCode2025.CLI.main(["5"]) == %{task1: 758, task2: 343_143_696_885_053}
  end

  test "day 6" do
    assert AdventCode2025.CLI.main(["6"]) == %{task1: 5322004718681, task2: 9876636978528}
  end

end
