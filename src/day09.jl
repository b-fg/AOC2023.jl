module Day09

using AdventOfCode2023

function day09(input=readInput(09))
    histories =  split(input, "\n") .|> x -> split(x, " "; keepempty=false) .|> x -> parse.(Int, x)
    count_p1, count_p2 = 0, 0
    for history in histories
        h = diff(history)
        lasth, firsth, i = [history[end], h[end]], [history[1], h[1]], 1
        while !all(iszero, @views h[i:end])
            h[i+1:end] .= @views diff(h[i:end])
            push!(lasth, h[end]) # part 1
            push!(firsth, h[i+1]) # part 2
            i += 1
        end
        count_p1 += sum(lasth)

        for i in length(firsth)-1:-1:1
            firsth[i] -= firsth[i+1]
        end
        count_p2 += firsth[1]
    end

    return count_p1, count_p2
end

end # module