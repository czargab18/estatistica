import math
def fat(a):
    if a == 1 or a == 2:
        return a
    mult = 1
    while a > 0:
        mult = mult * a
        a -= 1
    return mult
            
def fib(a):
    if a == 1 or a == 2:
        return 1
    ant1 = 1
    ant2 = 1
    fib = ant1 + ant2
    cont = 3
    while cont < a:
        aux = fib
        fib = fib + ant2
        ant2 = aux
        cont += 1       
    return fib

a = int(input())
if fib(a) % 2 == 0:
    print(fib(a), fat(a), fib(a-1))
else:
    print(fib(a), fat(a))
    


    
  
  