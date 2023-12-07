module Day06

using AdventOfCode2023, Revise

function day06(input::String=readInput(06))
    function beat_race_n(time, distance)
        race_counter = 0
        for t in floor(Int, time / 2):-1:1 # backward loop over half of the (symmetric) domain
            if (t * (time - t) > distance) race_counter += 1
            else break
            end
        end
        return mod(time, 2) == 0 ? 2 * race_counter - 1 : 2 * race_counter
    end

    races_p1 = split(strip(input), "\n") .|>
        x -> split(x, ":")[end] .|>
        x -> parse.(Int, split(x, " "; keepempty=false))

    # Part 1
    count_p1 = 1
    for (time, distance) in zip(races_p1...)
        race_counter = beat_race_n(time, distance)
        count_p1 *= race_counter
    end

    # Part 2
    count_p2 = [parse(Int, join(string.(r))) for r in races_p1] |> x -> beat_race_n(x...)

    return count_p1, count_p2
end

end # module