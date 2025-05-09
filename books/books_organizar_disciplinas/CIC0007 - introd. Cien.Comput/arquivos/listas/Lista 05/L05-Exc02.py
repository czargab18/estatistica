frase = input().split()
def letras(i):
    c = 0
    while i[c:c+1]!='':
        if i[c:c+1]=='a' or i[c:c+1]=='e' or i[c:c+1]=='i' or i[c:c+1]=='o' or i[c:c+1]=='u':
            print(i[c:c+1],end='')
            c=c+1
        elif i[c:c+1]=='á' or i[c:c+1]=='é' or i[c:c+1]=='í' or i[c:c+1]=='ó' or i[c:c+1]=='ú':
            print(i[c:c+1],end='')
            c=c+1
        elif i[c:c+1]=='A' or i[c:c+1]=='E' or i[c:c+1]=='I' or i[c:c+1]=='O' or i[c:c+1]=='U':
            print(i[c:c+1],end='')
            c=c+1
        elif i[c:c+1]=='Á' or i[c:c+1]=='É' or i[c:c+1]=='Í' or i[c:c+1]=='Ó' or i[c:c+1]=='Ú':
            print(i[c:c+1],end='')
            c=c+1
        else:
            print('p',end='')
            c=c+1
for i in frase:
        letras(i)
        print(' ',end='')