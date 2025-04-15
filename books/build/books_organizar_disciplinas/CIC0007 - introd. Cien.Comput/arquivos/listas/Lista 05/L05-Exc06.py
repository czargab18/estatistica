n = ['J','O','H','N']
letras = input()
letras = letras.upper()
restantes = input()
restantes = restantes.upper()
I = 0
O = 0
c = 0
for i in restantes:
    if i in n:
        O +=1
for i in letras:
    if i in n:
        c +=1
I = c - O
print(I, O)
