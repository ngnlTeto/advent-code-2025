defmodule AdventCode2025.Day3 do
  @input_file Path.join(__DIR__, "../../inputs/day3.txt")

  def run do
    banks = File.read!(@input_file) |> parse
    %{task1: run_part1(banks), task2: run_part2(banks)}
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n", trim: true)
    |> Enum.map(&parseEntry/1)
  end

  defp parseEntry(entry) do
    entry |> String.graphemes() |> Enum.map(&String.to_integer/1)
  end

  defp run_part1(banks) do
    banks
    |> Enum.map(&calculateBankEnergy(&1, 2))
    |> Enum.sum()
  end

  defp run_part2(banks) do
    banks
    |> Enum.map(&calculateBankEnergy(&1, 12))
    |> Enum.sum()
  end

  defp calculateBankEnergy(bank, batteryCount) do
    indices =
      Enum.to_list(0..(batteryCount - 1))
      |> Enum.reduce([], fn batteryIndex, indices ->
        start =
          if Enum.empty?(indices),
            do: 0,
            else: Enum.at(indices, -1) + 1

        ending = length(bank) - batteryCount + batteryIndex

        index =
          bank
          |> Enum.slice(start..ending)
          |> indexOfMax()
          |> Kernel.+(start)

        Enum.concat(indices, [index])
      end)

    indices
    |> Enum.map(fn i -> Enum.at(bank, i) |> Integer.to_string() end)
    |> Enum.join()
    |> String.to_integer()
  end

  defp indexOfMax(list) do
    list
    |> Enum.with_index()
    |> Enum.reduce(0, fn {value, index}, currentMax ->
      if value > Enum.at(list, currentMax) do
        index
      else
        currentMax
      end
    end)
  end
end
