hi, mi, hf, mf = input().split()
hi, mi, hf, mf = [int(hi), int(mi), int(hf), int(mf)]
mhi = int(60*hi)
mhf = int(60*hf)
if (mhi+mi)-(mhf+mf)==0:
    print('O jogo durou', hf-hi+24, 'hora(s) e', mf-mi, 'minuto(s).')
elif (mhi+mi)-(mhf+mf)<0:
    if mf>=mi:
        print('O jogo durou', hf-hi, 'hora(s) e', mf-mi, 'minuto(s).')
    else:
        print('O jogo durou', hf-hi-1, 'hora(s) e', 60+mf-mi, 'minuto(s).')
else:
    if mf>=mi:
        print('O jogo durou', hf-hi+24, 'hora(s) e', mf-mi, 'minuto(s).')
    else:
        print('O jogo durou', hf-hi+23, 'hora(s) e', 60+mf-mi, 'minuto(s).')