defmodule BinaryBoarding do
  @row_vals [64, 32, 16, 8, 4, 2, 1]
  @seat_vals [4, 2, 1]

  def init(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&decode_boarding_pass/1)
  end

  defp decode_boarding_pass(boarding_pass) do
    {row, seat} =
      boarding_pass
      |> String.graphemes()
      |> Enum.split(7)

    row_num = decode_row_num(row)
    seat_num = decode_seat_num(seat)
    seat_id = calc_seat_id(row_num, seat_num)

    %{row_num: row_num, seat_num: seat_num, seat_id: seat_id}
  end

  defp decode_row_num(row) do
    row
    |> mask_row()
    |> calc_row()
  end

  defp mask_row(row) do
    Enum.map(row,
      fn 
        "F" -> 0
        "B" -> 1
      end)
  end

  defp calc_row(masked_row) do
    masked_row
    |> Enum.zip(@row_vals)
    |> Enum.reduce(0, fn {m, v}, acc -> acc + (m * v) end)
  end

  defp decode_seat_num(seat) do
    seat
    |> mask_seat()
    |> calc_seat()
  end

  defp mask_seat(seat) do
    Enum.map(seat,
      fn
        "L" -> 0
        "R" -> 1
      end)
  end

  defp calc_seat(masked_seat) do
    masked_seat
    |> Enum.zip(@seat_vals)
    |> Enum.reduce(0, fn {m, v}, acc -> acc + (m * v) end)
  end

  defp calc_seat_id(row_num, seat_num), do: (row_num * 8) + seat_num
end

results = BinaryBoarding.init("input.txt")

results |> Enum.map(&(&1.seat_id)) |> Enum.max()

results |> Enum.map(&(&1.seat_id)) |> Enum.max()
# 848

length(results)
# 816

results |> Enum.map(&(&1.seat_id)) |> Enum.min()
# 32

t = 32..848 |> Enum.sum()
# 359480

u = results |> Enum.map(&(&1.seat_id)) |> Enum.sum()
# 358798

t - u
# 682