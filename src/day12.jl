module Day12

using AdventOfCode2023, Combinatorics

const n_unfolds = 5

function parse_input(input)
    r = split(input, "\n") .|> x -> split(x, " ") |> x -> (x[1], parse.(Int, split(x[2], ",")))
    return first.(r), last.(r)
end

function check_ilegal(record, blocks, idxs)
    new_record = collect(record)
    new_record[idxs] .= '#'
    new_record = join(new_record) |> x -> replace(x, "?" => ".")
    return length(split(new_record, '.'; keepempty=false)) == length(blocks) && # same number of blocks
        all(length.(split(new_record, '.'; keepempty=false)) .== blocks) # same size for each block
end

function day12(input=readInput(12))
    springs, lists = parse_input(input)

    # Part 1: check all possible combinations and discard the ilegal ones
    arrengements_p1 = zeros(Int, length(springs))
    for (i, (record, list)) in enumerate(zip(springs, lists))
        unknowns = findall(x -> x == '?', record)
        missing_damaged = sum(list) - count('#', record)
        arrengements_p1[i] = sum(check_ilegal(record, list, idxs) for idxs in combinations(unknowns, missing_damaged))
    end
    @out sum(arrengements_p1)

    # Part 2: Instead of unfolding x5, we unfold only x2 and check the scaling from x1 to x2. Then extrapolate to x5.
    arrengements_x2 = zeros(Int, length(springs))
    Threads.@threads for i in eachindex(springs)
        @out i
        record = repeat(springs[i] * "?", 2)[1:end-1]
        list = repeat(lists[i], 2)
        unknowns = findall(x -> x == '?', record)
        missing_damaged = sum(list) - count('#', record)
        # @out binomial(length(unknowns), missing_damaged)
        arrengements_x2[i] = sum(check_ilegal(record, list, idxs) for idxs in combinations(unknowns, missing_damaged))
    end
    arrengements_p2 = Int.([p1 * (x2 / p1)^(n_unfolds - 1) for (p1, x2) in zip(arrengements_p1, arrengements_x2)])
    @out arrengements_p2
    @out sum(arrengements_p2)

    return sum(arrengements_p1), sum(arrengements_p2)
end

end # module