defmodule HandheldHalting do
  def run(filename) do
    filename
    |> read_input()
    |> execute()
  end

  def read_input(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&to_instruction/1)
  end

  def to_instruction("acc" <> arg), do: {:acc, parse_arg(arg), false}
  def to_instruction("jmp" <> arg), do: {:jmp, parse_arg(arg), false}
  def to_instruction("nop" <> _), do: {:nop, nil, false}

  def parse_arg(arg) do
    arg
    |> String.trim()
    |> String.to_integer()
  end

  def execute(input) do
    execute(input, _step = 0, _index = 0, _acc = 0)
  end

  def execute(input, step, index, acc) do
    case Enum.at(input, index) do
      {_, _, true} ->
        IO.puts("Encountered infinite loop")
        IO.puts("Accumulator value is #{acc}")

      {:nop, nil, false} ->
        execute(
          List.update_at(input, index, fn _ -> {:nop, nil, true} end),
          step + 1,
          index + 1,
          acc
        )

      {:jmp, arg, false} ->
        execute(
          List.update_at(input, index, fn _ -> {:jmp, arg, true} end),
          step + 1,
          index + arg,
          acc
        )

      {:acc, arg, false} ->
        execute(
          List.update_at(input, index, fn _ -> {:acc, arg, true} end),
          step + 1,
          index + 1,
          acc + arg
        )
    end
  end
end
