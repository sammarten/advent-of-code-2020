defmodule HandyHaversacks do
  def run(filename) do
    reference = build_reference(filename)

    reference
    |> Map.keys()
    |> Enum.reduce(%{}, &find_all_contained(&1, &2, reference))
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

  def find_all_contained(color, acc, reference) do
    contained =
      reference[color]
      |> Stream.map(& &1.color)
      |> Enum.map(&find_contained(&1, reference))
      |> List.flatten()

    Map.put(acc, color, contained)
  end

  defp find_contained(color, reference) do
    case reference[color] do
      [] ->
        [color]

      contained ->
        [color | contained |> Stream.map(&(&1.color)) |> Enum.map(&find_contained(&1, reference))]
    end
  end
end

# result = HandyHaversacks.run("input.txt")
# count = Enum.filter(result, fn {_, bags} -> "shiny gold" in bags end) |> Enum.count()
# 355
