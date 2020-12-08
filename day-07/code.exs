defmodule HandyHaversacks do
  def run(filename) do
    reference = build_reference(filename)

    reference
    |> Map.keys()
    |> Enum.map(&find_all_contained(&1, reference))
  end

  def build_reference(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Stream.map(&String.slice(&1, 0..-2))
    |> Stream.map(&String.split(&1, " bags contain "))
    |> Enum.reduce(%{}, &process_haversack/2)
  end

  def find_all_contained(color, reference) do
    if reference[color] == [] do
      []
    else
      reference[color]
      |> Enum.map(& &1.color)
      |> Enum.flat_map(&find_all_contained(&1, reference))
    end
  end

  def process_haversack([bag, "no other bags"], acc) do
    Map.put(acc, bag, [])
  end

  def process_haversack([bag, contains], acc) do
    contained_bags =
      contains
      |> String.split(", ")
      |> Enum.map(&process_contained_haversack/1)

    Map.put(acc, bag, contained_bags)
  end

  defp process_contained_haversack(haversack) do
    r = ~r/(?<num>\d+)\s(?<color>[\w|\s]+)\sbags?/
    captures = Regex.named_captures(r, haversack)
    %{color: captures["color"], number: String.to_integer(captures["num"])}
  end
end

# r = ~r/(?<bag>[\w|\s]+)\sbags contain\s(?<contains>((?<num>\d)\s(<?color>[\w|\s]+)[\.|,])+)/

# Regex.named_captures(
#   r,
#   "dotted violet bags contain 4 posh indigo bags, 5 light aqua bags, 5 dark plum bags."
# )

# line = "light red bags contain 1 bright white bag, 2 muted yellow bags."
# [bag, contains] = String.slice(line, 0..-2) |> String.split(" contain ")

# contains = String.split(contains, ", ")

# r = ~r/(?<bag>[\w|\s]+)\sbags contain (?<contains>(\d [\w|\s]+[,|.])+\s?)+/
# Regex.named_captures(r, line)
