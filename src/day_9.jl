# https://adventofcode.com/2022/day/9
using AdventOfCode

input = readlines("data/day_9.txt")

t1 = split("""R 4
       U 4
       L 3
       D 1
       R 4
       D 1
       L 5
       R 2""",
           "\n")

function part_1(input)
    t = [0, 0]
    h = [0, 0]
    tpath = [t]
    hpath = [h]
    for row in input
        direction, magnitude = split(row, " ")
        mag = parse(Int64, magnitude)

        if direction == "U"
            basis = [0, 1]
        elseif direction == "D"
            basis = [0, -1]
        elseif direction == "R"
            basis = [1, 0]
        else
            basis = [-1, 0]
        end

        for _ in 1:mag
            h += basis
            push!(hpath, h)

            delta = h .- t
            if all(@. abs(delta) < 2)
                continue
            end

            t += sign.(delta)
            push!(tpath, t)
        end
    end
    return length(unique(tpath))
end
part_1(t1)

@info part_1(input)

function update_tail(h, t)
    delta = h .- t
    if all(@. abs(delta) < 2)
        return t
    else
        return t .+ sign.(delta)
    end
end

function part_2(input)
    h = [0, 0]
    tail = map(x -> [0, 0], 1:9)
    tpath = [last(tail)]
    hpath = [h]
    for row in input
        direction, magnitude = split(row, " ")
        mag = parse(Int64, magnitude)

        if direction == "U"
            basis = [0, 1]
        elseif direction == "D"
            basis = [0, -1]
        elseif direction == "R"
            basis = [1, 0]
        else
            basis = [-1, 0]
        end

        for i in 1:mag
            h += basis
            push!(hpath, h)

            temp_head = h
            for i in eachindex(tail)
                delta = temp_head .- tail[i]

                if all(@. abs(delta) < 2)
                    temp_head = tail[i]
                    continue
                end

                tail[i] += sign.(delta)
                temp_head = tail[i]
            end
            @show last(tail)

            push!(tpath, last(tail))
        end
    end
    return length(unique(tpath))
end
part_2(t1)

t2 = ["R 5", "U 8", "L 8", "D 3", "R 17", "D 10", "L 25", "U 20"]
part_2(t2)

@info part_2(input)
