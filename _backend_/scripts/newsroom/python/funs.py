import os
import re
import json
import string
import random
from bs4 import BeautifulSoup, Comment
import shutil
import requests
from datetime import datetime

###____ Funções úteis ____###

def create_dir(diretorio):
    """
    Verifica se um diretório existe e, caso não exista, cria-o.
    Args:
      diretorio (str): O caminho do diretório a ser verificado/criado.
    Returns:
      bool: Retorna True se o diretório for criado e False se ele já existia.
    """
    if not os.path.exists(diretorio):
        os.makedirs(diretorio)
        return True
    else:
        return False

def import_content_file(caminho: str):
    """
    Importa um arquivo a partir de um caminho.
    Args:
        caminho (str): O caminho do arquivo a ser importado.
    Returns:
        str: Retorna o conteúdo do arquivo.
    """
    with open(caminho, "r", encoding="utf-8") as arquivo:
        conteudo = arquivo.read()
    return conteudo

def verificacao(pergunta: str):
  """
  Faz uma pergunta ao usuário e verifica a resposta.
  Args:
      pergunta (str): A pergunta a ser feita ao usuário.
  Returns:
      bool: Retorna True, False ou None.
  """
  resposta = input(f'{pergunta}? (s/n): ').lower().strip()
  if resposta in ["sim", "s", "yes", "y"]:
      return True
  elif resposta in ["não", "nao", "n", "no", "ñ"]:
      return False
  else:
      return None

###____ FUNÇÕES: extração para JSON ____###

def identificador():
    """
    Gera três identificadores aleatórios, verifica se algum deles já existe no arquivo JSON
    e retorna um identificador que não exista.
    """
    def gerar_identificador():
        return ''.join(random.choices(string.ascii_letters + string.digits, k=8))
    caminho_json = "_backend_/data/articles.json"
    try:
        conteudo_json = import_content_file(caminho_json)
        dados = json.loads(conteudo_json)
    except FileNotFoundError:
        dados = {}
    for _ in range(3):
        id_aleatorio = gerar_identificador()
        if id_aleatorio not in dados:
            return id_aleatorio
    raise Exception("Não foi possível gerar um identificador único após 3 tentativas.")

def meta_info():
    """
    Extrai meta informações do ./_backend_/scripts/newsroom/article/artigo.txt
    e retorna um dicionário com as informações.
    """
    caminho_artigo = "./_backend_/scripts/newsroom/article/artigo.txt"
    conteudo = import_content_file(caminho_artigo)

    meta_info = {}
    padrao = re.compile(r'date-(\w+)-article:\s*(.*)')

    for linha in conteudo.split('\n'):
        match = padrao.match(linha)
        if match:
            chave = f"date-{match.group(1)}-article: "
            valor = match.group(2).strip()
            meta_info[chave] = valor

    return {"meta_info": meta_info}


def content_article():
    """
    Extrai o conteúdo do ./_backend_/scripts/newsroom/article/artigo.txt
    e retorna o conteúdo do artigo em um dicionário.
    """
    caminho_artigo = "./_backend_/scripts/newsroom/article/artigo.txt"
    conteudo = import_content_file(caminho_artigo)

    content_article = {
        "resumo": [],
        "introducao": [],
        "desenvolvimento": [],
        "conclusao": [],
        "referencias": [],
        "anexo": [] 
    }

    secao_atual = None
    for linha in conteudo.split('\n'):
        linha = linha.strip()
        if linha.startswith('--- inicio_'):
            secao_atual = linha.replace('--- inicio_', '').replace(' ---', '')
        elif linha.startswith('--- fim_'):
            secao_atual = None
        elif secao_atual:
            if secao_atual in content_article:
                content_article[secao_atual].append(linha)
            else:
                raise KeyError(f"Seção desconhecida: {secao_atual}")

    return {"content_article": content_article}

print(content_article())

def save_content_article_in_json():
    # (1) Salva o conteúdo do artigo em um arquivo JSON
    # (2) O arquivo JSON é salvo em ./_backend_/data/article.json
    # usar: "meta_info()" e "content_article()"
    return ...

def janitor_json():
    # (1) Tratar erros da extração do conteúdo do artigo no arquivo JSON
    # (2) Salva o conteúdo do artigo em um arquivo JSON
    # (3) Padrões: \"
    return ...

### ____ FUNÇÕES: JSON para HTML ____###

def template_html():
    # (1) Importar modelo HTML
    # (2) Corrigir links do arquivo HTML
    return ...

def mover_html():
    # (1) Mover HTML + /src/ para: "./newsroom/articles/pt_BR/ano/mes/identificador/"
    return ...