defmodule AdventCode2025.Day2 do
  @input_file Path.join(__DIR__, "../../inputs/day2.txt")

  def run do
    ranges = File.read!(@input_file) |> parse
    %{task1: run_part1(ranges), task2: run_part2(ranges)}
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(fn line ->
      String.split(line, "-")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  defp run_part1(ranges) do
    invalidIds =
      ranges
      |> Enum.flat_map(fn range ->
        Enum.to_list(elem(range, 0)..elem(range, 1))
        |> Enum.filter(&Regex.match?(~r/^(\d+)\1$/, Integer.to_string(&1)))
      end)

    Enum.sum(invalidIds)
  end

  defp run_part2(ranges) do
    invalidIds =
      ranges
      |> Enum.flat_map(fn range ->
        Enum.to_list(elem(range, 0)..elem(range, 1))
        |> Enum.filter(&Regex.match?(~r/^(\d+)\1+$/, Integer.to_string(&1)))
      end)

    Enum.sum(invalidIds)
  end
end
