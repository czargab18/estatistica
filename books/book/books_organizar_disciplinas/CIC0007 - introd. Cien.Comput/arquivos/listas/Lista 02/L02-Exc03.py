cargo = str(input())
tempo = int(input())
salario = float(input())

if cargo == Gerente and tempo <= 3:
    reajuste = salario * 0.12
    salario_final = salario + reajuste
elif cargo == Gerente and tempo < 3 and tempo >= 6:
    reajuste = salario * 0.13
    salario_final = salario + reajuste
elif cargo == Gerente and tempo > 6:
    reajuste = salario * 0.15
    salario_final = salario + reajuste
elif cargo == Engenheiro and tempo <= 3:
    reajuste = salario * 0.07
    salario_final = salario + reajuste
elif cargo == Engenheiro and tempo < 3 and tempo >= 6:
    reajuste = salario * 0.11
    salario_final = salario + reajuste
elif cargo == Gerente and tempo > 6:
    reajuste = salario * 0.14
    salario_final = salario + reajuste
    

