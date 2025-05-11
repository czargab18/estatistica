n = int(input())
m = 1
while (m <= 1000):
    i = 2
    while (i < n * m + 1):
        if (n * m + 1) % i == 0:
            print(m)
            m = 1001
            break
        i += 1
    m += 1