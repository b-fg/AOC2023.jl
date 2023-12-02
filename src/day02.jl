module Day02

using AdventOfCode2023

max_cubes = Dict("red" => 12, "green" => 13, "blue" => 14)

function day02(input::String=readInput(02))
    function check_ilegal_game(game)
        for play ∈ split(split(game, ": ")[2], "; ")
            for cubes ∈ split(play, ", ")
                red_ilegal = occursin("red", cubes) && parse(Int, split(cubes, " red")[1]) > max_cubes["red"]
                green_ilegal = occursin("green", cubes) && parse(Int, split(cubes, " green")[1]) > max_cubes["green"]
                blue_ilegal = occursin("blue", cubes) && parse(Int, split(cubes, " blue")[1]) > max_cubes["blue"]
                (red_ilegal || green_ilegal || blue_ilegal) && return true
            end
        end
        return false
    end

    function check_minimum_set(game)
        red_max, green_max, blue_max = 0, 0, 0
        for play ∈ split(split(game, ": ")[2], "; ")
            for cubes ∈ split(play, ", ")
                if occursin("red", cubes)
                    red_max = max(red_max, parse(Int, split(cubes, " red")[1]))
                elseif occursin("green", cubes)
                    green_max = max(green_max, parse(Int, split(cubes, " green")[1]))
                elseif occursin("blue", cubes)
                    blue_max = max(blue_max, parse(Int, split(cubes, " blue")[1]))
                end
            end
        end
        return red_max * green_max * blue_max
    end

    games = split(strip(input), "\n")
    count_p1, count_p2 = 0, 0
    for (i, game) ∈ enumerate(games)
        count_p1 += check_ilegal_game(game) ? 0 : i
        count_p2 += check_minimum_set(game)
    end

    return count_p1, count_p2
end

end # module