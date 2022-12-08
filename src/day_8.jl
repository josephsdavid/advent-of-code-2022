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

function do_then_undo(x, f, args...)
    backward = ∘(args...)
    forward = ∘(reverse(args)...)
    return backward(f(forward(x)))

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

vis(x) = visible.(x)
rev(x) = reverse.(x)

function part_1(input)
    trees = parse_input(input)

    left = vis(trees)
    top = do_then_undo(trees, vis, transpose)
    right = do_then_undo(trees, vis, rev)
    bottom = do_then_undo(trees, vis, transpose, rev)

    tot = sum((left, top, right, bottom))
    isvis = map(x -> >(0).(x), tot)
    return sum(sum, isvis)
end
part_1(testcase)
@info part_1(input)

see(x) = seeing_distance.(x)

function part_2(input)
    trees = parse_input(input)

    right = see(trees)
    down = do_then_undo(trees, see, transpose)
    left = do_then_undo(trees, see, rev)
    up = do_then_undo(trees, see, transpose, rev)

    mats = reduce.(hcat, (up, down, left, right))
    return maximum(reduce( .* , mats))
end
part_2(testcase)

@info part_2(input)
