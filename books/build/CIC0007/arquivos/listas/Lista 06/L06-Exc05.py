n = int(input())

M = []
for i in range(n):
    M.append(input().split())
    
for i in reversed(range(n)):
    for j in range(n):
        
        if M[i][j] == ".":
            
            if i - 1 >= 0 and M[i - 1][j] == "o":
                M[i][j] = "o"
                M[i - 1][j] = "."
                
for i in range(n):
    print(" ".join(M[i]), end="")
    print()