n = int(input())
acm = 0
cont = 0
if n > 0:
    for i in range(n):
        nota1, nota2, nota3, faltas = input().split()
        nota1, nota2, nota3, faltas = [float(nota1), float(nota2), float(nota3), int(faltas)]
        media = (nota1 + nota2 + nota3) / 3
        acm = acm + media
        if media <= 3 or faltas > 16:
            print("{:.1f} Reprovado".format(media))
        elif media > 3 and media < 5 and  faltas <= 16:
            print("{:.1f} Exame".format(media))
        elif media >= 5 and faltas <= 16:
            cont = cont + 1
            print("{:.1f} Aprovado".format(media))
media_turma = acm / n
print("{:.1f} {:}".format(media_turma, cont))

            


                  
            
        
        

    
    
    
    