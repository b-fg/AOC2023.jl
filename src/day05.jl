module Day05

using AdventOfCode2023

# Part 1 utils
function seed_to_location(seed, maps)
    for category in maps
        for map in category
            if seed in map[2]:map[2] + map[3]
                seed = map[1] + (seed - map[2])
                break
            end
        end
    end
    return seed
end

# Part 2 utils
shift_range(seed_range, offset) = seed_range.start + offset:seed_range.start + offset + length(seed_range) - 1
diff_range(r1, r2) = ifelse(r1.stop > r2.stop, r2.stop + 1:r1.stop, r1.start:r2.start - 1)
function propagate_range(seed_range, maps, min_loc) # recursive range propagation
    for (i, category) in enumerate(maps)
        for (map_range, offset) in category
            range_intersect = intersect(seed_range, map_range)
            if length(range_intersect) == length(seed_range) # full overlap
                seed_range = shift_range(seed_range, offset)
                break
            elseif length(range_intersect) > 0 # partial overlapped
                seed_range = diff_range(seed_range, map_range)
                shifted_range = shift_range(range_intersect, offset)
                loc = propagate_range(shifted_range, maps[i + 1:end], min_loc)
                min_loc = min(min_loc, loc)
            end
        end
    end
    return min(min_loc, seed_range.start)
end

function parse_input(input)
    out = split.(split(input, "\n\n"), ":") .|>
        x -> split(x[end], "\n"; keepempty=false) .|>
        x -> parse.(Int, split(x, " "; keepempty=false))
    return out[1][1], out[2:end]
end

function day05(input=readInput(05))
    seeds_p1, maps = parse_input(input)

    # Part 1
    min_loc_p1 = Int(1e9)
    for seed in seeds_p1
        min_loc_p1 = min(seed_to_location(seed, maps), min_loc_p1)
    end

    # Part 2
    seeds_p2 = [c[1]:c[1]+c[2]-1 for c in reshape(seeds_p1, 2, :) |> eachcol]
    maps = [Tuple[(r[2]:r[2]+r[3]-1, r[1]-r[2]) for r in category] for category in maps]
    min_loc_p2 = Int(1e9)
    for seed_range in seeds_p2
        loc = propagate_range(seed_range, maps, min_loc_p2)
        min_loc_p2 = min(loc, min_loc_p2)
    end

    return min_loc_p1, min_loc_p2
end

end # module