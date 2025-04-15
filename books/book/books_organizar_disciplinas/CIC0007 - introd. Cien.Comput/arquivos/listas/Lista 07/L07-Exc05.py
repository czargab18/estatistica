n = int(input())
lutas = {}
for i in range(n):
    (tf, nome) = input().split()
    lutas[tf]=nome
(identificador, *parametros) = input().split()
while identificador != 'FINISHHIM':
    lutas[identificador] = parametros
    (identificador, *parametros) = input().split()
lutas_vencidas = 0
vencedor = parametros[0]
luta = lutas[vencedor]
while type(luta) == list:  
    lutas_vencidas += 1
    vencedor = luta[2]
    luta=lutas[vencedor]   
print(lutas_vencidas)