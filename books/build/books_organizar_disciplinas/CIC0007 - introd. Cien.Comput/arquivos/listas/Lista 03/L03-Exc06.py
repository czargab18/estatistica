n = int(input())
if n==0:
    chute=1
else:
    chute=0
while not(n==chute):
    chute = int(input())
    if chute<n:
        print('O número correto é maior.')
    elif chute>n:
        print('O número correto é menor.')
if chute==n:
    print('Parabéns! Você acertou.')
