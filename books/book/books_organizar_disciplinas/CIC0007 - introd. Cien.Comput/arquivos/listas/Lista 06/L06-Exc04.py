n = int(input())
brinquedos = input().split()
inicial = brinquedos.copy()
a = 0
c = 0
contador=0
for i in range(5):
    c=0
    b, d, q = input().split()
    q = int(q)
    while b != brinquedos[c]:
        c = c + 1
    if d == 'D':
        del brinquedos[c]
        brinquedos.insert(c+q,b)
    if d == 'E':
        if c >= q:
            del brinquedos[c]
            brinquedos.insert(c - q, b)
        else:
            del brinquedos[c]
            brinquedos.insert(0, b)
for i in range(n):
    if inicial[a] != brinquedos[a]:
        contador = contador + 1
    a = a + 1
print(contador)