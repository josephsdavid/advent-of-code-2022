# https://adventofcode.com/2022/day/4
using AdventOfCode

input = readlines("data/day_4.txt")

function part_1(input)
    return sum(input) do line
        groups = (Set ∘ eval ∘ Meta.parse).(replace.(split(line, ","), "-"=>":"))
        return length(union(groups...)) == maximum(length.(groups))
    end
end
@info  part_1(input)

function part_2(input)
    return sum(input) do line
        groups = (Set ∘ eval ∘ Meta.parse).(replace.(split(line, ","), "-"=>":"))
        return length(intersect(groups...)) > 0
    end
end
@info  part_2(input)
