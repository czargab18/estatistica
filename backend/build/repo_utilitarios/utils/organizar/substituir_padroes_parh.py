import os
import re

# Função para substituir o padrão nos arquivos
def substituir_padrao(diretorio):
    for root, _, arquivos in os.walk(diretorio):
        for arquivo in arquivos:
            caminho_arquivo = os.path.join(root, arquivo)

            # Verifica se o arquivo é de texto (ex.: .html, .css, .js, .txt)
            if caminho_arquivo.endswith((".html", ".css", ".js", ".txt")):
                try:
                    with open(caminho_arquivo, "r", encoding="utf-8") as file:
                        conteudo = file.read()

                    # Substitui o padrão usando regex
                    novo_conteudo = re.sub(padrao_antigo, substituicao, conteudo)

                    # Salva o arquivo novamente, se algo foi alterado
                    if conteudo != novo_conteudo:
                        with open(caminho_arquivo, "w", encoding="utf-8") as file:
                            file.write(novo_conteudo)
                        print(f"Atualizado: {caminho_arquivo}")
                except Exception as e:
                    print(f"Erro ao processar {caminho_arquivo}: {e}")

########### Executa a função ###########

# Caminho do diretório onde os arquivos estão
diretorio_base = "./"
padrao_antigo = r"czargab18.github.io/estatistica/"
substituicao = "estatistica.pro/"

substituir_padrao(diretorio_base)

# Caminho do diretório onde os arquivos estão
diretorio_base = "./"
padrao_antigo = r"czargab18.github.io/"
substituicao = "estatistica.pro/"
substituir_padrao(diretorio_base)

# Caminho do diretório onde os arquivos estão
diretorio_base = "./"
padrao_antigo = r"(?<!/)ac/"
substituicao = "/ac/"

substituir_padrao(diretorio_base)

# Caminho do diretório onde os arquivos estão
diretorio_base = "./"
padrao_antigo = r"(\.\./)+wss/"
substituicao = "/wss/"

substituir_padrao(diretorio_base)

# Lista de padrões e substituições
padroes_substituicoes = [
    (r"czargab18.github.io/estatistica/", "estatistica.pro/"),
    (r"czargab18.github.io/", "estatistica.pro/"),
    (r"(?<!/)ac/", "/ac/"),
    (r"(\.\./)+wss/", "/wss/")
]

# Caminho do diretório onde os arquivos estão
diretorio_base = "./"

# Executa a função para cada par de padrão e substituição
for padrao_antigo, substituicao in padroes_substituicoes:
    substituir_padrao(diretorio_base)
