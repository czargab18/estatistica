tempo1, vel1, tempo2, vel2 = input().split()
tempo1, vel1, tempo2, vel2 = [int(tempo1), int(vel1), int(tempo2), int(vel2)]

if tempo1 > 1800:
    ponto1= - (tempo1 - 1800) * 1
elif 0 < tempo1 < 1800:
    ponto1 = - (1800 - tempo1) * 2
elif tempo1 == 0:
    ponto1 = -1000
else:
    ponto1 = 0
print(ponto1)
if vel1 > 60:
    ponto2= ponto1 - ((vel1 - 60) * 10)
else:
    ponto2 = ponto1
print (ponto2)
if tempo2 > 3600:
    ponto3= - (tempo2 - 3600) * 1
elif 0 < tempo2 < 3600:
    ponto3 = - (3600 - tempo2) * 2
elif tempo2 == 0:
    ponto3 = -1000
else:
    ponto3 = 0
print(ponto3)
if vel2 > 40:
    ponto4= ponto3 - ((vel2 - 40) * 20)
else:
    ponto4 = ponto3
print (ponto4)
ponto_sem = ponto1 + ponto3
ponto_com = ponto2 + ponto4
print(ponto_sem)
print(ponto_com)
