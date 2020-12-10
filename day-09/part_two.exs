defmodule EncodingError do
  @invalid_number 88311122

  def run(filename) do
    filename
    |> init()
    |> find_contiguous()
  end

  def init(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.to_integer/1)
  end

  def find_contiguous(input) do
    find_contiguous(input, %{buffer: [], sum: 0})
  end

  def find_contiguous(_, %{sum: @invalid_number, buffer: buffer}) do
    IO.puts "Found match!"
    buffer
  end

  def find_contiguous([_|remaining], %{sum: sum}) when sum > @invalid_number do
    find_contiguous(remaining, %{buffer: [], sum: 0})
  end

  def find_contiguous(input, context = %{sum: sum, buffer: buffer}) when sum < @invalid_number do
    index = Enum.count(buffer)
    new_val = Enum.at(input, index)
    
    find_contiguous(input, %{context | sum: sum + new_val, buffer: [new_val|buffer]})
  end
end

result = EncodingError.run("input.txt")
min = Enum.min(result)
max = Enum.max(result)
sum = min + min

IO.puts "Min: #{min}, Max: #{max}, Sum: #{min + max}"
# Min: 3698072, Max: 9851297, Sum: 13549369