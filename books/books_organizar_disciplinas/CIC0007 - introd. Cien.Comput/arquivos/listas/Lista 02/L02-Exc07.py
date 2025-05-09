p = float(input())
h = float(input())
IMC = float(p/(h)**2)
print('%.2f'%(IMC))
if IMC<18.5:
    print('Baixo peso')
elif 18.5<=IMC<24.9:
    print('Peso normal')
elif 24.9<=IMC<29.9:
    print('Sobrepeso')
    print('%.2f'%((IMC-24.9)*(h)**2))
elif 29.9<=IMC<34.9:
    print('Obesidade grau I')
    print('%.2f'%((IMC-24.9)*(h)**2))
elif 34.9<=IMC<39.9:
    print('Obesidade grau II')
    print('%.2f'%((IMC-24.9)*(h)**2))
else:
    print('Obesidade grau III')
    print('%.2f'%((IMC-24.9)*(h)**2))