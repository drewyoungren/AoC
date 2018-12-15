s = open("input.txt") do f
    [chomp(x) for x in readlines(f)]    
end

# println(length(s),s[1])

s = split(s[1],r",\s*")

println(s)

DIR = Dict(0 => [0,1],1 => [1,0],2 => [0,-1], 3 => [-1,0])

nextdir = collect("nesw")



pos,d = [0,0],0
seen = [tuple(pos)]
# while !(pos in seen)
for x in s
    global pos,d
    t,a = (x[1],parse(Int,x[2:end]))
    d = (t == 'R') ? mod(d+1 , 4) : mod(d-1 , 4)
    for i in [pos + j*DIR[d] for j in 1:a]
        if tuple(i) in seen
            println(i)
            break
        else
            push!(seen,tuple(i))
        end
    end
    pos += a*DIR[d]
end 

println(pos," ",d)