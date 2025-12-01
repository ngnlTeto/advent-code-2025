defmodule AdventCode2025.Day1 do
  @moduledoc """
  Placeholder for Day 1 solutions. Replace with your implementation.
  """

  @input_file Path.join(__DIR__, "../../inputs/day1.txt")
  @dial_size 100
  @start_dial 50

  @doc """
  Run Day 1 solution. Return whatever representation you prefer.
  """
  def run do
    %{task1: run_part1(), task2: run_part2()}
  end

  defp run_part1 do
    instructions = File.read!(@input_file) |> String.split("\n", trim: true)

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
        {0, @start_dial},
        fn x, acc ->
          newDial = Integer.mod(elem(acc, 1) + x + 10000, @dial_size)
          newSum = if newDial === 0, do: elem(acc, 0) + 1, else: elem(acc, 0)
          {newSum, newDial}
        end
      )

    elem(result, 0)
  end

  defp run_part2 do
    instructions = File.read!(@input_file) |> String.split("\n", trim: true)

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
        {0, @start_dial},
        fn x, acc ->
          newDial = elem(acc, 1) + x
          sum = elem(acc, 0)

          newsum =
            cond do
              newDial < 0 ->
                tempSum = sum + div(newDial, -100)

                if elem(acc, 1) !== 0 do
                  tempSum + 1
                else
                  tempSum
                end

              99 < newDial ->
                sum + div(newDial, 100)

              newDial === 0 ->
                sum + 1

              true ->
                sum
            end

          newDial = (newDial + 10000) |> Integer.mod(@dial_size)

          {newsum, newDial}
        end
      )

    elem(result, 0)
  end
end
