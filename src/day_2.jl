# https://adventofcode.com/2022/day/2
using AdventOfCode

####
#### input data
####

const input = readlines("data/day_2.txt")

const t1 = split("A Y\nB X\nC Z", "\n")

####
#### rules of the game
####

const points_dict = Dict(:rock => 1, :paper => 2, :scissors => 3)
const win_conditions = Dict(:rock => :scissors, :paper => :rock, :scissors => :paper)

####
#### input maps
####

const their_map = Dict("A" => :rock, "B" => :paper, "C" => :scissors)
const our_map = Dict("X" => :rock, "Y" => :paper, "Z" => :scissors)
const strategies = Dict("X" => :lose, "Y" => :draw, "Z" => :win)

####
#### part 1
####

function get_score(ours::Symbol, theirs::Symbol)
    score = points_dict[ours]
    theirs == ours && return score + 3
    win_condition = win_conditions[ours]
    if theirs == win_condition
        return score + 6
    else
        return score
    end
end

function get_score(ours::AbstractString, theirs::AbstractString)
    return get_score(our_map[ours], their_map[theirs])
end


function part_1(input)
    return sum(input) do row
        theirs, ours = split(row, " ")
        return get_score(ours, theirs)
    end
end

@info part_1(t1)
@info part_1(input)

####
#### part 2
####

function execute_evil_plan(outcome::Symbol, theirs::Symbol)
    if outcome == :draw
        return theirs
    elseif outcome == :win
        return Dict(zip(values(win_conditions), keys(win_conditions)))[theirs] # they are the loser
    else
        return win_conditions[theirs] # they are the winner
    end
end

function part_2(input)
    return sum(input) do row
        theirs, outcome = split(row, " ")
        theirs = their_map[theirs]
        ours = execute_evil_plan(strategies[outcome], theirs)
        return get_score(ours, theirs)
    end
end
@info part_2(t1)
@info part_2(input)
