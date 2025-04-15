#entradas
tempo = float(input())
velocidade = float(input())
#processamento
distancia = tempo * velocidade
litros = distancia / 14.2
#saida
print("{:} {:.2f}".format(distancia, litros))
