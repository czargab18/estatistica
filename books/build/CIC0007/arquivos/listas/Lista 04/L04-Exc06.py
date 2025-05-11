def mmc(x,y):
    mmc = min(x,y)
    while not(mmc % x == 0 and mmc % y == 0):
        mmc = mmc + 1
    return mmc
a, b = 0, 0
while a >= 0 and b >= 0:
    a, b=input().split()
    a, b=int(a), int(b)
    if a > 0 and b > 0:
        print(mmc(a,b))
    if (a == 0 or b == 0) and (a > 0 or b > 0):
        print(0)