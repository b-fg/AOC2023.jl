module AdventOfCode2023

# Using https://github.com/goggle/AdventOfCode2021.jl as template

using Revise
using BenchmarkTools
using Printf
using OutMacro; export @out
using DelimitedFiles; export readdlm

solvedDays = [i for i ∈ 1:3]

# Read the input from a file:
function readInput(path::String)
    s = open(path, "r") do file
        read(file, String)
    end
    return s
end
function readInput(day::Integer)
    path = joinpath(@__DIR__, "..", "data", @sprintf("day%02d.txt", day))
    return readInput(path)
end
export readInput

# Utility function to decode images:
function generate_image(image)
    block = '\u2588'
    empty = ' '
    output = ""
    for i = 1:axes(image, 2)
        row = join(image[:, i])
        row = replace(row, "#" => block)
        row = replace(row, "." => empty)
        output *= row * "\n"
    end
    return output
end
export generate_image

# Include the source files:
for day in solvedDays
    ds = @sprintf("%02d", day)
    include(joinpath(@__DIR__, "day$ds.jl"))
end

# Export a function `dayXY` for each day:
for d in solvedDays
    global ds = @sprintf("day%02d.txt", d)
    global modSymbol = Symbol(@sprintf("Day%02d", d))
    global dsSymbol = Symbol(@sprintf("day%02d", d))

    @eval begin
        input_path = joinpath(@__DIR__, "..", "data", ds)
        function $dsSymbol(input::String = readInput($d))
            return AdventOfCode2023.$modSymbol.$dsSymbol(input)
        end
        export $dsSymbol
    end
end

# Benchmark a list of different problems:
function benchmark(days=solvedDays)
    results = []
    for day in days
        modSymbol = Symbol(@sprintf("Day%02d", day))
        fSymbol = Symbol(@sprintf("day%02d", day))
        input = readInput(joinpath(@__DIR__, "..", "data", @sprintf("day%02d.txt", day)))
        @eval begin
            bresult = @benchmark(AdventOfCode2023.$modSymbol.$fSymbol($input))
        end
        push!(results, (day, time(bresult), memory(bresult)))
    end
    return results
end
export benchmark

# Write the benchmark results into a markdown string:
function _to_markdown_table(bresults)
    header = "| Day | Time | Allocated memory |\n" *
             "|----:|-----:|-----------------:|"
    lines = [header]
    for (d, t, m) in bresults
        ds = string(d)
        ts = BenchmarkTools.prettytime(t)
        ms = BenchmarkTools.prettymemory(m)
        push!(lines, "| $ds | $ts | $ms |")
    end
    return join(lines, "\n")
end

end # module AdventOfCode2023