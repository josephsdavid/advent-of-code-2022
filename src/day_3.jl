# https://adventofcode.com/2022/day/3
using AdventOfCode

const t1=split("""vJrwpWtwJgWrhcsFMMfFFhFp
jqHRNqRjqzjGDLGLrsFMfFZSrLrFZsSL
PmmdzqPrVvPwwTWBwg
wMqvLMZHhHMvwLHjbvcjnnSBnvTQFn
ttgJtRGJQctTZtZT
CrZsJsPPZsGzwwsLwLmpwMDw""")

input = readlines("data/day_3.txt")

function to_int(c::Char)
    ret = Int(c) - 96
    isuppercase(c) && return ret + 58
    return ret
end

function to_int(s::AbstractString)
    length(s) > 1 && throw(error("you are bad"))
    return to_int(s[1])
end

function part_1(input)
    sum(split.(input, "")) do rucksack
        rucksack = to_int.(rucksack)
        return only(intersect!(Set.(eachcol(@views reshape(rucksack, :, 2)))...))
    end
end

@info part_1(input)

function slide(z,w)
    ((@view z[i:i+w-1]) for i in 1:w:length(z)-w+1)
end

function part_2(input)
    input = map(input) do item
        return to_int.(split(item, ""))
    end
    sum(slide(input, 3)) do row
        only(intersect!(Set.(row)...))
    end
end

@info part_2(input)
