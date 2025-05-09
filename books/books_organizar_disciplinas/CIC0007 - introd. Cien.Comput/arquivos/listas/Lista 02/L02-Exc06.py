m, d = input().split()
m, d = [int(m), int(d)]
if 1<=m<=12 and 1<=d<=7:
    if m==2:
        if d==1:
            print(4)
        else:
            print(5)
    if m==1 or m==3 or m==5 or m==7 or m==8 or m==10 or m==12:
        if 1<=d<=5:
            print(5)
        else:
            print(6)
    if m==4 or m==6 or m==9 or m==11:
        if 1<=d<=6:
            print(5)
        else:
            print(6)