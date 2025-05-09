a, b = input().split()
a, b = [int(a), int(b)]
if 0<=a<=100 and 1<=b<=100 and (b==a or b==a+1):
    print(a, b, 'ok')
else:
    print(a, b, 'errados')