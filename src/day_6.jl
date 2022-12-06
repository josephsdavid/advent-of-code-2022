# https://adventofcode.com/2022/day/6
using AdventOfCode
using BenchmarkTools
using Test

input = readchomp("data/day_6.txt")

const t1 = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"


slide(z,w,step=1) = ((@view z[i:i+w-1]) for i in 1:step:length(z)-w+1)
marker(input, w=4) = first(first(filter(x -> length(unique(x[2])) == w, collect(enumerate(slide(input, w)))))) + w-1
part_1(input) = marker(input)
part_2(input) = marker(input, 14)


function solve_fast(z, w, step = 1)
    @simd for i in 1:step:length(z)-2+1
        x = @inbounds view(z,i:i+w-1)
        if length(unique(x)) == w
            return i + w -1
        end
    end
end

p1_fast(x) = solve_fast(x, 4)
p2_fast(x) = solve_fast(x, 14)

@testset "day 6" begin
    test_p1(inp, val) = @test part_1(inp) == val == p1_fast(inp)
    @testset "part 1" begin
        test_p1(t1, 7)
        test_p1("bvwbjplbgvbhsrlpgdmjqwftvncz", 5)
        test_p1("nppdvjthqldpwncqszvftbrmjlhg", 6)
        test_p1("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 10)
        test_p1("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 11)
    end
    test_p2(inp, val) = @test part_2(inp) == val == p2_fast(inp)
    @testset "part 2" begin
        test_p2(t1, 19)
        test_p2("bvwbjplbgvbhsrlpgdmjqwftvncz", 23)
        test_p2("nppdvjthqldpwncqszvftbrmjlhg", 23)
        test_p2("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 29)
        test_p2("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 26)
    end
end

@info "part 1, no optimization"
@info @btime part_1(input)

@info "part 1, optimized?"
@info @btime p1_fast(input)

@info "part 2, no optimization"
@info @btime part_2(input)

@info "part 2, optimized?"
@info @btime p2_fast(input)
