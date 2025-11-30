defmodule AdventCode2025.Config do
  @moduledoc """
  Central configuration for the Advent of Code 2025 runner.

  Keep configuration values here so they are easy to change in one place.
  """

  @max_days 12

  @doc """
  Return the maximum day available for this year's event.
  """
  def max_day, do: @max_days
end
