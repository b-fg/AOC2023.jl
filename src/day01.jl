module Day01

using AdventOfCode2023

const patterns = [
    "one" => "o1e",
    "two"=>"t2o",
    "three"=>"t3e",
    "four" => "f4r",
    "five" => "f5e",
    "six" => "s6x",
    "seven" => "s7n",
    "eight" => "e8t",
    "nine" => "n9e",
]

function filter_and_sum(line)
    digits = filter!(isdigit, collect.(line))
    sum(parse.(Int, join(digits[[1, length(digits)]])))
end

function day01(input=readInput(01))
    corrupted_values = split(input, "\n")

    # Part 1
    count_p1 = 0
    for line ∈ corrupted_values
        count_p1 += filter_and_sum(line)
    end

    # Part2
    count_p2 = 0
    for line ∈ corrupted_values
        for p in patterns
            line = replace(line, p)
        end
        count_p2 += filter_and_sum(line)
    end

    return count_p1, count_p2
end

end # module