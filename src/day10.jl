module Day10

using AdventOfCode2023, PaddedViews

const CI = CartesianIndex

fvert(pos, pos_prev) = pos_prev[1] < pos[1] ? pos + CI(1, 0) : pos - CI(1, 0)
fhori(pos, pos_prev) = pos_prev[2] < pos[2] ? pos + CI(0, 1) : pos - CI(0, 1)
fL(pos, pos_prev) = pos_prev[2] == pos[2] ? pos + CI(0, 1) : pos - CI(1, 0)
f7(pos, pos_prev) = pos_prev[2] == pos[2] ? pos - CI(0, 1) : pos + CI(1, 0)
fJ(pos, pos_prev) = pos_prev[2] == pos[2] ? pos - CI(0, 1) : pos - CI(1, 0)
fF(pos, pos_prev) = pos_prev[2] == pos[2] ? pos + CI(0, 1) : pos + CI(1, 0)
step_map = Dict('|' => fvert, '-' => fhori, 'L' => fL, '7' => f7, 'J' => fJ, 'F' => fF)

function find_first_step(S, grid)
    grid[S + CI(-1,  0)] in ['F', '7', '|'] && return CI(-1,  0)
    grid[S + CI( 1,  0)] in ['J', 'L', '|'] && return CI( 1,  0)
    grid[S + CI( 0, -1)] in ['F', 'L', '-'] && return CI( 0, -1)
    grid[S + CI( 0,  1)] in ['J', '7', '-'] && return CI( 0,  1)
end
function replace_S(S, bounds)
    prev, next = bounds[end], bounds[2]
    ΔI = next - prev
    any(iszero, Tuple(ΔI)) && prev[1] == next[1] && return '-'
    any(iszero, Tuple(ΔI)) && prev[2] == next[2] && return '|'
    ((S[1] == prev[1] && all(x -> sign(x) == 1, Tuple(ΔI))) || (S[2] == prev[2] && all(x -> sign(x) == -1, Tuple(ΔI)))) && return '7'
    ((S[1] == prev[1] && all(x -> sign(x) == -1, Tuple(ΔI))) || (S[2] == prev[2] && all(x -> sign(x) == 1, Tuple(ΔI)))) &&  return 'L'
    ((S[1] == prev[1] && sign(ΔI[1]) > sign(ΔI[2])) || (S[2] == prev[2] && sign(ΔI[1]) < sign(ΔI[2]))) && return 'F'
    ((S[1] == prev[1] && sign(ΔI[1]) < sign(ΔI[2])) || (S[2] == prev[2] && sign(ΔI[1]) > sign(ΔI[2]))) && return 'J'
end

const bound_patterns = ["L7", "FJ"] # these patterns should count as single boundary when ray casting
function inout_raycast_horizontal(pos, bounds, grid)
    ray = grid[[I for I in [CI(pos[1], j) for j in pos[2]:size(grid, 2)] if I in bounds && grid[I] != '-']] |> join # horizontal ray capturing the boundaries (without '-')
    return !(mod(length(ray) - sum(length(findall(p, ray)) for p in bound_patterns), 2) == 0)
end

function day10(input=readInput(10))
    grid = split(input, "\n") .|> collect |> x -> mapreduce(permutedims, vcat, x)
    grid_padded = PaddedView('.', grid, (0:size(grid, 1) + 1, 0:size(grid, 2) + 1))
    S = findfirst(x -> x == 'S', grid_padded)
    pos = S + find_first_step(S, grid_padded)
    bounds, count_p1, count_p2, pos_prev = CI[S, pos], 1, 0, S

    # Part 1
    while grid_padded[pos] != 'S'
        temp_pos = pos
        pos = step_map[grid_padded[pos]](pos, pos_prev)
        pos_prev = temp_pos
        push!(bounds, pos) # used in part 2
        count_p1 += 1
    end
    # Part 2
    grid[S] = replace_S(S, bounds[1:end-1])
    count_p2 = sum(inout_raycast_horizontal(I, bounds[1:end-1], grid) for I in CartesianIndices(grid) if !(I in bounds))

    return count_p1 ÷ 2, count_p2
end

end # module