import os
import shutil
import glob
import re
import json
import random
import string


path = "posts/article/*.txt"
path = "posts/article/imgs-*"

def verificacao(pergunta):
    """
       Verifica se a resposta é sim ou não
       """
    if pergunta in ["sim", "s"]:
        return True
    else:
        if pergunta in ["não", "nao", "n"]:
            return False

def continuar(pergunta):
    pergunta = input("Deseja continuar? Digite Sim ou Não: ").lower()
    verificacao(pergunta)

def existe_files_in_article(folder="posts/article/"):
    """
    Função que verifica se a pasta desejada existe.
     - folder: str, nome da pasta. Padrão: 'posts/article/'
    """
    pergunta = input(f"Há conteúdo na pasta {folder}? Digite Sim ou Não: ").lower()
    resposta = verificacao(pergunta)
    return resposta


def ler_nome_file(path="posts/article/"):
    """
    Função que retorna o mês e o ano a partir do nome do arquivo .txt, sem a extensão, a partir do caminho fornecido.
    exemplo-padrão: "posts/article/mes-ano.txt"
     - mes: vai de 1 até 12
     - ano: exemplo 2025
    """
    arquivos_txt = glob.glob(os.path.join(path, "*.txt"))
    if not arquivos_txt:
        raise FileNotFoundError("Nenhum arquivo .txt encontrado no caminho fornecido.")

    nome_arquivo = os.path.splitext(os.path.basename(arquivos_txt[0]))[0]
    match = re.match(r"(0?[1-9]|1[0-2])-(\d{4})", nome_arquivo)
    if match:
        mes, ano = match.groups()
        return {"mes": int(mes), "ano": int(ano)}
    else:
        raise ValueError("O nome do arquivo não está no formato esperado 'mes-ano'.")


def ler_conteudo_arquivo(path="posts/article/"):
    """
    Função que lê o arquivo e retorna o conteúdo do arquivo dentro de um objeto.
     - path: str, nome do arquivo a ser lido.
    """
    try:
        with open(path, "r") as arquivo:
            conteudo = arquivo.read()
            return {"path": path, "conteudo": conteudo}
    except FileNotFoundError:
        print(f"Erro: O arquivo '{path}' não foi encontrado.")
        return {"path": path, "conteudo": None}


def gen_id_artigo():
    length = 9
    characters = string.ascii_lowercase + "123456789"
    identificador = ""
    for _ in range(length):
        identificador += random.choice(characters)
    return identificador


def mover_imgs_para_artigo(
    src_path="posts/article/imgs-e-formulas/", destino="articles/pt_BR/2025/2/"
):
    """
    Função que move as imagens da pasta de origem para a pasta de destino.
    A pasta de destino é construída com base no identificador do artigo.
    """
    pass


""" Teste """
## print(ler_nome_file(path="posts/article/"))
## print(ler_conteudo_arquivo(path="posts/article/2-2025.txt"))
## print(gen_id_artigo())


""" FUNÇÕES PARA TRATAR O CONTEÚDO DO .txt PARA index.html"""
