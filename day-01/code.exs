defmodule ReportRepair do
  @filename "input.txt"

  def init do
    "input.txt"
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def combinations(list, num)
  def combinations(_list, 0), do: [[]]
  def combinations(list = [], _num), do: list

  def combinations([head | tail], num) do
    Enum.map(combinations(tail, num - 1), &[head | &1]) ++
      combinations(tail, num)
  end

  def solve(combinations) do
    combinations
    |> Enum.filter(&total_equals(&1, 2020))
    |> IO.inspect()
    |> List.first()
    |> Enum.reduce(1, &(&1 * &2))
  end

  def total_equals(vals, num), do: Enum.sum(vals) == num
end

values = ReportRepair.init()
combinations = ReportRepair.combinations(values, 3)
result = ReportRepair.solve(combinations)
