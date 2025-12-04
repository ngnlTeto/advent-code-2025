defmodule AdventCode2025.Day4 do
  @input_file Path.join(__DIR__, "../../inputs/day4.txt")
  @relative_moves [{-1, -1}, {0, -1}, {1, -1}, {-1, 0}, {1, 0}, {-1, 1}, {0, 1}, {1, 1}]

  def run do
    rolls = File.read!(@input_file) |> parse
    %{task1: run_part1(rolls), task2: run_part2(rolls)}
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&String.graphemes/1)
    |> get_rolls()
  end

  defp get_rolls(matrix) do
    matrix
    |> Enum.with_index()
    |> Enum.reduce(MapSet.new(), fn {row, indexY}, acc ->
      row
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {value, indexX}, acc2 ->
        if value == "@" do
          MapSet.put(acc2, {indexX, indexY})
        else
          acc2
        end
      end)
    end)
  end

  defp run_part1(rolls) do
    rolls
    |> MapSet.filter(&forkliftable(rolls, &1))
    |> MapSet.size()
  end

  defp run_part2(rolls) do
    rollCount = MapSet.size(rolls)
    rollsLeftCount = remove_all_forkliftable_rolls(rolls) |> MapSet.size()
    rollCount - rollsLeftCount
  end

  defp remove_all_forkliftable_rolls(rolls) do
    removedRolls = MapSet.filter(rolls, &forkliftable(rolls, &1))
    rollsLeft = MapSet.difference(rolls, removedRolls)

    if MapSet.size(removedRolls) == 0 do
      rolls
    else
      remove_all_forkliftable_rolls(rollsLeft)
    end
  end

  defp forkliftable(rolls, {x, y}) do
    neighboringRollsCount =
      @relative_moves
      |> Enum.map(fn {dx, dy} -> {x + dx, y + dy} end)
      |> Enum.count(&MapSet.member?(rolls, &1))

    neighboringRollsCount < 4
  end
end
