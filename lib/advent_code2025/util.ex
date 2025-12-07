defmodule AdventCode2025.Util do
  def get_char_pos_from_matrix(matrix, char) do
    matrix
    |> Enum.with_index()
    |> Enum.reduce(MapSet.new(), fn {row, indexY}, acc ->
      row
      |> Enum.with_index()
      |> Enum.reduce(acc, fn {value, indexX}, acc2 ->
        if value == char do
          MapSet.put(acc2, {indexX, indexY})
        else
          acc2
        end
      end)
    end)
  end
end
