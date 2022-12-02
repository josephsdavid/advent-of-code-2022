# https://adventofcode.com/2022/day/1
using AdventOfCode

input = read("2022/data/day_1.txt")

parse_input(s) = parse.(Int64, filter(!isempty, split.(split(s, "\n\n"), "\n")))

function part_1(input)
    return maximum(sum, parse_input(input))
end
@info part_1(input)

function part_2(input)
    return (sort ∘ sum ∘ x -> last(x, 3))(sum.(parse_input(input)))
end
@info part_2(input)
