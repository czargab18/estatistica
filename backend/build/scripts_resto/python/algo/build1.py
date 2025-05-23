import backend
import os

# Função para vasculhar todo o meu repositório e devolver apenas quais são os tipos de arquivos que existem nele

def listar_tipos_arquivos(diretorio):
    tipos_arquivos = set()
    for root, _, files in os.walk(diretorio):
        for file in files:
            _, ext = os.path.splitext(file)
            if ext:
                tipos_arquivos.add(ext)
    return list(tipos_arquivos)


print(listar_tipos_arquivos(diretorio="C:/Users/cesar.oliveira/Documents/github/estatistica"))
