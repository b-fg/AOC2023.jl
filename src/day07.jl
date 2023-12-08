module Day07

using AdventOfCode2023, Revise

const cards_p1 = "AKQJT98765432"
const cards_p2 = "AKQT98765432J"

struct Hand
    cards :: String
    bid :: Int
    strength :: Int # 1 to 7
    order :: String
end

function Base.isless(hand1::Hand, hand2::Hand)
    hand1.strength != hand2.strength && return hand1.strength < hand2.strength
    for (i, j) in zip(hand1.cards, hand2.cards)
        findfirst(i, hand1.order) == findfirst(j, hand2.order) && continue
        return findfirst(i, hand1.order) > findfirst(j, hand2.order)
    end
    return true
end

function strength(hand, part)
    set = Set(hand)
    counter = Dict{Char, Int}(s => sum(s == c for c in hand) for s in set)
    vals = values(counter)
    5 in vals && return 7
    if part == 1
        4 in vals && return 6
        3 in vals && 2 in vals && return 5
        3 in vals && return 4
        2 in vals && length(set) == 3 && return 3
        2 in vals && return 2
        return 1
    else
        4 in vals && 'J' in set && return 7
        4 in vals && return 6
        3 in vals && 2 in vals && 'J' in set && return 7
        3 in vals && 2 in vals && return 5
        3 in vals && 'J' in set && return 6
        3 in vals && return 4
        2 in vals && length(set) == 3 && 'J' in set && counter['J'] == 2 && return 6
        2 in vals && length(set) == 3 && 'J' in set && return 5
        2 in vals && length(set) == 3 && return 3
        2 in vals && 'J' in set && return 4
        (2 in vals || 'J' in set) && return 2
        return 1
    end
end

function day07(input::String=readInput(07))
    hands_p1 = [Hand(hand[1], parse(Int, hand[2]), strength(hand[1], 1), cards_p1) for hand in split.(split(strip(input), "\n"), " ")]
    hands_p2 = [Hand(hand[1], parse(Int, hand[2]), strength(hand[1], 2), cards_p2) for hand in split.(split(strip(input), "\n"), " ")]
    return tuple([sum(hand.bid * i for (i, hand) in enumerate(sort(hands))) for hands in [hands_p1, hands_p2]]...)
end

end # module