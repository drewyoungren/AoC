filename = "input.txt"
debug = false
N = 10000

s = open(filename) do f
    [chomp(x) for x in readlines(f)]
end

A = [collect(s[i])[j] for i in 1:length(s), j in 1:length(s[1])];

function pretty(A::Array)
    for i in 1:size(A,1)
        println(join(A[i,:]))
    end
end

function replace_track(c)
    if c in ('^','v') return '|'
    elseif c in ('<','>') return '-'
    else return c
    end
end

B = [replace_track(A[i,j]) for i in 1:size(A,1),j in 1:size(A,2)];


cartpos = findall(x -> x in collect("<>^v"),A);
carts = [[pos[1],pos[2],A[pos],3] for pos in cartpos]
sort!(carts)

if debug 
    println(carts)
    pretty(B)
end

DIR = Dict('<' => [0,-1],
           '>' => [0,1],
           'v' => [1,0],
           '^' => [-1,0]
           );

turnslashes = Dict('/'=>Dict('v'=>'<','^'=>'>','>'=>'^','<'=>'v'),
    '\\'=>Dict('v'=>'>','^'=>'<','>'=>'v','<'=>'^'))

turnplus = Dict('v'=>collect(">v<"),'^'=>collect("<^>"),
    '>'=>collect("^>v"),'<'=>collect("v<^"));

function tick(carts)
    newcarts = []
    for (x,y,c,n) in carts
#         println(x,y,c,n)
        nx,ny = [x,y] + DIR[c]
        d = B[nx,ny]
        A[x,y] = B[x,y]
        if d in ('-','|')
            nd  = c
        elseif d in ('/','\\')
            nd = turnslashes[d][c]
        elseif d == '+'
            n = mod1((n + 1) , 3)
            nd = turnplus[c][n]
        end
        if !(A[nx,ny] in collect("-/|\\+"))
            println("CRRRASH!! ",(nx,ny))
            pretty(A[nx-2:nx+2,ny-2:ny+2])
            A[nx,ny] = 'X'
            # nd = c
#             break
        else
            A[nx,ny] = nd
        end
        push!(newcarts,[nx,ny,nd,n])
    end
    # cartsxy = Set([tuple(x[1:2]) for x in newcarts])
    
    return sort(newcarts)
end

for x in 1:N
    global carts
    if debug
        pretty(A)
    end 
    carts = tick(carts)
end        
        
        