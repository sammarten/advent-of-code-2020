defmodule Combinations do
  def generate(list, num)
  def generate(_list, 0), do: [[]]
  def generate(list = [], _num), do: list

  def generate([head | tail], num) do
    Enum.map(generate(tail, num - 1), &[head | &1]) ++
      generate(tail, num)
  end
  
end

defmodule EncodingError do
  @preamble 25
  @step 1
  @combination_size 2

  def run(filename) do
    filename
    |> init()
    |> process()
  end

  def init(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Stream.map(&String.to_integer/1)
    |> Stream.chunk_every(@preamble + 1, @step)
    |> Stream.map(&Enum.reverse/1)
    |> Enum.map(fn [first|remaining] -> {first, remaining |> Enum.filter(&(&1 < first)) |> Combinations.generate(@combination_size)} end)
  end

  def process(input) do
    Enum.reject(input, 
      fn {val, combinations} -> 
        Enum.any?(combinations, 
          fn [a, b] -> (a + b) == val end) 
      end)
  end
end

# Part One: 88311122
