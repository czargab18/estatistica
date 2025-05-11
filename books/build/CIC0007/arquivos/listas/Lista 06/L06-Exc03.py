f, p = input().split()
f, p = int(f),int(p)
for i in range(f):
    n, e = input().split()
    e = int(e)
    if p == e:
        p = -1
        ganhador = n
    elif p > e:
        p = p - 1
print(ganhador)