N = int(input())

def move (pos,D,Q):
 if D == "N":
    return(pos[0]+Q, pos[1])
 elif D == "S":
    return (pos[0]-Q, pos[1])
 elif D == "L":
    return (pos[0], pos[1]+Q)
 elif D == "O":
    return (pos[0], pos[1]-Q)

def format(y,x):
    return (
        -y if y < 0 else 0,
        y if y> 0 else 0,
        -x if x < 0 else 0,
        x if x > 0 else 0
    )

pos = (0,0)

for i in range (N):
    D,Q = input().split()
    pos = move(pos, D, int(Q))

print("%d %d %d %d" %format(*pos))