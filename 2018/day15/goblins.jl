filename = (length(ARGS) > 0 ? ARGS[1] : "test.txt")

s = open(filename) do f
    [chomp(x) for x in readlines(f)]    
end

A = [x[j] for x in s, j in 1:length(s[1])]

function pretty(A)
    for i in 1:size(A,2)
        for j in 1:size(A,1)
            print(A[j,i])
        end
        print("\n")
    end
end

pretty(A)

gobs,elves = (1,1)
G = Dict{Int,Dict}()
E = Dict{Int,Dict}()
for j in CartesianIndices(A)
    global gobs,elves
    if A[j] == 'G'
        G[gobs] = Dict("pos" => j,"hits" => 200)
        gobs += 1
    elseif A[j] == 'E'
        E[elves] = Dict("pos" => j,"hits" => 200)
        elves += 1
    end
end

CARDINALS=[CartesianIndex(0,-1),CartesianIndex(-1,0),CartesianIndex(1,0),CartesianIndex(0,1)]

function attack_range(player,A=A)
    pos = player["pos"]
    return [pos + c for c in CARDINALS if A[pos + c] == '.']
end

norm1(x::CartesianIndex) = sum(map(abs,Tuple(x)))

for v in values(G)
    println(v["pos"],norm1(v["pos"]),attack_range(v))
end


