module Day11

using AdventOfCode2023, Combinatorics

const expand_p1 = 2
const expand_p2 = 1e6

norm(I::CartesianIndex{2}) = abs(I[1]) + abs(I[2])
empty_space(grid) = (
    [i for (i, row) in enumerate(eachrow(grid)) if all(x -> x == '.', row)],
    [j for (j, col) in enumerate(eachcol(grid)) if all(x -> x == '.', col)],
)
function shortest_path(g1, g2, empty_rows, empty_cols, n=2)
    d = norm(g2 - g1)
    d += sum(n - 1 for r in empty_rows if (g1[1] < r < g2[1]) || (g1[1] > r > g2[1]); init=0)
    d += sum(n - 1 for c in empty_cols if (g1[2] < c < g2[2]) || (g1[2] > c > g2[2]); init=0)
end

function day11(input=readInput(11))
    grid = split(input, "\n") .|> collect |> x -> mapreduce(permutedims, vcat, x)
    galaxies = findall(x -> x == '#', grid)
    empty_rows, empty_cols = empty_space(grid)
    return sum(shortest_path(g1, g2, empty_rows, empty_cols, expand_p1) for (g1, g2) in combinations(galaxies, 2)),
           sum(shortest_path(g1, g2, empty_rows, empty_cols, expand_p2) for (g1, g2) in combinations(galaxies, 2))
end

end # module