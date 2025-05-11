cargo = str(input())
tempo = int(input())
salario = float(input())
if salario<1039:
    print("Salário inválido!")
else:
    if (cargo == 'Engenheiro'):
        if tempo <=3:
            reajuste = salario*0.07
            salario_novo = salario+reajuste
            print("%.2f"%reajuste)
            print("%.2f"%salario_novo)
        elif 3<tempo<=6:
            reajuste = salario*0.11
            salario_novo = salario+reajuste
            print("%.2f"%reajuste)
            print("%.2f"%salario_novo)
        else:
            reajuste = salario*0.14
            salario_novo = salario+reajuste
            print("%.2f"%reajuste)
            print("%.2f"%salario_novo)
    elif (cargo == 'Gerente'):
        if tempo<=3:
            reajuste = salario*0.12
            salario_novo = salario+reajuste
            print("%.2f"%reajuste)
            print("%.2f"%salario_novo)
        elif 3<tempo<=6:
            reajuste = salario*0.13
            salario_novo = salario+reajuste
            print("%.2f"%reajuste)
            print("%.2f"%salario_novo)
        else:
            reajuste = salario*0.15
            salario_novo = salario+reajuste
            print("%.2f"%reajuste)
            print("%.2f"%salario_novo)
    else:
        reajuste = salario*0.05
        salario_novo = salario+reajuste
        print("%.2f"%reajuste)
        print("%.2f"%salario_novo)