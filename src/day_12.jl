# https://adventofcode.com/2022/day/12
using AdventOfCode

input = readlines("data/day_12.txt")

t1 = split("""Sabqponm
abcryxxl
accszExk
acctuvwj
abdefghi""", "\n")

struct Node
    elevation::Int64
    parents::AbstractVector
    children::AbstractVector
    cartesian::CartesianIndex
end

function parse_char(c)
    if c == 'S'
        return -1
    elseif c == 'E'
        return -2
    else
        return c - 'a'
    end
end

const up = CartesianIndex(-1, 0)
const down = CartesianIndex(1, 0)
const left = CartesianIndex(0, -1)
const right = CartesianIndex(0, 1)
const directions = [up, down, left, right]

function possible_movements(arr, ci::CartesianIndex, indices::CartesianIndices)
    neighbor_idxs = map( x-> x + ci,directions)
    filter!(∈(indices), neighbor_idxs)
    values = map(x -> arr[x], neighbor_idxs)
    hasend = findall( ==(-2), values)
    if !isempty(hasend)
        return neighbor_idxs[only(hasend)]
    end
        good_indices = findall( x ->  abs(arr[ci] - x) < 2, values)
        return neighbor_idxs[good_indices]
    return
end

function get_paths(arr, index=CartesianIndex(1, 1),indices=CartesianIndices(arr), seen = Set(), paths = [])
    current_elevation = arr[index]
    current_elevation == -2 && return paths
    poss = possible_movements(arr, index, indices)
    filter!(!∈(seen), poss)
    foreach(poss) do p
        push!(paths, get_paths(arr, p, indices, seen, paths))
    end
    return paths
end


function part_1(input)

    chars = (z -> [x for x in z]).(input)
    elevation_map = parse_char.(reduce(hcat, chars))
    indices = CartesianIndices(elevation_map)
    idx = first(indices)
    # XXX:  aaa


end
@info part_1(input)

function part_2(input)
    nothing
end
@info part_2(input)
