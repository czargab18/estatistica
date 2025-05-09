n = 1
a = 1
while n > 0:
    n = int(input())
    if n % 2 !=0 and n != 1:
        n = n - 1
    a = n
    if n > 0:
        while a > 0 and a != 1:
            print('%i^2 = %i'%(a,a**2))
            a = a - 2