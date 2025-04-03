"""
Descrição sobre como se usa este script
 - Ele é utilizado para corrigir os caminhos dos arquivos de uma página web que está sendo migrada de um ambiente para outro.
 - O script percorre todos os arquivos de um diretório e substitui os caminhos antigos por novos.
 - O script é executado no terminal e solicita ao usuário o ambiente de destino da migração.
 - O script possui três ambientes de destino: hospedagem, local e github_pages.
 - O script possui três conjuntos de padrões de caminhos antigos e novos, um para cada ambiente.
 - O script percorre todos os arquivos de um diretório e substitui os caminhos antigos pelos novos.
 """

import os
import re

# Diretório Raiz
diretorio_base = "./"

def renomear_caminhos(caminho, padroes_antigos, substituicoes):
    for padrao_antigo, substituicao in zip(padroes_antigos, substituicoes):
        caminho = caminho.replace(padrao_antigo, substituicao)
    return corrigir_barras_duplas(caminho)


def corrigir_barras_duplas(caminho):
    caminho = re.sub(r"(estatistica/)+", "/estatistica/", caminho)
    caminho = re.sub(r"//+", "/", caminho)
    return caminho


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


def substituir_texto_em_arquivos(diretorio, padroes_antigos, substituicoes):
    for raiz, _, arquivos in os.walk(diretorio):
        for nome_arquivo in arquivos:
            if nome_arquivo.endswith((".html", ".css", ".js")):
                caminho_arquivo = os.path.join(raiz, nome_arquivo)
                try:
                    with open(caminho_arquivo, "r", encoding="utf-8") as arquivo:
                        conteudo = arquivo.read()
                    conteudo_modificado = renomear_caminhos(
                        conteudo, padroes_antigos, substituicoes
                    )
                    with open(caminho_arquivo, "w", encoding="utf-8") as arquivo:
                        arquivo.write(conteudo_modificado)
                except Exception as e:
                    print(f"Erro ao processar o arquivo {caminho_arquivo}: {e}")


if __name__ == "__main__":
    ambiente = input("Digite o ambiente (hospedagem, local ou github_pages): ")
    ambiente = ambiente.lower()

    if ambiente in ["hospedagem", "h"]:
        padroes_antigos = [
            r"estatistica/sd/",
            r"estatistica/ac/",
            r"estatistica/wss/",
            r"sd/",
            r"ac/",
            r"wss/",
        ]
        substituicoes = ["/sd/", "/ac/", "/wss/", "/sd/", "/ac/", "/wss/"]
    elif ambiente in ["local", "l"]:
        padroes_antigos = [
            r"estatistica/ac/",
            r"estatistica/wss/",
            r"estatistica/sd/",
            r"ac/",
            r"wss/",
            r"sd/",
        ]
        substituicoes = ["/ac/", "/wss/", "/sd/", "/ac/", "/wss/", "/sd/"]
    elif ambiente in ["github_pages", "g", "gp"]:
        padroes_antigos = [r"/ac/", r"/wss/", r"/sd/", r"ac/", r"wss/", r"sd/"]
        substituicoes = ["/estatistica/ac/", "/estatistica/wss/", "/estatistica/sd/"]
    else:
        print("Ambiente inválido. Use 'hospedagem', 'local' ou 'github_pages'.")
        exit()

    substituir_texto_em_arquivos(diretorio_base, padroes_antigos, substituicoes)

    # Corrigir
    corrigir_https_em_arquivos("./")
