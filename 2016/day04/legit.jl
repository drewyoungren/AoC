pat = r"([a-z\-]+)(\d+)\[(\w+)\]"

s = open("input.txt") do f
    [chomp(x) for x in readlines(f)]    
end

s = [match(pat,x).captures for x in s]

s = [[m[1],m[2],m[3]] for m in s]

for x in s[1:4]
    println(x)
end

t = s[1][1]

t = join(split(t,"-"))

function tally(v)
    out = Dict()
    for c in v
        out[c] = get(out,c,0) + 1
    end
    return out
end

println(tally(t))


function check_sum(t)
    t = join(split(t,"-"))
    x = sort([(v,k) for (k,v) in pairs(tally(t))],lt=((x,y) -> any([x[1]> y[1], (x[1] == y[1]) & (x[2] < y[2])])))
    # println(x)
    return join([k for (v,k) in x])[1:5]
end

for t in ["aaaaa-bbb-z-y-x-","not-a-real-room-"]
    println(t,"   ",check_sum(t))
end

for t in s[1:10]
    println(t[1],"   ",check_sum(t[1]), "  ",t[3])
end



p(x) = parse(Int,x)

realrooms = [x for x in s if check_sum(x[1]) == x[3]]

tot = sum([p(x[2]) for x in realrooms])

println("Part 1 sol: ",tot)

abc = "abcdefghijklmnopqrstuvwxyz"

a2n(c::Char) = findfirst(string(c),abc)[1]

function unciph(s,k)
    sout = ""
    for c in s
        if c in abc
            sout *= string(abc[mod1(a2n(c) + k,26)])
        else
            sout *= " "
        end
    end
    return sout
end

for x in realrooms
    println(unciph(x[1],p(x[2])),"  ",x[2])
end
