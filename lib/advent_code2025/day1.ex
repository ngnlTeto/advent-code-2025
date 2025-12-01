defmodule AdventCode2025.Day1 do
  @input_file Path.join(__DIR__, "../../inputs/day1.txt")
  @dial_size 100
  @start_dial 50

  def run do
    instructions = File.read!(@input_file) |> parse
    %{task1: run_part1(instructions), task2: run_part2(instructions)}
  end

  defp parse_line("L" <> rotation), do: -String.to_integer(rotation)
  defp parse_line("R" <> rotation), do: +String.to_integer(rotation)

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  defp run_part1(instructions) do
    {_dial, count} =
      instructions
      |> Enum.reduce({@start_dial, 0}, fn x, {curr, count} ->
        dial = Integer.mod(curr + x, @dial_size)
        {dial, count + if(dial === 0, do: 1, else: 0)}
      end)

    count
  end

  defp run_part2(instructions) do
    {_dial, count} =
      instructions
      |> Enum.reduce({@start_dial, 0}, fn x, {curr, count} ->
        dial = curr + x
        incr = abs(div(dial, @dial_size)) + if curr !== 0 && dial <= 0, do: 1, else: 0
        {Integer.mod(dial, @dial_size), count + incr}
      end)

    count
  end
end
