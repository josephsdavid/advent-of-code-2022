# https://adventofcode.com/2022/day/13
using AdventOfCode
using BenchmarkTools

function parse_input_data(input)
    map(split(input, "\n\n")) do pair
        lhs, rhs = split(pair)
        return (eval ∘ Meta.parse).((lhs, rhs))
    end
end

compare(x::Int64, y::Int64) = x < y
compare(x::Int64, y::AbstractVector) = compare([x], y)
compare(x::AbstractVector, y::Int64) = compare(x, [y])
compare(tup::Tuple) = compare(tup...)

function compare(xc::AbstractVector, yc::AbstractVector)
    x = deepcopy(xc)
    y = deepcopy(yc)
    while !isempty(x)
        if isempty(y)
            return false
        end
        lhs = popfirst!(x)
        rhs = popfirst!(y)
        if lhs != rhs
            ret = compare(lhs, rhs)
            return ret
        end
    end
    return true
end

part_1(input) = sum(compare.(input) .* (1:length(input)))
part_1(s::AbstractString) = part_1(parse_input_data(readchomp(s)))

part_1("data/d13t1.txt")
@info @btime part_1("data/day_13.txt")

part_2(s::AbstractString) = part_2(parse_input_data(readchomp(s)))

function parse_input_data_fancy(input)
    ret = []
    foreach(parse_input_data(input)) do (p1, p2)
        push!(ret, p1)
        push!(ret, p2)
    end
    return ret
end

t1 = parse_input_data_fancy(readchomp("data/d13t1.txt"))
input = parse_input_data_fancy(readchomp("data/day_13.txt"))

function part_2(input)
    vecs = copy(input)
    push!(vecs, [[2]])
    push!(vecs, [[6]])
    sort!(vecs; lt=compare)
    return findfirst(==([[2]]), vecs) * findfirst(==([[6]]), vecs)
end
part_2(t1)
@info part_2(input)
