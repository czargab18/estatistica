import math
n = int(input())
acm = 0
maior_media = -9999999
menor = math.inf
menor_BH = ""
maior_nome = ""
if n > 0:
    for i in range(n):
        nome, area, verão, outono, inverno, primavera = input().split()
        nome, area, verão, outono, inverno, primavera = [str(nome), float(area), float(verão), float(outono), float(inverno), float(primavera)]
        media_anual = (verão + outono + inverno + primavera) / 4
        if media_anual > maior_media:
            maior_media = media_anual
            maior_nome = nome
        acm = acm + area
        
        if menor > verão:
            menor = verão
            menor_BH = nome
            
        if menor > outono:
            menor = outono
            menor_BH = nome
            
        if menor > inverno:
            menor = inverno
            menor_BH = nome
            
        if menor > primavera:
            menor = primavera
            menor_BH = nome       


print(maior_nome)
print(menor_BH)
media_area = acm / n
print("{:.2f}".format(media_area))