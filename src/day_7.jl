# https://adventofcode.com/2022/day/7
using AdventOfCode

t1 = split("""\$ cd /
\$ ls
dir a
14848514 b.txt
8504156 c.dat
dir d
\$ cd a
\$ ls
dir e
29116 f
2557 g
62596 h.lst
\$ cd e
\$ ls
584 i
\$ cd ..
\$ cd ..
\$ cd d
\$ ls
4060174 j
8033020 d.log
5626152 d.ext
7214296 k""", "\n")

mutable struct Tree
    type::Any
    name::Any
    parent::Any
    children::Any
    value::Any
end

Tree() = Tree(:file, "test", nothing, [], 0)
Tree(type, name) = Tree(type, name, nothing, [], 0)
Tree(type, name, size) = Tree(type, name, nothing, [], size)
Tree(type, name, size, parent) = Tree(type, name, parent, [], size)

function parse_command(current, trees, command)
    if command[2] == "ls"
        return current, trees
    else
        if command[3] == ".."
            current = current.name =="/" ? "/" : current.parent
            return current, trees
        elseif command[3] == "/"
            current = first(trees)
            return current, trees
        else
            current = only(
                filter( x -> x.name == command[3] && x.type == :dir, current.children),
            )
            return current, trees
        end
    end
end

function make_trees(input)
    trees = [Tree(:dir, "/")]
    current = only(trees)
    for command in input
        command = split(command)
        if command[1] == "\$"
            current, trees = parse_command(current, trees, command)
        else
            if command[1] == "dir"
                t = Tree(:dir, command[2], 0, current)
            else
                t = Tree(:file, command[2], parse(Int64, command[1]), current)
            end
            push!(current.children, t)
            push!(trees, t)
        end
    end
    return trees
end

function score(t::Tree)
    if t.type == :dir
        if isempty(t.children)
            return 0
        end
        return sum(score, t.children)
    else
        return t.value
    end
end

input = readlines("data/day_7.txt")

function part_1(input)
    trees = make_trees(input)
    dirs = filter(x -> x.type==:dir, trees)
    sum(filter(<=(100000), score.(dirs)))
end
part_1(input)

const maxsize = 70000000
const needed_size = 30000000

function part_2(input)
    trees = make_trees(input)
    scores = score.(filter(x -> x.type==:dir, trees))
    total_size = maximum(scores)
    to_chop = needed_size - (maxsize - total_size)
    filter!(>(to_chop), scores)
    return minimum(scores)
end
part_2(input)
