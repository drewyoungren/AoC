s = open("input.txt") do f
    [split(chomp(x)) for x in readlines(f)]    
end

p(x) = parse(Int,x)

s = [map(p,x) for x in s]

function test_tri(a,b,c)
    return all([a+b>c,a+c>b,c+b>a])
end

println("Part 1 solution: ",length([x for x in s if test_tri(x...)]))

# pt 2 

B = [s[i][j] for i in 1:length(s),j in 1:3]

println(size(B))

# println(B[1:3,1:6])
# println(B[13:15],length(B))

tot = 0
for i in 1:3:length(B)
    global tot
    if test_tri(B[i:i+2]...)
        tot += 1
    end
end

println("\nPart 1 solution: ",tot)
