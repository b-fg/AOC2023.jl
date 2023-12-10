module Day03

using AdventOfCode2023, PaddedViews

function generate_matrix(input)
    lines = split(input, "\n")
    m = Matrix{Char}(undef, length(lines), length(lines[1]))
    for i ∈ axes(m, 1), j ∈ axes(m, 2)
        m[i, j] = lines[i][j]
    end
    PaddedView('.', m, (0:size(m, 1) + 1, 0:size(m, 2) + 1))
end

function day03(input=readInput(03))
    m = generate_matrix(input)

    # Part 1
    j_min, j_max, count_p1 = 0, 0, 0
    for i ∈ 1:size(m, 1) - 1, j ∈ 1:size(m, 2) - 1
        if all(isdigit, m[i, j]) && j_min == 0
            j_min = j
        elseif !all(isdigit, m[i, j]) && j_min != 0 # number fully parsed, so we check bounding box
            j_max = j - 1
            bb = [CartesianIndex(x, y) for x ∈ i - 1:i + 1 for y ∈ j_min - 1:j_max + 1]
            if any(k -> k != '.' && !all(isdigit, k), m[bb])
                count_p1 += parse(Int, join(m[i, j_min:j_max]))
            end
            j_min = 0
        end
    end

    # Part 2
    j_min, j_max, numbers, gears, count_p2 = 0, 0, Int[], Dict(), 0
    for i ∈ 1:size(m, 1) - 1, j ∈ 1:size(m, 2) - 1
        if all(isdigit, m[i, j]) && j_min == 0
            j_min = j
        elseif !all(isdigit, m[i, j]) && j_min != 0 # number fully parsed, so we check if * in bounding box
            j_max = j - 1
            push!(numbers, parse(Int, join(m[i, j_min:j_max]))) # save number
            gs = findall(x -> x=='*', m[i - 1:i + 1, j_min - 1:j_max + 1]) # find gears in bounding box
            for g in gs
                CI = g + CartesianIndex(i - 2, j_min - 2)
                gears[CI] = haskey(gears, CI) ? push!(gears[CI], length(numbers)) : [length(numbers)] # save number linked to gear
            end
            j_min = 0
        end
    end
    for (_, linked_numbers) in gears
        count_p2 += length(linked_numbers) > 1 ? prod(numbers[linked_numbers]) : 0 # if gear has more than 1 number linked, product
    end

    return count_p1, count_p2
end

end # module