filename = (length(ARGS) > 0 ? ARGS[1] : "test.txt")

debug = false

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

playas = 1
P = Dict{Int,Dict}()
for j in CartesianIndices(A)
    global playas
    if A[j] in ['G','E']
        P[playas] = Dict("ge" => A[j],"pos" => j,"hits" => 200)
        playas += 1
    end
end

CARDINALS=[CartesianIndex(0,-1),CartesianIndex(-1,0),CartesianIndex(1,0),CartesianIndex(0,1)]

function attack_range(player,A=A)
    pos = player["pos"]
    return [pos + c for c in CARDINALS if A[pos + c] == '.']
end

norm1(x::CartesianIndex) = sum(map(abs,Tuple(x)))

if debug 
    for v in values(P)
        println(v["pos"],norm1(v["pos"]),attack_range(v))
    end
end


function find_paths(pos,out,A=A)
    for d in CARDINALS
        nd = pos + d
        if !(nd in keys(out)) & (A[nd] == '.')
            out[pos] = vcat(get(out,pos,[]),[nd])
            out[nd] = []
        end
    end
    for d in out[pos]
        find_paths(d,out,A)
    end
end


function parent(tree,n)
    for (k,v) in pairs(tree)
        if n in v
            return k
        end
    end
    return 0
end

function lineage(tree,n)
    out = [n]
    p = parent(tree,n)
    while p != 0
        pushfirst!(out,p)
        p = parent(tree,p)
    end
    return out
end

if debug
    out = Dict()
    find_paths(CartesianIndex(2,2),out,A)
    # println(out)
    println(lineage(out,CartesianIndex(7,2)))
end
function pretty_tree(out)
    for (k,v) in pairs(out)
        print((k[1],k[2]),": ")
        println([(x[1],x[2]) for x in v]...)
    end
end

function tick(player,P=P,A=A)
    pos = player["pos"]
    enemy = ( player["ge"] == 'G' ? 'E' : 'G')

    rangs = []
    for (p,v) in pairs(P) 
        if v["ge"] == enemy
            rangs = union(rangs, attack_range(v))
        end
    end

    if pos in rangs
        println("Attack! ", pos)
    else
        out = Dict()
        find_paths(pos,out,A)

        pretty_tree(out)

        r = sort([x for x in union(values(out)...) if x in rangs])
        println([(x[1],x[2]) for x in r]...)

        if length(r) > 0
            minimum_path  = lineage(out,r[1])
            println(length(minimum_path)," ",[(x[1],x[2]) for x in minimum_path]...)
            for d in r[2:end]
                m = lineage(out,d)
                if (length(m) < length(minimum_path) | ((length(m) == length(minimum_path)) & (m[2] < minimum_path[2])))
                    minimum_path = m 
                end
                println(length(m)," ",[(x[1],x[2]) for x in m]...)
            end
            player["pos"] = minimum_path[2]
            A[pos] = '.'
            A[minimum_path[2]] = player["ge"] 
        end 
        
        

        # println(out)
    end

end

pretty(A)

for i in 1:length(P)
    tick(P[i],P,A)
    pretty(A)
    println(i," ",P[i])
end
