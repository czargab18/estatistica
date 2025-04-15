def exercicio(lista):

    i = 0

    for elemento in lista:

        lista[i] = 2 * elemento

        i = i + 1



L = [0,1,2,3,'ABCD']

exercicio(L)

print(L)