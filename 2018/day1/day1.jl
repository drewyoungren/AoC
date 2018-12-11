s = open("input.txt") do file
    [tryparse(Int,chomp(x)) for x in readlines(file)];
end

print("Part 1: ",sum(s))

N = length(s)
tot = 0 
i = 1
seen = Set{Int}()

while !in(tot,seen)
    push!(seen,tot)
    tot += s[i]
    i = mod1(i+1,N)
end
println("Part 2: ",tot)