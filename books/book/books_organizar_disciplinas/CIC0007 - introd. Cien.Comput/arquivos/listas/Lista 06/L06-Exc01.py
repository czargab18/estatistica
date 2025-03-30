n = int(input())
l = []
for i in range(n):
    p = str(input())
    l.append(p)
l.reverse()
print(', '.join(l))