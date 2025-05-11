t = int(input())

while t > 0:
    a, n = input().split()
    a, n = [int(a), int(n)]
    soma = 0
    for i in range(a, a+n, 1):
        soma += i
        print(i, end=" ")
    print(f"\n{soma}")
    
    t -= 1
    