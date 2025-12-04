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
    |> Enum.map(&parse_entry/1)
  end

  defp parse_entry(entry) do
    entry |> String.graphemes() |> Enum.map(&String.to_integer/1)
  end

  defp run_part1(banks) do
    banks
    |> Enum.map(&calculate_bank_energy(&1, 2))
    |> Enum.sum()
  end

  defp run_part2(banks) do
    banks
    |> Enum.map(&calculate_bank_energy(&1, 12))
    |> Enum.sum()
  end

  defp calculate_bank_energy(bank, batteryCount) do
    find_next_battery(bank, 0, batteryCount)
    |> Enum.map(&Enum.at(bank, &1))
    |> Enum.reduce(0, fn v, acc -> acc * 10 + v end)
  end

  defp find_next_battery(bank, start, remainder) do
    last = length(bank) - remainder

    index =
      bank
      |> Enum.slice(start..last)
      |> index_of_max()
      |> Kernel.+(start)

    if remainder == 1 do
      [index]
    else
      restBatteries = find_next_battery(bank, index + 1, remainder - 1)
      [index | restBatteries]
    end
  end

  defp index_of_max(list) do
    {_, maxIndex} =
      list
      |> Enum.with_index()
      |> Enum.max_by(fn {value, _index} -> value end)

    maxIndex
  end
end
