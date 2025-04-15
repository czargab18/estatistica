equipe = ""
qtd = {}
lista = []
while equipe!="Fim":
    equipe = input()
    if equipe == "Fim":
        break
    else:
        equipe = equipe.split()
        for jogador in equipe:
            if jogador in qtd:
                qtd[jogador] = qtd[jogador] + 1
            else:
                qtd[jogador] = 1
maior = 0
for l in qtd:
    if qtd[l] > maior:
        lista = []
        lista.append(l)
        maior = qtd[l]
    elif qtd[l] == maior:
        lista.append(l)
contador = -1
for num in lista:
    contador = contador + 1
    lista[contador] = int(num)
lista.sort()
for n in lista:
    print(n)