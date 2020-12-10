defmodule HandyHaversacks do
  @shiny_gold "shiny gold"

  def run(filename) do
    reference = build_reference(filename)

    reference
    |> Map.get(@shiny_gold)
    |> find_all_contained(reference)
  end

  def build_reference(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Stream.map(&String.slice(&1, 0..-2))
    |> Stream.map(&String.split(&1, " bags contain "))
    |> Enum.reduce(%{}, &process_haversack/2)
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

  def find_all_contained(bags, reference) when is_list(bags) do
    bags
    |> Enum.map(&find_contained(&1, reference))
    |> List.flatten()
    |> Enum.reduce(0, &(&1.number + &2))
  end

  defp find_contained(bag = %{color: color, number: number}, reference) do
    case reference[color] do
      [] ->
        [number]

      contained ->
        [bag | Enum.map(contained, &find_contained(&1, reference))]
    end
  end
end

# result = HandyHaversacks.run("input.txt")
# 201 is too low
# tricky because you have to carry the number of bags down
# would almost be easier to expand
