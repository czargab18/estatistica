def troca(n, fonte, alvo, idle, passos):
    if n > 0:
        passos = troca(n-1, fonte, idle, alvo, passos)
        if passos <= 0:
            return passos
        passos = passos - 1
        alvo.append(fonte.pop())
        if passos <= 0:
            return passos
        passos = troca(n-1, idle, alvo, fonte, passos)
        if passos <=0:
            return passos
 
    return passos
  
discos, passos = input().split()
discos, passos = [int(discos),int(passos)] 
E = list(range(discos))
E.reverse()
C = []
D = []
troca(discos, E, D, C, passos)
print(len(E), len(C), len(D))