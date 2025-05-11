def soma(x):
    if x < 0:
        return n-1
    if x == 0:
        return 0
    else:
        return x + soma(x - 2)
n=int(input())
if n%2!=0:
    n=n-1
print(soma(n) - n)