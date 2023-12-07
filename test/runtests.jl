using AdventOfCode2023
using Revise, Test

@testset "Day 01" begin
    AdventOfCode2023.Day01.day01()
    @test AdventOfCode2023.Day01.day01() == (54304, 54418)
end

@testset "Day 02" begin
    AdventOfCode2023.Day02.day02()
    @test AdventOfCode2023.Day02.day02() == (2563, 70768)
end

@testset "Day 03" begin
    AdventOfCode2023.Day03.day03()
    @test AdventOfCode2023.Day03.day03() == (507214, 72553319)
end

@testset "Day 04" begin
    AdventOfCode2023.Day04.day04()
    @test AdventOfCode2023.Day04.day04() == (15205, 6189740)
end

@testset "Day 05" begin
    AdventOfCode2023.Day05.day05()
    @test AdventOfCode2023.Day05.day05() == (157211394, 50855035)
end

@testset "Day 06" begin
    AdventOfCode2023.Day06.day06()
    @test AdventOfCode2023.Day06.day06() == (633080, 20048741)
end