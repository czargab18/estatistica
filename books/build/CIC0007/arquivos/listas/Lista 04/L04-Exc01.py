def compare(x,y):
    if x > y:
        return "x e maior que y"
    elif x == y:
        return "x e igual a y"
    else:
        return "x e menor que y"

x = int(input())
y = int(input())

print(compare(x,y))
