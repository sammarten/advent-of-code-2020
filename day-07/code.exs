r = ~r/(?<bag>[\w|\s]+)\sbags contain/
r = ~r/(?<bag>[\w|\s]+)\sbags contain\s(?<contains>((?<num>\d)\s(<?color>[\w|\s]+)[\.|,])+)/
Regex.named_captures(r, "dotted violet bags contain 4 posh indigo bags, 5 light aqua bags, 5 dark plum bags.")

line = "light red bags contain 1 bright white bag, 2 muted yellow bags."
[bag, contains] = String.slice(line, 0..-2) |> String.split(" contain ")

contains = String.split(contains, ", ")

r = ~r/(?<)