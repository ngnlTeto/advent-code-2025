defmodule AdventCode2025.Day8 do
  @input_file Path.join(__DIR__, "../../inputs/day8.txt")

  def run do
    input = File.read!(@input_file) |> parse
    %{task1: run_part1(input), task2: run_part2(input)}
  end

  defp parse(input) do
    input
    |> String.trim()
    |> String.split("\n")
    |> Enum.map(fn l ->
      l
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)
      |> List.to_tuple()
    end)
  end

  defp run_part1(boxes) do
    # Build union-find structure
    uf = build_union_find(boxes)

    # Calculate all pairwise distances and sort
    distances = calc_all_distances(boxes)

    # Connect the 1000 closest pairs
    uf_final =
      distances
      |> Enum.slice(0..999)
      |> Enum.reduce(uf, fn {_dist, idx1, idx2}, acc ->
        union(acc, idx1, idx2)
      end)

    boxes
    |> Enum.with_index()
    |> Enum.map(fn {_box, idx} -> find(uf_final, idx) end)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.sort(:desc)
    |> Enum.slice(0..2)
    |> Enum.reduce(1, &(&1 * &2))
  end

  defp run_part2(_boxes) do
    nil
  end

  # Union-Find (Disjoint Set Union) implementation
  defp build_union_find(boxes) do
    boxes
    |> Enum.with_index()
    |> Map.new(fn {_box, idx} -> {idx, idx} end)
  end

  defp find(uf, x) do
    parent = Map.get(uf, x)

    if parent == x do
      x
    else
      find(uf, parent)
    end
  end

  defp union(uf, x, y) do
    root_x = find(uf, x)
    root_y = find(uf, y)

    if root_x == root_y do
      uf
    else
      Map.put(uf, root_x, root_y)
    end
  end

  defp calc_all_distances(boxes) do
    boxes
    |> Enum.with_index()
    |> Enum.reduce([], fn {box1, idx1}, acc ->
      Enum.reduce(
        Enum.with_index(boxes),
        acc,
        fn {box2, idx2}, acc2 ->
          if idx1 < idx2 do
            dist = calc_distance(box1, box2)
            [{dist, idx1, idx2} | acc2]
          else
            acc2
          end
        end
      )
    end)
    |> Enum.sort_by(&elem(&1, 0), :asc)
  end

  defp calc_distance({x1, y1, z1}, {x2, y2, z2}) do
    dx = x1 - x2
    dy = y1 - y2
    dz = z1 - z2
    :math.sqrt(dx * dx + dy * dy + dz * dz)
  end
end
