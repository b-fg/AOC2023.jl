module Day13

using AdventOfCode2023

flip(a, dim) = selectdim(a, dim, size(a, dim):-1:1)
partition(a, i, dim) = (selectdim(a, dim, 1:i), selectdim(a, dim, i+1:size(a, dim)))
function find_reflection(grid, dim)
    for r in 1:size(grid, dim)-1
        g1, g2 = partition(grid, r, dim)
        size(g1, dim) <= size(g2, dim) && flip(g1, dim) == selectdim(g2, dim, 1:size(g1, dim)) && return r
        size(g1, dim) > size(g2, dim) && selectdim(flip(g1, dim), dim, 1:size(g2, dim)) == g2 && return r
    end
    return 0
end
function find_smudge(grid, dim)
    for r in 1:size(grid, dim)-1
        g1, g2 = partition(grid, r, dim)
        size(g1, dim) <= size(g2, dim) && sum(flip(g1, dim) .!= selectdim(g2, dim, 1:size(g1, dim))) == 1 && return r
        size(g1, dim) > size(g2, dim) && sum(selectdim(flip(g1, dim), dim, 1:size(g2, dim)) .!= g2) == 1 && return r
    end
    return 0
end

function day13(input=readInput(13))
    grids = split(input, "\n\n") .|> x -> split(x, '\n') .|> collect |> x -> mapreduce(permutedims, vcat, x)
    count_p1, count_p2 = 0, 0
    for grid in grids, dim in 1:ndims(grid)
        p, q = find_reflection(grid, dim), find_smudge(grid, dim)
        count_p1 += dim == 1 ? 100 * p : p
        count_p2 += dim == 1 ? 100 * q : q
    end

    return count_p1, count_p2
end

end # module