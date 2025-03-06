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
    # (1) Gera três identificadores aleatórios
    # (2) Verificar alguns deles não existe
    # (3) Se não existir, retorna o identificador
    return ...

def meta_info():
    # (1) Extrai meta informações do ./_backend_/scripts/newsroom/article/artigo.txt
    # (2) Retorna um dicionário com as informações
    #  "date-title-article": "Título do Artigo",
    #  "date-subtitle-article": "Subtítulo do Artigo",
    #  "date-author-article": "Autor do Artigo",
    #  "date-article": "Data do Artigo",
    #  "date-description-article": "Descrição do Artigo",
    #  "date-keywords-article": "Palavras-chave do Artigo",
    #  "date-category-article": "Categoria do Artigo",
    #  "date-disciplina-article": "Disciplina do Artigo",
    #  "date-codigo-disciplina-article": "Curso do Artigo"
    return ...

def content_article():
    # (1) Extrai o conteúdo do ./_backend_/scripts/newsroom/article/artigo.txt
    # (2) Retorna o conteúdo do artigo
    return ...

def save_content_article_in_json():
    # (1) Salva o conteúdo do artigo em um arquivo JSON
    # (2) O arquivo JSON é salvo em ./_backend_/data/article.json
    # usar: "meta_info()" e "content_article()"
    return ...

def janitor_json():
    # (1) Tratar erros da extração do conteúdo do artigo no arquivo JSON
    # (2) Salva o conteúdo do artigo em um arquivo JSON
    return ...

### ____ FUNÇÕES: JSON para HTML ____###

def template_html():
    # (1) Importar modelo HTML
    # (2) Corrigir links do arquivo HTML
    return ...

def mover_html():
    # (1) Mover HTML + /src/ para: "./newsroom/articles/pt_BR/ano/mes/identificador/"
    return ...