defmodule AdventCode2025.Day2 do
  @input_file Path.join(__DIR__, "../../inputs/day2.txt")
  @task1_regex ~r/^(\d+)\1$/
  @task2_regex ~r/^(\d+)\1+$/

  def run do
    ranges = File.read!(@input_file) |> parse
    %{task1: filter_bad_ids(ranges, @task1_regex), task2: filter_bad_ids(ranges, @task2_regex)}
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split(",", trim: true)
    |> Enum.map(&parse_entry/1)
  end

  defp parse_entry(entry) do
    entry |> String.split("-") |> Enum.map(&String.to_integer/1) |> List.to_tuple()
  end

  defp filter_bad_ids(ranges, pattern) do
    invalidIds =
      ranges
      |> Enum.flat_map(fn {from, to} ->
        Enum.filter(from..to, &Regex.match?(pattern, Integer.to_string(&1)))
      end)

    Enum.sum(invalidIds)
  end
end
