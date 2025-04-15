import math
n = int(input())
f_ant = 0
f_atual = 1
i = 1
while i < n:
    f_prox = f_ant + f_atual
    f_ant = f_atual
    f_atual = f_prox
    i = i + 1
fatorial = math.factorial(n)
    
print(f_atual, fatorial)
  