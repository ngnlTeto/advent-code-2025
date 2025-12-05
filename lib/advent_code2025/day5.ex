defmodule AdventCode2025.Day5 do
  @input_file Path.join(__DIR__, "../../inputs/day5.txt")

  def run do
    {ranges, ids} = File.read!(@input_file) |> parse
    %{task1: run_part1(ranges, ids), task2: run_part2(ranges)}
  end

  defp parse(input) do
    [rangesBlock, idsBlock] =
      input
      |> String.trim()
      |> String.split("\n\n")

    ranges =
      rangesBlock
      |> String.split("\n")
      |> Enum.map(fn line ->
        [min, max] = String.split(line, "-") |> Enum.map(&String.to_integer/1)
        min..max
      end)

    ids =
      idsBlock
      |> String.split("\n")
      |> Enum.map(&String.to_integer/1)

    {ranges, ids}
  end

  defp run_part1(ranges, ids) do
    ids
    |> Enum.filter(fn id ->
      Enum.any?(ranges, fn range -> id in range end)
    end)
    |> length()
  end

  defp run_part2(ranges) do
    ranges
    |> Enum.reduce([], fn range, acc ->
      overlapping_ranges = Enum.reject(acc, &Range.disjoint?(&1, range))
      other_ranges = Enum.filter(acc, &Range.disjoint?(&1, range))

      merged_range = merge_ranges([range | overlapping_ranges])

      [merged_range | other_ranges]
    end)
    |> Enum.map(&Range.size/1)
    |> Enum.sum()
  end

  defp merge_ranges(ranges) do
    min =
      ranges
      |> Enum.map(& &1.first)
      |> Enum.min()

    max =
      ranges
      |> Enum.map(& &1.last)
      |> Enum.max()

    min..max
  end
end
