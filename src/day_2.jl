# https://adventofcode.com/2022/day/2
using AdventOfCode

const input = readlines("data/day_2.txt")

const t1 = split("A Y\nB X\nC Z", "\n")

const score_dict = Dict(:rock => 1, :paper => 2, :scissors => 3)
const win_conditions = Dict(:rock => :scissors, :paper => :rock, :scissors => :paper)
const their_map = Dict("A" => :rock, "B" => :paper, "C" => :scissors)
const our_map = Dict("X" => :rock, "Y" => :paper, "Z" => :scissors)
const moves = (:rock, :paper, :scissors)

function get_score(ours::Symbol, theirs::Symbol)
    score = score_dict[ours]
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
    score = 0
    foreach(input) do row
        theirs, ours = split(row, " ")
        round_score = get_score(ours, theirs)
        score += round_score
    end
    return score
end

@info part_1(t1)
@info part_1(input)

const strategies = Dict("X" => :lose, "Y" => :draw, "Z" => :win)

function strategize(outcome::Symbol)
    if outcome == :draw
        return identity
    elseif outcome == :win
        return (theirs) -> Dict(values(win_conditions), keys(win_conditions))[theirs] # they are the loser
    else
        return (theirs) -> win_conditions[theirs] # they are the winner
    end
end

function part_2(input)
    score = 0
    foreach(input) do row
        theirs, plan = split(row, " ")
        theirs = their_map[theirs]
        ours = strategize(strategies[plan])(theirs)
        round_score = get_score(ours, theirs)
        score += round_score
    end
    return score
end

@info part_2(t1)
@info part_2(input)
