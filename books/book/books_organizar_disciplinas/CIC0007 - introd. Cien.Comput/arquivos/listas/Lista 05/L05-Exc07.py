maiúsculas = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ'
minúsculas = maiúsculas.lower()
números = '1234567890'
espaço = ' '
mai = []
min = []
num = []
esp = []
for i in maiúsculas:
    mai.append(i)
for i in minúsculas:
    min.append(i)
for i in números:
    num.append(i)
for i in espaço:
    esp.append(i)
n = str(input())
for i in n:
    if i in mai:
        print('U',end = '')
    elif i in min:
        print('L',end = '')
    elif i in num:
        print('D',end = '')
    elif i in esp:
        print('W',end = '')