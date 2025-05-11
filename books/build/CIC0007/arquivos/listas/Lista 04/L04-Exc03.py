def Pares(n):
    print(n)

    if n > 2:
        n -= 2
        Pares(n)


n = int(input())

if (n % 2 != 0):
    n -= 1

if (n > 1):
    Pares(n)