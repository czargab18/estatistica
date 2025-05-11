n = input()
f = []
if n == '':
    print('')
else:
    for i in n:
        f.append(i)
    f[0] = f[0].upper()
    c = 0
    while c < len(f) - 1:
        if f[c] == '.':
            x = c + 1
            while f[x] == ' ':
                x = x + 1
            f[x] = f[x].upper()
        c = c + 1
    print(''.join(f))