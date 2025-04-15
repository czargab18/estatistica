frase = input().split()
vogais = "aeiouAEIOUáéíóúâêîôû"
msg = ""
for palavra in frase:
    for letra in palavra:
        if letra in vogais:
            msg += letra
        else:
            msg += "p"
    msg += " "
print(msg)
        
        