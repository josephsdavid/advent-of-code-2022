# https://adventofcode.com/2022/day/6
using AdventOfCode
using Test

input = readchomp("data/day_6.txt")

const t1 = "mjqjpqmgbljsphdztnvjfqwrcgsmlb"


slide(z,w,step=1) = ((@view z[i:i+w-1]) for i in 1:step:length(z)-w+1)

marker(input, w=4) = first(filter(x -> length(unique(x[2])) == length(x[2]), collect(enumerate(slide(input, w)))))

function part_1(input)
    return first(marker(input)) + 3
end

test_p1(inp, val) = @test part_1(inp) == val
@testset "part 1" begin
    test_p1(t1, 7)
    test_p1("bvwbjplbgvbhsrlpgdmjqwftvncz", 5)
    test_p1("nppdvjthqldpwncqszvftbrmjlhg", 6)
    test_p1("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 10)
    test_p1("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 11)
end

@info part_1(input)

function part_2(input)
    return first(marker(input, 14)) + 13
end

test_p2(inp, val) = @test part_2(inp) == val
@testset "part 2" begin
    test_p2(t1, 19)
    test_p2("bvwbjplbgvbhsrlpgdmjqwftvncz", 23)
    test_p2("nppdvjthqldpwncqszvftbrmjlhg", 23)
    test_p2("nznrnfrfntjfmvfwmzdfjlvtqnbhcprsg", 29)
    test_p2("zcfzfwzzqfrljwzlrfnpqdbhtmscgvjw", 26)
end

@info part_2(input)
