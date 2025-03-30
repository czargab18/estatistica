sapatos, tenis, pagamento, entrega = input().split()
sapatos, tenis, pagamento, entrega = int(sapatos), int(tenis), int(pagamento), int(entrega)

valor_bruto = (sapatos * 200) + (tenis * 150)
produtos = sapatos + tenis
if produtos >= 3 and pagamento == 0:
    valor_desconto = valor_bruto - 40
elif produtos >= 3 and pagamento == 1:
    valor_desconto = valor_bruto - 30
else:
    valor_desconto = valor_bruto

if entrega == 0:
    valor_final = valor_desconto
elif entrega == 1:
    valor_final = valor_desconto + 50
elif entrega == 2:
    valor_final = valor_desconto + 60
      
print("{:.2f} {:.2f} {:.2f}".format(valor_bruto, valor_desconto, valor_final))