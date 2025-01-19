import os
import re

def corrigir_https_em_arquivos(diretorio):
    padrao = re.compile(r"https:/[^/]")
    for subdir, _, arquivos in os.walk(diretorio):
        for arquivo in arquivos:
            if arquivo.endswith(".html") or arquivo.endswith(".css"):
                caminho_arquivo = os.path.join(subdir, arquivo)
                with open(caminho_arquivo, "r", encoding="utf-8") as f:
                    conteudo = f.read()

                novo_conteudo = padrao.sub("https://", conteudo)

                with open(caminho_arquivo, "w", encoding="utf-8") as f:
                    f.write(novo_conteudo)

# Use a função passando o diretório do seu repositório
corrigir_https_em_arquivos("./")
