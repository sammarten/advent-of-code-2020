defmodule CustomCustoms do
  @group_divider ""

  def run(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.chunk_by(&(&1 == @group_divider))
    |> Enum.reject(&(&1 == [@group_divider]))
    |> Enum.map(&uniq_yes_responses/1)
    |> Enum.map(&Enum.count/1)
    |> Enum.sum()
  end

  defp uniq_yes_responses(group_responses) do
    [first | remaining] = Enum.map(group_responses, &String.graphemes/1)

    Enum.reduce(
      remaining,
      MapSet.new(first), 
      fn response, acc ->
        MapSet.intersection(acc, MapSet.new(response))
      end)
  end
end