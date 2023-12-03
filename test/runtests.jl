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