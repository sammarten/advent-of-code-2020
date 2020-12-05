defmodule PassportProcessing do
  @required_keys MapSet.new([:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid])

  def run(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.map(&String.trim/1)
    |> Enum.reduce(%{current: "", passports: []}, &join_passport_data/2)
    |> Map.get(:passports)
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&to_keyword_list/1)
    |> IO.inspect(limit: :infinity)
    |> Enum.filter(&is_valid_passport/1)
  end

  defp join_passport_data("", %{current: current, passports: passports}) do
    %{current: "", passports: [current | passports]}
  end

  defp join_passport_data(data, %{current: "", passports: passports}) do
    %{current: data, passports: passports}
  end

  defp join_passport_data(data, %{current: current, passports: passports}) do
    %{current: current <> " " <> data, passports: passports}
  end

  defp to_keyword_list(data) do
    Enum.map(data, &to_key_value/1)
  end

  defp to_key_value(data) do
    [key, value] = String.split(data, ":")
    {String.to_atom(key), value}
  end

  defp is_valid_passport(passport) do
    keys =
      passport
      |> Keyword.keys()
      |> MapSet.new()

    MapSet.subset?(@required_keys, keys)
  end
end

passports = PassportProcessing.run("input.txt")

# 212 is too low
