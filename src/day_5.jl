# https://adventofcode.com/2022/day/5
using AdventOfCode
using BenchmarkTools

const t1 =
"""    [D]
[N] [C]
[Z] [M] [P]
 1   2   3

move 1 from 2 to 1
move 3 from 1 to 3
move 2 from 2 to 1
move 1 from 1 to 2"""

const input = readchomp("data/day_5.txt")


function parse_boxes(boxes)
    boxes = split(boxes, "\n")
    cols = pop!(boxes)
    index_map = Dict()
    foreach(enumerate(cols)) do item
        column = tryparse(Int64, string(last((item))))
        isnothing(column) && return nothing
        index_map[first(item)] = column
    end

    ret = Dict(v => String[] for v in values(index_map))

    box_items = findall.(isletter, boxes)
    box_letters = filter.(isletter, boxes)

    for (items, letters) in zip(box_items, box_letters)
        for (item, letter) in zip(items, letters)
            push!(ret[index_map[item]], string(letter))
        end
    end
    return ret

end

function move_boxes!(boxes, n, source, dest)
    n == 0 && return boxes
    pushfirst!(boxes[dest], popfirst!(boxes[source]))
    return move_boxes!(boxes, n-1, source, dest)
end

function move_boxes_fancy!(boxes, n, source, dest)
    tmp = String[]
    for _ in 1:n
        push!(tmp, popfirst!(boxes[source]))
    end
    prepend!(boxes[dest], tmp)
    return boxes
end

function move_boxes!(boxes, s::AbstractString; fancy = false)
    instructions = split(s, " ")
    instructions = tryparse.(Int64, instructions)
    instructions = filter(!isnothing, instructions)
    n, source, dest = instructions
    if !fancy
        return move_boxes!(boxes, n, source, dest)
    else
        return move_boxes_fancy!(boxes, n, source, dest)
    end
end

function part_1(input)
    boxes, instructions = split(input, "\n\n")
    boxes = parse_boxes(boxes)
    for instruction in split(instructions, "\n")
        boxes = move_boxes!(boxes, instruction)
    end
    ret = []
    for k in sort(collect(keys(boxes)))
        push!(ret, first(boxes[k]))
    end
    return string(ret...)
end
part_1(t1)

@info "part 1" @btime part_1(input)

function part_2(input)
    boxes, instructions = split(input, "\n\n")
    boxes = parse_boxes(boxes)
    for instruction in split(instructions, "\n")
        boxes = move_boxes!(boxes, instruction; fancy = true)
    end
    ret = []
    for k in sort(collect(keys(boxes)))
        push!(ret, first(boxes[k]))
    end
    return string(ret...)
end
part_2(t1)

@info "part 2" @btime part_2(input)
