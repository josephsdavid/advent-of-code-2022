# https://adventofcode.com/2022/day/11
using AdventOfCode
using BenchmarkTools

input = readlines("data/day_11.txt")
t1 = readlines("data/d11t1.txt")

const OPS = Dict("*"=>*,"/"=>/,"+"=>+, "-"=>-)

clean(input) = filter(!isempty, input)

function get_monkeys(input)
    monkeys = []
    for monkey in filter(x -> !isspace(first(x)), clean(input))
        push!(monkeys, Int128[])
    end
    return monkeys
end

function run_operation(inp, lhs, op, rhs)
    op = OPS[op]
    (lhs, rhs) = map(x -> x == "old" ? inp : parse(Int128, x), (lhs, rhs))
    return op(lhs, rhs)
end

function get_operations(input)
    operations = filter(x -> occursin("Operation", x), input)
    map(operations) do op
        op = split(op, "=")[end]
        lhs, op, rhs = split(op)
        return x -> run_operation(x, lhs, op, rhs)
    end
end

isdivisible(x, y) = x % y == 0
parselast(x) = parse(Int128, last(split(x)))

function get_conditions(input)
    cids = findall(x -> occursin("Test", x), input)
    map(cids) do cid
        testval = parselast(input[cid])
        t = parselast(input[cid + 1]) + 1
        f = parselast(input[cid + 2]) + 1
        return x -> isdivisible(x, testval) ? t : f
    end
end

function resolve_worry(input)
    input = filter(x -> occursin("Test", x), input)
    resolver = reduce(*, parselast.(input))
    return x -> x % resolver
end

function initialize!(input, monkeys = get_monkeys(input))
    starting_items = filter(x -> occursin("Starting", x), input)
    for (i, items) in enumerate(starting_items)
        append!(monkeys[i], parse.(Int128, split(last(split(items, ":")), ",")))
    end
    operations = get_operations(input)
    conditions = get_conditions(input)
    return monkeys, operations, conditions
end

function part_1(input)
    monkeys, operations, conditions = initialize!(input)
    monkey_counts = zeros(length(monkeys))
    @show monkeys
    for round in 1:20
        for i in 1:length(monkeys)
            monkey = copy(monkeys[i])
            cond = conditions[i]
            op = eval(operations[i])
            for _ in 1:length(monkey)
                monkey_counts[i] += 1
                worry = popfirst!(monkey)
                worry = op(worry)
                push!(monkeys[cond(worry)], worry)
            end
            monkeys[i] = monkey
        end
    end
    partialsort!(monkey_counts, 2, rev = true)
    return *(monkey_counts[1:2]...)
end
part_1(t1)
@info part_1(input)

function part_2(input)
    monkeys, operations, conditions = initialize!(input)
    monkey_counts = zeros(length(monkeys))
    resolver = resolve_worry(input)
    for round in 1:10000
        for i in 1:length(monkeys)
            @inbounds monkey = monkeys[i]
            @inbounds cond = conditions[i]
            @inbounds op = eval(operations[i])
            for _ in 1:length(monkey)
                @inbounds monkey_counts[i] += 1
                worry = popfirst!(monkey)
                worry = op(worry)
                worry = resolver(worry)
                push!(monkeys[cond(worry)], worry)
            end
            @inbounds monkeys[i] = monkey
        end
    end
    partialsort!(monkey_counts, 2, rev = true)
    return *(monkey_counts[1:2]...)
end
@info "part 2"
@info part_2(t1)
@info @btime part_2(input)
