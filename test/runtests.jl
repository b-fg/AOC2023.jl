using AdventOfCode2023
using Revise, Test

@testset "Day 01" begin
    AdventOfCode2023.Day01.day01()
    @test AdventOfCode2023.Day01.day01() == (54304, 54418)
end