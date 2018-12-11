p,N = 478,7124000
# p,N = 30,5807 # test
score = zeros(p)
marbles = [0]
pos = 1
# sc = []
for m in 1:N
    global pos
    lm = length(marbles)
    if m % 23 != 0
        pos = mod1(pos+1,lm)
        if pos == lm
            push!(marbles,m)
        else
            insert!(marbles,pos+1,m)
        end
        pos = mod1(pos+1,lm+1)
    else
        pos = mod1(pos - 7,lm)
        score[mod1(m,p)] += m + marbles[pos]
#         push!(sc,m + marbles[pos])
        deleteat!(marbles,pos)
        pos = mod1(pos,length(marbles))
    end
end

print(maximum(score))