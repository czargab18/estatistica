n = int(input())
p = 0
u = 0
for i in range(n):
    frase = input().split()
    for l in frase:
        l = l.lower()
        for j in l:
            if j == 'p':
                p = p + 1
            elif j == 'u':
                u = u + 1
print(p, u)