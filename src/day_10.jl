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
    popfirst!(history)
    history = zip(first.(history) .- 1, last.(history))
    row = 1
    col = 1
    # get_current_pixel(cycle) = cycle - row * 40
    # pixels = repeat([0], 241)
    pixels = zeros(Int64, 6, 40)
    for (cycle, sprite) in history
        if col > 40
            col = 1
            row += 1
        end
        if any( ==(col).((sprite, sprite+1, sprite-1)))
            pixels[row, col] = 1
        end
        col += 1
    end
    pixels
    for row in eachrow(pixels)
        println()
        for col in row
            print(col == 1 ? "#" : ".")
        end
    end
end
part_2(input)
