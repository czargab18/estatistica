from bs4 import BeautifulSoup
from operator import length_hint
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
        LENGTH = 10
        return ''.join(random.choices(string.ascii_lowercase + string.digits, k=LENGTH))
    
    caminho_json = "./config/data/articles.json"
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
    Extrai meta informações do ././config/scripts/newsroom/article/artigo.txt
    e retorna um dicionário com as informações.
    """
    caminho_artigo = "././config/scripts/newsroom/article/artigo.txt"
    conteudo = import_content_file(caminho_artigo)

    meta_info = {}
    padrao = re.compile(r'date-(\w+)-article:\s*(.*)')

    for linha in conteudo.split('\n'):
        match = padrao.match(linha)
        if match:
            chave = f"date-{match.group(1)}-article"
            valor = match.group(2).strip()
            meta_info[chave] = valor

    return meta_info

def content_article():
    """
    Extrai o conteúdo do ././config/scripts/newsroom/article/artigo.txt
    e retorna o conteúdo do artigo em um dicionário.
    """
    caminho_artigo = "././config/scripts/newsroom/article/artigo.txt"
    conteudo = import_content_file(caminho_artigo)

    content_article = {
        "resumo": [],
        "introducao": [],
        "desenvolvimento": [],
        "conclusao": [],
        "referencias": [],
        "anexos": []  # Corrigido para "anexos" em vez de "anexo"
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
                if ': ' in linha:
                    prefixo, conteudo_linha = linha.split(': ', 1)
                    content_article[secao_atual].append(conteudo_linha)
                else:
                    content_article[secao_atual].append(linha)

    return content_article

def save_content_article_in_json():
    """
    Salva o conteúdo do artigo em um arquivo JSON.
    O arquivo JSON é salvo em ././config/data/article.json
    """
    caminho_json = "././config/data/article.json"
    artigo_conteudo = content_article()
    info_meta = meta_info()
    id_artigo = identificador()

    try:
        conteudo_json = import_content_file(caminho_json)
        dados = json.loads(conteudo_json)
    except FileNotFoundError:
        dados = {}

    dados[id_artigo] = {
        "meta_info": info_meta,
        "content-article": artigo_conteudo
    }

    with open(caminho_json, "w", encoding="utf-8") as arquivo:
        json.dump(dados, arquivo, ensure_ascii=False, indent=4)

    return dados

def janitor():
    # (1) Tratar erros da extração do conteúdo do artigo no arquivo JSON
    # (2) Salva o conteúdo do artigo em um arquivo JSON
    # (3) Padrões: \"
    return ...

### ____ FUNÇÕES: JSON para HTML ____###

def template_html():
    caminho_modelo_html = "./config/scripts/newsroom/modelo/modelo.html"
    caminho_json = "./config/data/article.json"

    # Carrega o modelo HTML
    with open(caminho_modelo_html, "r", encoding="utf-8") as arquivo:
        soup = BeautifulSoup(arquivo, "html.parser")

    # Carrega o conteúdo do JSON
    with open(caminho_json, "r", encoding="utf-8") as arquivo:
        dados = json.load(arquivo)

    # Supondo que estamos usando o primeiro artigo do JSON
    id_artigo = list(dados.keys())[0]
    artigo = dados[id_artigo]

    # Adiciona as meta tags no head do HTML
    head_tag = soup.head
    meta_info = artigo["meta_info"]
    for key, value in meta_info.items():
        meta_tag = head_tag.find("meta", {"data-" + key: True})
        if meta_tag:
            meta_tag.attrs["data-" + key] = value
        else:
            new_meta_tag = soup.new_tag("meta")
            new_meta_tag.attrs["data-" + key] = value
            head_tag.append(new_meta_tag)

    # Achar todas as divs com id igual a id="section-*"
    for secao, conteudo in artigo["content-article"].items():
        div_tag = soup.find("div", {"id": f"section-{secao}"})
        if div_tag:
            div_tag.clear()
            for item in conteudo:
                p_tag = soup.new_tag("p")
                p_tag.string = item
                div_tag.append(p_tag)

    # Salva o HTML atualizado
    caminho_html_atualizado = "./config/scripts/newsroom/article/index.html"
    with open(caminho_html_atualizado, "w", encoding="utf-8") as arquivo:
        arquivo.write(str(soup))

    return caminho_html_atualizado


def mover_html():
    caminho_json = "./config/data/article.json"
    caminho_html_atualizado = "./config/scripts/newsroom/article/index.html"
    caminho_src = "./config/scripts/newsroom/article/src/"

    # Carrega o conteúdo do JSON
    with open(caminho_json, "r", encoding="utf-8") as arquivo:
        dados = json.load(arquivo)

    # Supondo que estamos usando o primeiro artigo do JSON
    id_artigo = list(dados.keys())[0]
    artigo = dados[id_artigo]

    # Extrai a data e o identificador do artigo
    data_artigo = artigo["meta_info"]["date-data-article"]
    identificador = id_artigo

    # Converte a data para o formato ano/mes/dia
    data_parts = data_artigo.split("-")
    ano = data_parts[2]
    mes = data_parts[1]
    dia = data_parts[0]

    # Define o caminho de destino
    caminho_destino = f"./newsroom/articles/pt_BR/{ano}/{mes}/{dia}/{identificador}/"
    os.makedirs(caminho_destino, exist_ok=True)

    # Move o arquivo HTML para o caminho de destino
    shutil.move(caminho_html_atualizado, os.path.join(
        caminho_destino, "index.html"))

    # Mover a pasta /src/ irmão do arquivo index.html com pasta pai: article
    if os.path.exists(caminho_src):
        shutil.move(caminho_src, os.path.join(caminho_destino, "src"))

    return caminho_destino

def list_index():
    # (1) Pega os identificadores e criar uma lista em ./newsroom/index.html
    return ...