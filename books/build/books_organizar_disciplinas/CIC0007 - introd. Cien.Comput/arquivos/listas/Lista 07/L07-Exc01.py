problema = []
n = int(input())
for _ in range(n):
    p, s, d = input().split()
    d = int(d)
    problema.append((p, s, d))
    
ordenado = sorted(problema, key = lambda x:x[2], reverse = True)

for solucao in ordenado:
    print(solucao[1], end = '')