defmodule PasswordPhilosophy do
  @filename "input.txt"
  @line_regex ~r/(?<l_bound>\d+)-(?<u_bound>\d+) (?<char>[a-z]): (?<password>[a-z]+)/

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
        "l_bound" => l_bound,
        "password" => password,
        "u_bound" => u_bound
      }) do
    l_bound = String.to_integer(l_bound)
    u_bound = String.to_integer(u_bound)

    char_count =
      password
      |> String.graphemes()
      |> Enum.filter(&(&1 == char))
      |> Enum.count()

    char_count >= l_bound && char_count <= u_bound
  end
end

values = PasswordPhilosophy.init()
result = length(PasswordPhilosophy.valid_passwords(values))
