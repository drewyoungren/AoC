filename = (length(ARGS) > 0 ? ARGS[1] : "test.txt")

ATTACK_STRENGTH = 3

debug = false

s = open(filename) do f
    [chomp(x) for x in readlines(f)]    
end

A = [x[j] for j in 1:length(s[1]), x in s]

function pretty(A,P=P)
    for i in 1:size(A,2)
        row_guys =[]
        for j in 1:size(A,1)
            print(A[j,i])
            if A[j,i] in ('G','E')
                pl = first([k for (k,v) in P if v["pos"] == CartesianIndex(j,i)])
                push!(row_guys,pl)
            end
        end
        print([" " * string(P[pl]["hits"]) * " " for pl in row_guys]...)
        print("\n")
    end
end


playas = 1
P = Dict{Int,Dict}()
for j in CartesianIndices(A)
    global playas
    if A[j] in ['G','E']
        P[playas] = Dict("ge" => A[j],"pos" => j,"hits" => 200)
        playas += 1
    end
end

pretty(A)

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
    layers = [[pos]]
    while !isempty(layers[end])
        push!(layers,[])
        for x in layers[end - 1]
            for d in CARDINALS
                nd = x + d
                if !(nd in union(layers...)) & (A[nd] == '.')
                    push!(layers[end],nd)
                    out[x] = vcat(get(out,x,[]),[nd])
                    out[nd] = []
                end
            end
        end
        # println(layers)
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

function lookup_pos(pos,P=P)
    return first([k for (k,v) in pairs(P) if v["pos"] == pos])
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

    if any([A[pos+d] == enemy for d in CARDINALS])
        targets = [lookup_pos(pos + d) for d in CARDINALS if A[pos+d] == enemy]
        m = minimum([P[x]["hits"] for x in targets])
        other = lookup_pos(first(sort([P[x]["pos"] for x in targets if P[x]["hits"] == m])))
        # println("Attack! ", pos, " -> ", P[other]["pos"])
        P[other]["hits"] += -ATTACK_STRENGTH
        if P[other]["hits"] < 1
            println(other," ",P[other]," is dead!")
            A[P[other]["pos"]] = '.'
            delete!(P,other)
        end
    else
        out = Dict()
        find_paths(pos,out,A)

        # pretty_tree(out)

        r = sort([x for x in union(values(out)...) if x in rangs])
        println([(x[1],x[2]) for x in r]...)

        if length(r) > 0
            minimum_path  = lineage(out,r[1])
            # println(length(minimum_path)," ",[(x[1],x[2]) for x in minimum_path]...)
            for d in r[2:end]
                m = lineage(out,d)
                if (length(m) < length(minimum_path) | ((length(m) == length(minimum_path)) & (m[2] < minimum_path[2])))
                    minimum_path = m 
                end
                # println(length(m)," ",[(x[1],x[2]) for x in m]...)
            end
            A[pos] = '.'
            pos = minimum_path[2]
            player["pos"] = pos
            A[minimum_path[2]] = player["ge"] 
            if any([A[pos+d] == enemy for d in CARDINALS])
                targets = [lookup_pos(pos + d) for d in CARDINALS if A[pos+d] == enemy]
                m = minimum([P[x]["hits"] for x in targets])
                other = lookup_pos(first(sort([P[x]["pos"] for x in targets if P[x]["hits"] == m])))
                # println("Attack! ", pos, " -> ", P[other]["pos"])
                P[other]["hits"] += -ATTACK_STRENGTH
                if P[other]["hits"] < 1
                    println(other," ",P[other]," is dead!")
                    A[P[other]["pos"]] = '.'
                    delete!(P,other)
                end        
            end
        end 
        
        

        # println(out)
    end

end

pretty(A)

for j = 1:49
    for i in sort(collect(keys(P)),by=(x->P[x]["pos"]))
        tick(P[i],P,A)
        # pretty(A)
        # println(i," ",P[i])
    end
    if j in 22:28
        println("Round ",j)
        pretty(A)
    end
end
pretty(A)
