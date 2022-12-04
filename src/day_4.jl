# https://adventofcode.com/2022/day/4
using AdventOfCode
using BenchmarkTools

const t1 = split("""2-4,6-8
2-3,4-5
5-7,7-9
2-8,3-7
6-6,4-6
2-6,4-8""", "\n")

input = readlines("data/day_4.txt")

function part_1(input)
    return sum(input) do line
        groups = (Set ∘ eval ∘ Meta.parse).(replace.(split(line, ","), "-"=>":"))
        return length(union(groups...)) == maximum(length.(groups))
    end
end

part_1(t1)

@btime part_1(input)

function part_2(input)
    return sum(input) do line
        groups = (Set ∘ eval ∘ Meta.parse).(replace.(split(line, ","), "-"=>":"))
        return length(intersect(groups...)) > 0
    end
end
@btime part_2(t1)

@btime part_2(input)
