n=int(input())
x=0
z=0
y=n
while not(n==0):
    z=z+n
    x=x+1
    n=int(input())
    if not(n==0):
        if y<n:
            y=n
if x==0:
    print('0')
    print('0')
    print('0.00')
else:
    print(x)
    print(y)
    print('%.2f'%(z/x))