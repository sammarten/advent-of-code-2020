defmodule PassportProcessing do
  @required_keys MapSet.new([:byr, :iyr, :eyr, :hgt, :hcl, :ecl, :pid])

  def run(filename) do
    filename
    |> File.read!()
    |> String.split("\n")
    |> Enum.chunk_by(&(&1 == ""))
    |> Enum.reject(&(&1 == [""]))
    |> Enum.map(&Enum.join(&1, " "))
    |> Enum.map(&String.split(&1, " "))
    |> Enum.map(&to_keyword_list/1)
    |> Enum.filter(&is_valid_passport/1)
  end

  defp to_keyword_list(data) do
    Enum.map(data, &to_key_value/1)
  end

  defp to_key_value(data) do
    [key, value] = String.split(data, ":")
    {String.to_atom(key), value}
  end

  defp is_valid_passport(passport) do
    has_required_fields(passport) && fields_are_valid(passport)
  end

  defp has_required_fields(passport) do
    keys =
      passport
      |> Keyword.keys()
      |> MapSet.new()

    MapSet.subset?(@required_keys, keys)
  end

  defp fields_are_valid(passport) do
    Enum.reduce(passport, true,
      fn
        _, false -> false
        {:byr, v}, _ -> valid_birth_year?(v)
        {:iyr, v}, _ -> valid_issue_year?(v)
        {:eyr, v}, _ -> valid_expiration_year?(v)
        {:hgt, v}, _ -> valid_height?(v)
        {:hcl, v}, _ -> valid_hair_color?(v)
        {:ecl, v}, _ -> valid_eye_color?(v)
        {:pid, v}, _ -> valid_passport_id?(v)
        {:cid, _}, _ -> true
      end)
  end

  defp valid_birth_year?(birth_year) do
    case Integer.parse(birth_year) do
      {year, ""} when year in 1920..2002 -> true
      _ -> false
    end
  end

  defp valid_issue_year?(issue_year) do
    case Integer.parse(issue_year) do
      {year, ""} when year in 2010..2020 -> true
      _ -> false
    end
  end

  defp valid_expiration_year?(expiration_year) do
    case Integer.parse(expiration_year) do
      {year, ""} when year in 2020..2030 -> true
      _ -> false
    end
  end

  defp valid_height?(height) do
    r = ~r/(?<num>\d+)(?<unit>cm|in)/
    case Regex.named_captures(r, height) do
      %{"num" => num, "unit" => "cm"} ->
        String.to_integer(num) in 150..193

      %{"num" => num, "unit" => "in"} ->
        String.to_integer(num) in 59..76

      _ -> 
        false
    end
  end

  defp valid_hair_color?(hair_color) do
    r = ~r/\A#[0-9a-f]{6}\z/
    Regex.match?(r, hair_color)
  end

  defp valid_eye_color?(eye_color) do
    eye_color in ["amb", "blu", "brn", "gry", "grn", "hzl", "oth"]
  end

  def valid_passport_id?(passport_id) do
    r = ~r/\A\d{9}\z/
    Regex.match?(r, passport_id)
  end
end

# passports = PassportProcessing.run("input.txt")

# 212 is too low

# Answer is 213. I'm not getting the last value. Gotta be an error in join_password_data/2.

# 147 is answer for part two.