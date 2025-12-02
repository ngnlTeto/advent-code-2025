defmodule AdventCode2025.CLI do
  @moduledoc """
  Simple CLI for running Advent of Code 2025 day runners.

  Usage:
    - Interactive: `mix run -e "AdventCode2025.CLI.main()"`
    - Direct: `mix run -e "AdventCode2025.CLI.main(["1"])"` or build escript
  """

  @doc """
  Entry point for escript or mix run. Accepts `argv` (list of strings) or none.
  """
  def main(argv \\ []) do
    case argv do
      [day_str | _] ->
        case parse_day(day_str) do
          {:ok, day} -> run_day(day)
          {:error, reason} -> IO.puts("Invalid day: #{reason}")
        end

      [] ->
        prompt_and_run()
    end
  end

  defp prompt_and_run do
    IO.puts("Advent of Code 2025 - Runner")
    max = AdventCode2025.Config.max_day()
    day_str = IO.gets("Enter day number to run (1..#{max}): ") |> String.trim()

    case parse_day(day_str) do
      {:ok, day} ->
        run_day(day)

      {:error, reason} ->
        IO.puts("Invalid day: #{reason}")
        prompt_and_run()
    end
  end

  @doc """
  Parse a day from string/integer input.
  """
  def parse_day(day) when is_integer(day) do
    max = AdventCode2025.Config.max_day()

    if day >= 1 and day <= max do
      {:ok, day}
    else
      {:error, "#{day} is out of range (1..#{max})"}
    end
  end

  def parse_day(day_str) when is_binary(day_str) do
    max = AdventCode2025.Config.max_day()

    case Integer.parse(day_str) do
      {n, _} when n >= 1 and n <= max -> {:ok, n}
      {n, _} -> {:error, "#{n} is out of range (1..#{max})"}
      :error -> {:error, "not a number"}
    end
  end

  def parse_day(_), do: {:error, "invalid input"}

  @doc """
  Run a registered day's `run/0` function.

  Looks for module `AdventCode2025.DayN` and calls `run/0` if exported.
  Returns the day's result on success (and prints it), or an error tuple on failure.
  """
  def run_day(day) when is_integer(day) do
    module = Module.concat(AdventCode2025, "Day#{day}")

    if Code.ensure_loaded?(module) and function_exported?(module, :run, 0) do
      try do
        result = apply(module, :run, [])
        IO.puts("Day #{day} result:\n#{inspect(result)}")
        result
      rescue
        e ->
          IO.puts("Day #{day} runner raised: #{Exception.format(:error, e, __STACKTRACE__)}")
          {:error, {:raised, e}}
      end
    else
      IO.puts(
        "No implementation found for Day #{day}. Create `lib/advent_code2025/day#{day}.ex` with `def run/0`."
      )

      {:error, :not_implemented}
    end
  end

  def run_day(other), do: {:error, {:invalid_day, other}}
end
