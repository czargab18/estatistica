cargo = str(input())
tempo = int(input())
salario = float(input())

if cargo == Gerente:
    if tempo <= 3:
    reajuste = salario * 0.12
    salario_final = salario + reajuste
    elif tempo < 3 and tempo >= 6:
    reajuste = salario * 0.13
    salario_final = salario + reajuste
    elif tempo > 6:
    reajuste = salario * 0.15
    salario_final = salario + reajuste
if cargo == Engenheiro:
    if tempo <= 3:
    reajuste = salario * 0.07
    salario_final = salario + reajuste
    elif tempo < 3 and tempo >= 6:
    reajuste = salario * 0.11
    salario_final = salario + reajuste
    elif tempo > 6:
    reajuste = salario * 0.14
    salario_final = salario + reajuste
else:
    if tempo <= 3:
    reajuste = salario * 0.05
    salario_final = salario + reajuste
    elif tempo < 3 and tempo >= 6:
    reajuste = salario * 0.05
    salario_final = salario + reajuste
    elif tempo > 6:
    reajuste = salario * 0.05
    salario_final = salario + reajuste
print("{:.2f}".format(reajuste))
print("{:.2f}".format(salario_final))    
