tempo = int(input())
horas = tempo // 3600
segundos_restantes = tempo % 3600
minutos = segundos_restantes // 60
segundos_finais = segundos_restantes % 60
print(f"{horas}h:{minutos}m:{segundos_finais}s")