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
    findNextBattery(bank, 0, batteryCount)
    |> Enum.map(&Enum.at(bank, &1))
    |> Enum.reduce(0, fn v, acc -> acc * 10 + v end)
  end

  defp findNextBattery(bank, start, remainder) do
    last = length(bank) - remainder

    index =
      bank
      |> Enum.slice(start..last)
      |> indexOfMax()
      |> Kernel.+(start)

    if remainder == 1 do
      [index]
    else
      restBatteries = findNextBattery(bank, index + 1, remainder - 1)
      [index | restBatteries]
    end
  end

  defp indexOfMax(list) do
    {_, maxIndex} =
      list
      |> Enum.with_index()
      |> Enum.max_by(fn {value, _index} -> value end)

    maxIndex
  end
end
