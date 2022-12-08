# https://adventofcode.com/2022/day/8
using AdventOfCode

testcase = split("""30373
25512
65332
33549
35390""", "\n")

function parse_input(input)
    map(x -> parse.(Int64, x), split.(input, ""))
end

function transpose(arr)
    return collect.(zip(arr...))
end

function visible(v)
    ret = zeros(eltype(v), length(v))
    for i in eachindex(v)
        if i == 1
            ret[i] = 1
        else
            if all(v[i] .> v[begin:i-1])
                ret[i] = 1
            end
        end
    end
    return ret
end

function seeing_distance(v)
    ret = zeros(eltype(v), length(v))
    for i in eachindex(v)
        if i == length(v)
            ret[i] = 0
        else
            val = v[i]
            tall_idx = findfirst(>=(val), v[i+1:end])
            if isnothing(tall_idx)
                ret[i] = length(v) - i
            else
                ret[i] = tall_idx
            end
        end
    end
    return ret
end

input = readlines("data/day_8.txt")

function part_1(input)
    trees = parse_input(input)
    left = seeing_distance.(trees)
    top = transpose(seeing_distance.(transpose(trees)))
    right = reverse.(seeing_distance.(reverse.(trees)))
    bottom =transpose(reverse.(seeing_distance.(reverse.(transpose(trees)))))
    tot = sum((left, top, right, bottom))
    isvis = map(x -> >(0).(x), tot)
    return sum(sum, isvis)
end
part_1(testcase)
@info part_1(input)

function part_2(input)
    trees = parse_input(input)
    right = seeing_distance.(trees)
    down = transpose(seeing_distance.(transpose(trees)))
    left = reverse.(seeing_distance.(reverse.(trees)))
    up =transpose(reverse.(seeing_distance.(reverse.(transpose(trees)))))
    mats = (x->x').(reduce.(hcat, (up, down, left, right)))
    return maximum(reduce( .* , mats))
end
part_2(testcase)

@info part_2(input)
