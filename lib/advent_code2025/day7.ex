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

    {splitter, tachyon}
  end

  defp run_part1({splitter, tachyon}) do
    pos = find_next_splitter(tachyon, splitter)
    splitter_map = gen_splitter_map(Map.new(), pos, splitter)
    map_size(splitter_map)
  end

  defp run_part2({splitter, tachyon}) do
    pos = find_next_splitter(tachyon, splitter)
    splitter_map = gen_splitter_map(Map.new(), pos, splitter)
    timelines_map = calc_timelines(splitter_map, Map.new([{nil, 1}]))
    Map.get(timelines_map, pos)
  end

  defp gen_splitter_map(known_nodes, pos, _) when pos == nil, do: known_nodes
  defp gen_splitter_map(known_nodes, pos, _) when is_map_key(known_nodes, pos), do: known_nodes

  defp gen_splitter_map(known_nodes, pos, splitter) do
    left = find_next_splitter({elem(pos, 0) - 1, elem(pos, 1)}, splitter)
    rigth = find_next_splitter({elem(pos, 0) + 1, elem(pos, 1)}, splitter)

    known_nodes
    |> Map.put(pos, {left, rigth})
    |> gen_splitter_map(left, splitter)
    |> gen_splitter_map(rigth, splitter)
  end

  defp find_next_splitter(pos, splitter) do
    splitter
    |> MapSet.filter(fn s ->
      elem(pos, 0) == elem(s, 0) && elem(pos, 1) < elem(s, 1)
    end)
    |> MapSet.to_list()
    |> Enum.min_by(&elem(&1, 1), fn -> nil end)
  end

  defp calc_timelines(splitter_map, solved_map) when map_size(splitter_map) == 0, do: solved_map

  defp calc_timelines(splitter_map, solved_map) do
    solveable_map =
      Map.filter(splitter_map, fn {_pos, {left, rigth}} ->
        Map.has_key?(solved_map, left) && Map.has_key?(solved_map, rigth)
      end)

    new_solved_map =
      solveable_map
      |> Map.to_list()
      |> Enum.map(fn {pos, {left, rigth}} ->
        {pos, Map.get(solved_map, left) + Map.get(solved_map, rigth)}
      end)
      |> Map.new()
      |> Map.merge(solved_map)

    cleaned_splitter_map = Map.drop(splitter_map, Map.keys(solveable_map))
    calc_timelines(cleaned_splitter_map, new_solved_map)
  end
end
