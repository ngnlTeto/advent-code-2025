defmodule AdventCode2025.Day7 do
  require AdventCode2025.Util

  @input_file Path.join(__DIR__, "../../inputs/day7.txt")

  def run do
    input = File.read!(@input_file) |> parse
    %{task1: run_part1(input), task2: run_part2(input)}
  end

  defp parse(input) do
    graphems =
      input
      |> String.trim()
      |> String.split("\n", trim: true)
      |> Enum.map(&String.graphemes/1)

    splitter = AdventCode2025.Util.get_char_pos_from_matrix(graphems, "^")
    [tachyon] = AdventCode2025.Util.get_char_pos_from_matrix(graphems, "S") |> MapSet.to_list()

    {splitter, tachyon, Enum.count(graphems)}
  end

  defp run_part1({splitter, tachyon, height}) do
    {tachyon_x, _tachyon_y} = tachyon
    beam = MapSet.new([tachyon_x])
    calc_beam(splitter, beam, 1, height - 1)
  end

  defp run_part2(_input) do
    nil
  end

  defp calc_beam(splitter, beams, level, height) do
    IO.inspect(splitter)

    cur_level_splitter =
      splitter
      |> MapSet.filter(fn s -> elem(s, 1) == level end)
      |> MapSet.to_list()
      |> Enum.map(&elem(&1, 0))
      |> MapSet.new()

    {new_beams, split_count} =
      cur_level_splitter
      |> Enum.reduce({beams, 0}, fn splitter, {beams, split_count} ->
        if MapSet.member?(beams, splitter) do
          new_beams =
            beams
            |> MapSet.delete(splitter)
            |> MapSet.put(splitter - 1)
            |> MapSet.put(splitter + 1)

          {new_beams, split_count + 1}
        else
          {beams, split_count}
        end
      end)

    if level == height do
      split_count
    else
      other_splits = calc_beam(splitter, new_beams, level + 1, height)
      split_count + other_splits
    end
  end
end
