defmodule SeatingSystem do
  def run(filename) do
    filename
    |> init()
    |> stabilize()
  end

  def init(filename) do
    input =
      filename
      |> File.read!()
      |> String.split("\n")
      |> Enum.map(&String.graphemes/1)

    num_rows = length(input)

    num_cols = length(List.first(input))

    layout =
      input
      |> Stream.with_index()
      |> Enum.reduce(%{}, &process_row/2)

    %{last_row: num_rows - 1, last_col: num_cols - 1, layout: layout}
  end

  def process_row({positions, row_num}, layout) do
    positions
    |> Stream.with_index()
    |> Enum.reduce(layout, fn {position, col_num}, acc ->
      Map.put(acc, {row_num, col_num}, position)
    end)
  end

  def stabilize(args = %{layout: layout}) do
    print(layout, args.last_col, args.last_row)
    updated_layout = update_layout(args)

    if updated_layout == layout do
      IO.puts("Stabilized!")
      layout
    else
      stabilize(Map.put(args, :layout, updated_layout))
    end
  end

  def update_layout(args = %{layout: layout}) do
    Enum.reduce(layout, %{}, &process_position(&1, &2, args))
  end

  def process_position({_, "."}, layout, _), do: layout

  def process_position({{r, c}, "#"}, layout, args) do
    if get_adjacent(r, c, args) >= 4 do
      Map.put(layout, {r, c}, "L")
    else
      layout
    end
  end

  def process_position({{r, c}, "L"}, layout, args) do
    if get_adjacent(r, c, args) == 0 do
      Map.put(layout, {r, c}, "#")
    else
      layout
    end
  end

  def get_adjacent(row, col, %{layout: layout, last_col: last_col, last_row: last_row}) do
    [
      {row - 1, col - 1},
      {row - 1, col},
      {row - 1, col + 1},
      {row, col - 1},
      {row, col + 1},
      {row + 1, col - 1},
      {row + 1, col},
      {row + 1, col + 1}
    ]
    |> Enum.filter(fn {r, c} -> r >= 0 && r <= last_row && c >= 0 && c <= last_col end)
    |> Enum.map(&Map.get(layout, &1))
    |> Enum.filter(&(&1 == "#"))
    |> Enum.count()
  end

  def print(layout, last_col, last_row) do
    Enum.map(
      0..last_row,
      fn row ->
        IO.inspect(["row", row])

        IO.puts(
          Enum.reduce(0..last_col, "", fn col, acc ->
            IO.inspect(["col", col])
            acc <> Map.get(layout, {row, col})
          end)
        )
      end
    )

    IO.puts("")
    IO.puts("")
  end
end
