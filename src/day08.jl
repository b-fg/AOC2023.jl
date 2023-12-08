module Day08

using AdventOfCode2023, Revise

function day08(input::String=readInput(08))
    instr, network = split(strip(input), "\n"; keepempty=false) |>
        x -> (x[1], Dict(y[1:3] => (y[8:10], y[13:15]) for y in x[2:end]))

    # Part 1
    node, i, counter_p1 = "AAA", 1, 0
    while node != "ZZZ"
        node = network[node][instr[i] == 'L' ? 1 : 2]
        i = i == length(instr) ? 1 : i + 1
        counter_p1 += 1
    end

    # Part 2
    nodes, i, counter_p2 = [x for x in keys(network) if endswith(x, 'A')], 1, 0
    steps_to_Z = zeros(Int, length(nodes))
    while any(iszero, steps_to_Z)
        for (j, node) in enumerate(nodes)
            nodes[j] = network[node][instr[i] == 'L' ? 1 : 2]
            endswith(nodes[j], 'Z') && steps_to_Z[j] == 0 && (steps_to_Z[j] = counter_p2 + 1)
        end
        i = i == length(instr) ? 1 : i + 1
        counter_p2 += 1
    end

    return counter_p1, lcm(steps_to_Z .÷ length(instr)) * length(instr) # least common multiple (lcm)
end

end # module