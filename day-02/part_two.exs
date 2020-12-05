defmodule PasswordPhilosophy do
  @base_one_adjustment -1
  @filename "input.txt"
  @line_regex ~r/(?<index_one>\d+)-(?<index_two>\d+) (?<char>[a-z]): (?<password>[a-z]+)/

  def init do
    @filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&parse_line/1)
  end

  def parse_line(line) do
    Regex.named_captures(@line_regex, line)
  end

  def valid_passwords(values) do
    Enum.filter(values, &valid_password?/1)
  end

  def valid_password?(%{
        "char" => char,
        "index_one" => index_one,
        "password" => password,
        "index_two" => index_two
      }) do
    index_one = String.to_integer(index_one) + @base_one_adjustment
    index_two = String.to_integer(index_two) + @base_one_adjustment
    password_graphemes = String.graphemes(password)
    index_one_char = Enum.at(password_graphemes, index_one)
    index_two_char = Enum.at(password_graphemes, index_two)

    valid_char_index_placement?(index_one_char, index_two_char, char)
  end

  def valid_char_index_placement?(c, c, c), do: false
  def valid_char_index_placement?(c, _, c), do: true
  def valid_char_index_placement?(_, c, c), do: true
  def valid_char_index_placement?(_, _, _), do: false
end

values = PasswordPhilosophy.init()
result = length(PasswordPhilosophy.valid_passwords(values))

# 357 is too low
