mesa_1 = 0
mesa_2 = 0
mesa_3 = 0
ent = 0
lista = []
while ent!='Fim':
    ent = input()
    if ent == 'Fim':
         break
    ent = int(ent)
    lista.append(ent)
for i in lista:
    if i > 8:
        print('Indisp')
    elif i <=2 and mesa_2 == 0:
        print(2)
        mesa_2 = 1
    elif i <=4 and mesa_1 == 0:
        print(1)
        mesa_1 = 1
    elif i <=8 and mesa_3 == 0:
        print(3)
        mesa_3 = 1
    else:
        print('Indisp')