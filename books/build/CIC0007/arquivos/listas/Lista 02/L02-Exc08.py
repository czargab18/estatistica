A = float(input())
B = float(input())
C = float(input())
if A>=B+C or B>=A+C or C>=A+C:
    print('NAO FORMA TRIANGULO')
elif A**2 == B**2 + C**2 or B**2 == A**2 + C**2 or C**2 == A**2 + B**2:
    print('TRIANGULO RETANGULO')
elif A==B==C:
    print('TRIANGULO EQUILATERO')
elif A==B or A==C or B==C:
    print('TRIANGULO ISOSCELES')
else:
    print('TRIANGULO ACUTANGULO OU OBTUSANGULO')