C = int(input())
x = 0
n = ''
for i in range(C):
    n = str(input())
    if n == 'André':
        x = 1
if x == 0:
    print('Seguro!')
elif x == 1:
    print('Cuidado!')