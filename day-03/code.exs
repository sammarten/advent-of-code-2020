defmodule TobogganTrajectory do
  @filename "input.txt"

  def init do
    @filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.with_index()
    |> Enum.reduce(%{}, fn {line, index}, acc -> Map.put(acc, index, String.graphemes(line)) end)
  end

  def count_trees_on_path(patterns, rise, run) do
    solve(%{
      row: 0,
      col: 0,
      rise: rise,
      run: run,
      line_length: length(patterns[0]),
      tree_count: 0,
      patterns: patterns,
      num_rows: Enum.count(patterns)
    })
  end

  defp solve(attrs) do
    if attrs.row >= attrs.num_rows, do: attrs, else: advance(attrs)
  end

  defp advance(attrs) do
    repeated_pattern =
      attrs.patterns[attrs.row]
      |> List.duplicate(repeat_times(attrs.col, attrs.line_length))
      |> Enum.reduce(&Enum.concat/2)

    tree_count =
      if Enum.at(repeated_pattern, attrs.col) == "#" do
        attrs.tree_count + 1
      else
        attrs.tree_count
      end

    repeated_pattern
    |> List.replace_at(attrs.col, tree_count)
    |> Enum.join()
    |> IO.puts()

    row = attrs.row + attrs.rise
    col = attrs.col + attrs.run

    solve(%{attrs | row: row, col: col, tree_count: tree_count})
  end

  defp repeat_times(col, line_length) do
    trunc(col / line_length) + 1
  end
end

patterns = TobogganTrajectory.init()

# patterns[1]
[{1, 1}, {3, 1}, {5, 1}, {7, 1}, {1, 2}]
|> Enum.map(fn {run, rise} -> TobogganTrajectory.count_trees_on_path(patterns, rise, run) end)
|> Enum.map(fn attrs -> attrs.tree_count end)

[{1, 1}]
|> Enum.map(fn {run, rise} -> TobogganTrajectory.count_trees_on_path(patterns, rise, run) end)
|> Enum.map(fn attrs -> attrs.tree_count end)
