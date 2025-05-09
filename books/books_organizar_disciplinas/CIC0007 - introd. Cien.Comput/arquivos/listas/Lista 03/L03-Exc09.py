n, m = input().split()
n, m = [int(n), int(m)]
def mdc(n,m):
    while m !=0:
        resto = n % m
        n = m
        m = resto

    return n

print(mdc(n,m))