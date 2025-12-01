defmodule AdventCode2025.Day1 do
  @moduledoc """
  Placeholder for Day 1 solutions. Replace with your implementation.
  """

  @input_file Path.join(__DIR__, "../../inputs/day1.txt")

  @doc """
  Run Day 1 solution. Return whatever representation you prefer.
  """
  def run do
    input = File.read!(@input_file)
    instructions = String.split(input, "\n", trim: true)

    operations =
      Enum.map(
        instructions,
        fn i ->
          i
          |> String.replace_prefix("R", "+")
          |> String.replace_prefix("L", "-")
          |> Integer.parse()
          |> elem(0)
        end
      )

    result =
      Enum.reduce(
        operations,
        {0, 50},
        fn x, acc ->
          newDial = Integer.mod(elem(acc, 1) + x + 10000, 100)
          newSum = if newDial === 0, do: elem(acc, 0) + 1, else: elem(acc, 0)
          {newSum, newDial}
        end
      )

    %{result: elem(result, 0)}
  end
end
