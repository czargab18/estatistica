"""
 * Pacote de funções para automatizar criação de artiglos para o site:
 * AINDA NÃO SERÁ 100% AUTOMATIZADO. PRECISAREI FAZER MUITAS COISAS MANUALMENTE
"""
from email.mime import image
import os
import sys
import json
import requests
import re
import string
import random
from bs4 import BeautifulSoup


# Função para capturar informações de um artigo
# Passos do scripts e funções

# - Funções para captura as informações separadamente

def import_article():
  """
   * Função para importar o artigo
  """
  with open('scripts\\newsroom\\posts\\article\\artigo.txt', 'r', encoding='utf-8') as file:
    article = file.read()
    return article

def get_title(article):
  """
   * Função para capturar o título do artigo
  """
  title = re.search(r'Titulo:\s*(.*)\s*;', article).group(1)
  return title

def get_subtitle(article):
  """
   * Função para capturar o subtítulo do artigo
  """
  subtitle = re.search(r'Subtitulo:\s*(.*)\s*;', article).group(1)
  return subtitle

def get_date(article):
  """
   * Função para capturar a data do artigo
  """
  date = re.search(r'data:\s*(.*)\s*', article).group(1)
  return date

def get_author(article):
  """
   * Função para capturar o autor do artigo
  """
  author = re.search(r'autor:\s*(.*)\s*', article).group(1)
  return author

def get_tags(article):
  """
   * Função para capturar as tags do artigo
  """
  tags = re.search(r'tags:\s*(.*)\s*', article).group(1).split(', ')
  return tags

def get_category(article):
  """
   * Função para capturar a categoria do artigo
  """
  category = re.search(r'categoria:\s*(.*)\s*', article).group(1)
  return category

def get_summary(article):
  """
   * Função para capturar o resumo do artigo
  """
  summary = re.search(r'resumo:\s*(.*)\s*', article).group(1)
  return summary

def get_images(article):
  """
   * Função para capturar as imagens do artigo
  """
  match = re.search(r'imagem:\s*\[(.*)\]\s*', article)
  if match:
    images = match.group(1).split('; ')
    return images
  return []

# gerar identificador par ao artigo
def gen_identificador():
    length = 9
    characters = string.ascii_lowercase + "123456789"
    identificador = ""
    for _ in range(length):
        identificador += random.choice(characters)
    return identificador


def path_article(data, identificador, pais="pt_BR"):
    """
    Função que gera o caminho para um artigo baseado no identificador, ano, mês e nome do arquivo.
    """
    data = data.replace('-', ' ')
    dia, mes, ano = map(str, data.split())

    # Caminho final
    path = os.path.join(
        f"/newsroom/articles/{pais}/",
        ano + "/",
        mes.zfill(2) + "/",
        dia + "/",
        identificador + "/",
    )
    return path

# Exemplo de uso
article = import_article()
print(get_title(article))
print(get_subtitle(article))
print(get_date(article))
print(get_author(article))
print(get_tags(article))
print(get_category(article))
print(get_summary(article))
print(get_images(article))

# - Função que salva as informações um json: data/articles.json
# - Função para criar um arquivo HTML padrão e adicionar o conteúdo
# - Função para limpar a pasta post/article após finalizar o processo


# função que chama outras funções
def concat_fun_artigo():
  """
   * Função para agrupar todas as funções de captura de informações
   * e chamar cada uma delas
  """
  article = import_article()
  info = {
      "title": get_title(article),
      "subtitle": get_subtitle(article),
      "date": get_date(article),
      "author": get_author(article),
      "tags": get_tags(article),
      "category": get_category(article),
      "summary": get_summary(article),
      "images": get_images(article)
  }
  return info


# Exemplo de uso
article_info = concat_fun_artigo()
for key, value in article_info.items():
  print(f"{key}: {value}")
