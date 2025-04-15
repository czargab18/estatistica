n = int(input())
maior=0
menor=0
if n>0:
    for i in range(n):
        x, y = input().split()
        x, y = [int(x), int(y)]
        if y>0:
            if x%2==0:
                x=x+1
            s=0
            for i in range(y):
                s=s+x
                x=x+2
            if maior==0:
                maior=s
            if menor==0:
                menor=s
            if maior<s:
                maior=s
            if menor>s:
                menor=s
            print(s)
    print(maior)
    print(menor)
    print('%.2f'%((maior+menor)/2))
    