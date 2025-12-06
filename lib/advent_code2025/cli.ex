defmodule AdventCode2025.CLI do
  @moduledoc """
  Simple CLI for running Advent of Code 2025 day runners.
  """

  @max_days 12

  @doc """
  Entry point for escript or mix run. Accepts `argv` (list of strings) or none.
  """
  def main(arg \\ nil) do
    case arg do
      day when day in 1..@max_days -> run_day(day)
      int when is_integer(int) -> {:error, "#{int} is out of range (1..#{@max_days})"}
      nil -> prompt_and_run()
      no_day -> IO.puts("Invalid day: #{no_day}")
    end
  end

  defp prompt_and_run do
    IO.puts("Advent of Code 2025 - Runner")
    day_str = IO.gets("Enter day number to run (1..#{@max_days}): ") |> String.trim()

    case Integer.parse(day_str) do
      {day, _} when day in 1..@max_days ->
        run_day(day)

      {_, _} ->
        IO.puts("Invalid day: Not in range")

      :error ->
        IO.puts("Invalid day: Not parseable to integer")
        prompt_and_run()
    end
  end

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
end
