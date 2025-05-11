n = int(input())
print(n)
print (n // 100, "nota(s) de R$ 100,00")
n = n % 100
print (n // 50, "nota(s) de R$ 50,00")
n = n % 50
print (n // 20, "nota(s) de R$ 20,00")
n= n % 20
print (n // 10, "nota(s) de R$ 10,00")
n = n % 10
print (n // 5, "nota(s) de R$ 5,00")
n = n % 5
print (n // 2, "nota(s) de R$ 2,00")
n = n % 2
print (n // 1, "nota(s) de R$ 1,00")
n = n % 1