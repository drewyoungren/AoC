N = 846021

recipes = [3,7]

x,y = (1,2)

function step(recipes,x,y)
    sx,sy = recipes[x],recipes[y]
    n = sx + sy
    q,r = n ÷10,n%10
    if q > 0
        push!(recipes,q)
    end
    push!(recipes,r)
    no = length(recipes)
    return (recipes,mod1(1+x+sx,no),mod1(1+y+sy,no))
end

function solve(n)
    recipes,x,y = ([3,7],1,2)
    while length(recipes) < n + 10 
        (recipes,x,y) = step(recipes,x,y)
        # println(recipes)
    end
    return (join([string(recipes[i]) for i in n+1:n+10]))
end

# for j in [5,9,2018,N]
#     println(solve(j))
# end

function solve2(n)
    w = string(n)
    D = length(w)
    recipes,x,y = ([3,7],1,2)
    # for l in 1:19
    while true 
        (recipes,x,y) = step(recipes,x,y)
        # println(recipes)
        R = length(recipes)
        if R > D
            w1 = join([string(recipes[i]) for i in R-D:R-1])
            # print(w1," ")
            if w1 == w
                return R-D-1
            else
                w1 = join([string(recipes[i]) for i in R-D+1:R])
                # print(w1,".\n")
                if w1 == w
                    return R-D
                end
            end
        end
    end
end

println(solve2(N))
println(solve2("01245"))
println(solve2("51589"))

for j in ["01245",92510,"51589"]
    # recipes,x,y = ([3,7],1,2)
    println(solve2(j))
end

for j in [51589,59414,"01245",92510]
#     # recipes,x,y = ([3,7],1,2)
    println(j,"  ",solve2(j))
end