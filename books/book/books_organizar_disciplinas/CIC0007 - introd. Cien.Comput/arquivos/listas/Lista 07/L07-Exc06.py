n = int(input())
dic = {}
l = []
for _ in range(n):
    p1, p2 = input().split()
    dic[p1] = p2
frase=input().split()
for palavra in frase:
    if palavra in dic:
        l.append(dic[palavra])
if l == []:
    print('Tudo bem!')
else:
    print(' '.join(l))