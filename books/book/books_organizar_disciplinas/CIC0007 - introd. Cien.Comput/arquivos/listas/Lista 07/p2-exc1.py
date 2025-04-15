cidade = ""
popular = {}
while cidade != "final":
    cidade = str(input())
    if cidade == "final":
        break
    if cidade in popular:
        popular[cidade] = popular[cidade] + 1
    else:
        popular[cidade] = 1
maior = 0
lista = []
for m in popular:
    if popular[m]>maior:
        maior = popular[m]
        lista = []
        lista.append(m)
    elif popular[m] == maior:
        lista.append(m)
lista.sort()
for m in lista:
    print(m)