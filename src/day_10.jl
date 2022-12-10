# https://adventofcode.com/2022/day/10
using AdventOfCode

input = readlines("data/day_10.txt")

t1 = ["noop", "addx 3", "addx -5"]
t2 = readlines("data/d10test.txt")



function part_1(input)
    clock = Int64[1]
    register_x = Int64[1]
    history = [first.((clock, register_x))]
    current_cycle = first(clock)
    for op in input
        current_cycle += 1
        if op == "noop"
            push!(clock, current_cycle)
            push!(history, last.((clock, register_x)))
            continue
        end
        (op, val) = split(op)
        op != "addx" && throw(ArgumentError("can only parse addx and noop"))
        to_add = parse(Int64, val)
        push!(clock, current_cycle)
        push!(history, last.((clock, register_x)))
        current_cycle += 1
        push!(register_x, register_x[end] + to_add)
        push!(clock, current_cycle)
        push!(history, last.((clock, register_x)))
    end
    ret = length(history) < 20 ? history : history[20:40:end]
    return sum(x -> *(x...), ret)
end
part_1(t1)
part_1(t2)
part_1(input)

function part_2(input)
    clock = Int64[1]
    register_x = Int64[1]
    history = [first.((clock, register_x))]
    current_cycle = first(clock)
    for op in input
        current_cycle += 1
        if op == "noop"
            push!(clock, current_cycle)
            push!(history, last.((clock, register_x)))
            continue
        end
        (op, val) = split(op)
        op != "addx" && throw(ArgumentError("can only parse addx and noop"))
        to_add = parse(Int64, val)
        push!(clock, current_cycle)
        push!(history, last.((clock, register_x)))
        current_cycle += 1
        push!(register_x, register_x[end] + to_add)
        push!(clock, current_cycle)
        push!(history, last.((clock, register_x)))
    end
    xbounds = collect(1:40)
    ybounds = 1:6
    pixels = repeat([0], 241)
    onscreen = map(history) do h
        @show h
        (cycle, sprite) = h
        hassprite = any(map(x -> x ∈ (xbounds), [sprite, sprite - 1, sprite + 1]))
        if any(hassprite)
            pixels[cycle] = 1
        end
    end
    pixels
    popfirst!(pixels)
    ret = reshape(pixels, 6, 40)
    for row in eachrow(ret)
        println(row)
    end

end
part_2(input)
