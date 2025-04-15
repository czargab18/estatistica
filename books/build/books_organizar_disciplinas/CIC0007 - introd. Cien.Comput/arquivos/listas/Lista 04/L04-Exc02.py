def maior(num1, num2, num3, num4, num5, num6, num7, num8, num9, num10):
    maior=max(num1, num2, num3, num4, num5, num6, num7, num8, num9, num10)
    return maior
num1 = int(input())
num2 = int(input())
num3 = int(input())
num4 = int(input())
num5 = int(input())
num6 = int(input())
num7 = int(input())
num8 = int(input())
num9 = int(input())
num10 = int(input())
maior = maior(num1, num2, num3, num4, num5, num6, num7, num8, num9, num10)
print(maior)
if maior % num1 == 0:
    print(num1)