defmodule AdventCode2025 do
  @moduledoc """
  Documentation for `AdventCode2025`.
  """

  @doc """
  Run a given `day` (integer or string) by delegating to the CLI runner.

  Returns `{:ok, result}` or `{:error, reason}`.
  """
  def run_day(day) do
    AdventCode2025.CLI.run_day(day)
  end
end
