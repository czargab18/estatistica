calls = 0

def ackerman(x, y):
    global calls
    calls += 1
    if x == 0:
        return y + 1
    elif x == 1:
        return (y + 2)
    elif x == 2:
        return (2 * y + 3)
    elif y == 0:
        return ackerman(x - 1, 1)
    else:
        return ackerman(x - 1, ackerman(x, y - 1))

x, y = input().split()
x, y = [int(x), int(y)]

print(ackerman(x, y))