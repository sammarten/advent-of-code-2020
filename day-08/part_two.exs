defmodule HandheldHalting do
  def run(filename) do
    filename
    |> read_input()
    |> update_and_execute(0)
  end

  def read_input(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&to_instruction/1)
    |> Enum.concat([{:success, nil, false}])
  end

  def to_instruction("acc" <> arg), do: {:acc, parse_arg(arg), false}
  def to_instruction("jmp" <> arg), do: {:jmp, parse_arg(arg), false}
  def to_instruction("nop" <> arg), do: {:nop, parse_arg(arg), false}

  def parse_arg(arg) do
    arg
    |> String.trim()
    |> String.to_integer()
  end

  def update_and_execute(input, flip_index) do
    {updated_input, flip_index} = flip_operations(input, flip_index)

    case execute(updated_input, _step = 0, _index = 0, _acc = 0, flip_index) do
      {:error, flip_index} ->
        IO.puts("Encountered error")
        IO.puts("flip_index is #{flip_index}")
        IO.puts("Restarting...")
        update_and_execute(input, flip_index + 1)

      :success ->
        nil
    end
  end

  def execute(input, step, index, acc, flip_index) do
    case Enum.at(input, index) do
      {_, _, true} ->
        {:error, flip_index}

      {:nop, arg, false} ->
        execute(
          List.update_at(input, index, fn _ -> {:nop, arg, true} end),
          step + 1,
          index + 1,
          acc,
          flip_index
        )

      {:jmp, arg, false} ->
        execute(
          List.update_at(input, index, fn _ -> {:jmp, arg, true} end),
          step + 1,
          index + arg,
          acc,
          flip_index
        )

      {:acc, arg, false} ->
        execute(
          List.update_at(input, index, fn _ -> {:acc, arg, true} end),
          step + 1,
          index + 1,
          acc + arg,
          flip_index
        )

      {:success, nil, false} ->
        IO.puts("Success!")
        IO.puts("Accumulator value is #{acc}")
        IO.puts("Flip index is #{flip_index}")
        :success
    end
  end

  def flip_operations(input, flip_index) do
    case Enum.at(input, flip_index) do
      {:nop, arg, false} ->
        {List.update_at(input, flip_index, fn _ -> {:jmp, arg, false} end), flip_index}

      {:jmp, arg, false} ->
        {List.update_at(input, flip_index, fn _ -> {:nop, arg, false} end), flip_index}

      {:acc, _, _} ->
        flip_operations(input, flip_index + 1)

      error ->
        IO.puts("Error! Should never happen")
        IO.inspect(error)
    end
  end
end
