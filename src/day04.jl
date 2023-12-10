module Day04

using AdventOfCode2023

function count_gains(card)
    winning_numbers, numbers = split(card, " | ") .|> x -> parse.(Int, split(x, " "; keepempty=false))
    return intersect(Set(winning_numbers), Set(numbers)) |> length
end

function day04(input=readInput(04))
    cards = [split(c, ": ")[end] for c in split(input, "\n")]
    count_p1, copies = 0, ones(Int, length(cards))
    for (i, card) in enumerate(cards)
        n_intersect = count_gains(card)
        count_p1 += n_intersect > 0 ? 2 ^ (n_intersect - 1) : 0 # Part 1
        copies[i + 1:i + n_intersect] .+= copies[i] # Part 2
    end

    return count_p1, sum(copies)
end

end # module