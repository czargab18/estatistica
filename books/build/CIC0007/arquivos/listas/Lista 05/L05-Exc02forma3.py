def linguadop(x):
    vogais = "aeiouAEIOUÁÉÍÓÚÃÕáéíóúãõ"
    for i in range (0,len(x)):
        letra = x[i]
        if letra in vogais or letra in " ":
            print(letra, end="")
        else:
            print("p", end="")

        
x = input()
função = linguadop(x)