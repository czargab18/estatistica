#função que retorna o maior valor entre a e b
def fun_maior(a,b):
    if a > b:
        return a
    else:
        return b
    
t = int(input())
maior_todos = -99999999999999999
while t > 0:
    a,b =input().split()
    a,b = [int(a), int(b)]
    maior_laco = fun_maior(a,b)
    if maior_laco > maior_todos:
        maior_todos = maior_laco
    t -= 1
print(t)    
print(maior_todos)

    