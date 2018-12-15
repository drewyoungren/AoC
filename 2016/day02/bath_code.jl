s = open("input.txt") do f
    [collect(chomp(x)) for x in readlines(f)]    
end

teststring = """ULL
RRDDD
LURDL
UUUUD"""

t = [collect(x) for x in split(teststring,"\n")]
# println(t)

K = reshape(1:9,3,3)'

println(K)

DIR = Dict('U' => [-1,0],'L' => [0,-1], 'R' => [0,1],'D' => [1,0])

reg(v) = [min(max(1,v[1]),3),min(max(1,v[2]),3)]

println(K[CartesianIndex(reg([2,2] + 3*DIR['U'])...)])

out = ""
pos = [2,2]
for x in s
    global out,pos
    for c in x
        pos = reg(pos + DIR[c])
    end
    println(pos)
    out *= string(K[CartesianIndex(pos...)])
end

println(out)

# pt 3

Q = [' ' ' ' '1' ' ' ' ';
     ' ' '2' '3' '4' ' ';
     '5' '6' '7' '8' '9';
     ' ' 'A' 'B' 'C' ' ';
     ' ' ' ' 'D' ' ' ' ']

println(Q)

println(Q[3,1])

function dir(pos,d)
    if d == 'U'
        i,j = pos
        if i-abs(j-3)-1 > 0
            return [-1,0]
        else
            return [0,0]
        end
    elseif d == 'L'
        i,j = pos
        if j-abs(i-3)-1 > 0
            return [0,-1]
        else
            return [0,0]
        end
    elseif d == 'D'
        i,j = pos
        if 5-abs(j-3)-i > 0
            return [1,0]
        else
            return [0,0]
        end
    elseif d == 'R'
        i,j = pos
        if 5-abs(i-3)-j > 0
            return [0,1]
        else
            return [0,0]
        end
    end
end

out = ""
pos = [3,1]
for x in s
    global out,pos
    for c in x
        pos = pos + dir(pos,c)
    end
    println(pos)
    out *= string(Q[CartesianIndex(pos...)])
end

println(out)