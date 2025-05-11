valor_inicial, parcela = input().split()
valor_inicial, parcela = [float(valor_inicial), int(parcela)]

if parcela == 1:
    valor = valor_inicial * 0.95
    parcelas = valor
elif parcela == 2:
    valor = valor_inicial
    parcelas = valor / 2
elif parcela == 3:
    valor = valor_inicial * 1.05
    parcelas = valor / 3
elif parcela == 4:
    valor = valor_inicial * 1.10
    parcelas = valor / 4
print("{:.2f} {:.2f}".format(valor, parcelas))
    