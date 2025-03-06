import os
import re
import json
import string
import random
from bs4 import BeautifulSoup, Comment
import shutil
import requests
from datetime import datetime


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

def verificacao(pergunta:str):
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

def import_file(caminho: str):
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

