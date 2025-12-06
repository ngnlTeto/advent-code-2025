# Still needs optimizations

defmodule AdventCode2025.Day6 do
  @input_file Path.join(__DIR__, "../../inputs/day6.txt")
  def run do
    file_content = File.read!(@input_file)
    problems = file_content |> parse

    %{task1: run_part1(problems), task2: run_part2(problems)}
  end

  defp parse(input) do
    lines =
      input
      |> String.split("\n", trim: true)
      |> Enum.reverse()
      |> Enum.map(fn l -> l <> " " end)

    [operator_line | number_lines] = lines

    operator_matches =
      Regex.scan(~r/[+*]\W+?(?=[+*]|$)/, operator_line) |> Enum.map(&Enum.at(&1, 0))

    {tasks, _pos} =
      Enum.reduce(operator_matches, {[], 0}, fn operator_match, {tasks, pos} ->
        range = pos..(pos + String.length(operator_match) - 2)

        task_lines =
          number_lines
          |> Enum.map(&String.slice(&1, range))
          # this reverse killed me https://tenor.com/bmGGR.gif
          |> Enum.reverse()

        new_tasks = tasks ++ [%{task: task_lines, operator: String.trim(operator_match)}]

        {new_tasks, range.last + 2}
      end)

    tasks
  end

  defp run_part1(problems) do
    problems
    |> Enum.map(&solve/1)
    |> Enum.sum()
  end

  defp run_part2(problems) do
    new_problems =
      problems
      |> Enum.map(fn p ->
        task_lines =
          Enum.map(p.task, &String.graphemes/1)
          |> transpose()
          |> transpose()
          |> transpose()
          |> Enum.map(&Enum.join/1)

        %{task: task_lines, operator: p.operator}
      end)

    new_problems
    |> Enum.map(&solve/1)
    |> Enum.sum()
  end

  defp solve(problem) do
    numbers =
      problem.task
      |> Enum.map(&String.trim/1)
      |> Enum.map(&String.to_integer/1)

    case problem.operator do
      "+" -> numbers |> join(&Kernel.+/2)
      "*" -> numbers |> join(&Kernel.*/2)
    end
  end

  defp transpose(enum) do
    enum
    |> Enum.zip()
    |> Enum.map(&Tuple.to_list/1)
  end

  defp join(enum, func) do
    Enum.reduce(enum, &func.(&1, &2))
  end
end
