"""
Remove as linhas comentadas desconsiderando as que tem o padrão: padrao_antigo = r"<!--"......
"""
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
                        conteudo = file.readlines()

                    # Remove linhas que começam com <!--, exceto aquelas que contêm padrao_antigo
                    novo_conteudo = []
                    for linha in conteudo:
                        if linha.strip().startswith("<!--") and padrao_antigo not in linha:
                            continue
                        novo_conteudo.append(linha)

                    # Salva o arquivo novamente, se algo foi alterado
                    if conteudo != novo_conteudo:
                        with open(caminho_arquivo, "w", encoding="utf-8") as file:
                            file.writelines(novo_conteudo)
                        print(f"Atualizado: {caminho_arquivo}")
                except Exception as e:
                    print(f"Erro ao processar {caminho_arquivo}: {e}")

########### Executa a função ###########

# Caminho do diretório onde os arquivos estão
diretorio_base = "./"
padrao_antigo = r"<!-- <path"

substituir_padrao(diretorio_base)
