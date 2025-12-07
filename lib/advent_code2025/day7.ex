defmodule AdventCode2025.Day7 do
  require AdventCode2025.Util

  @input_file Path.join(__DIR__, "../../inputs/day7.test.txt")

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
    {tachyon_x, _} = tachyon
    beam = MapSet.new([tachyon_x])
    calc_beam(splitter, beam, 1, height - 1)
  end

  defp run_part2({splitter, tachyon, _}) do
    first_pos =
      splitter
      |> MapSet.filter(fn s -> elem(s, 0) == elem(tachyon, 0) end)
      |> MapSet.to_list()
      |> Enum.min_by(&elem(&1, 1))

    base_node = gen_splitter_tree(first_pos, splitter)

    IO.inspect(base_node, limit: :infinity)

    base_node
  end

  defp gen_splitter_tree(pos, splitter) do
    next_splitter = find_next_splitter(pos, splitter)

    nodes =
      next_splitter
      |> Enum.map(&gen_splitter_tree(&1, splitter))

    %{pos: pos, childs: MapSet.new(nodes)}
  end

  defp find_next_splitter(pos, splitter) do
    left_splitter =
      splitter
      |> MapSet.filter(fn s -> elem(pos, 0) - 1 == elem(s, 0) end)
      |> MapSet.filter(fn s -> elem(pos, 1) < elem(s, 1) end)
      |> MapSet.to_list()

    left =
      if Enum.empty?(left_splitter),
        do: [],
        else: [Enum.min_by(left_splitter, &elem(&1, 1))]

    right_splitter =
      splitter
      |> MapSet.filter(fn s -> elem(pos, 0) + 1 == elem(s, 0) end)
      |> MapSet.filter(fn s -> elem(pos, 1) < elem(s, 1) end)
      |> MapSet.to_list()

    right =
      if Enum.empty?(right_splitter),
        do: [],
        else: [Enum.min_by(right_splitter, &elem(&1, 1))]

    left ++ right
  end

  defp calc_beam(splitter, beams, level, height) do
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
