#entradas
deposito = float(input())
taxa_juros = float(input())
#processamento
rendimento = (taxa_juros / 100) * deposito
valor_total = deposito + rendimento
#saida
print("{:.2f}".format(rendimento))
print("{:.2f}".format(valor_total))

