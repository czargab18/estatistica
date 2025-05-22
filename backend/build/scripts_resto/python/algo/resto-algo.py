import os
import json
import re
from bs4 import BeautifulSoup
from core.books.functions import *

########### CORRIGIR FUNÇÃO ABAIXO  ###########


def corpathhtml(listabooks:dict= importjson('./data/books/books.json')):
    """
    Corrige os links path /books/{book}/*.html de cada .html dos books com base em data\books\books.json
    """

    for book, links in listabooks.items():
        for arquivo in links:
            if arquivo.endswith('.html'):
                caminho_html = f"/teste{arquivo}"
                if not os.path.exists(f"/teste{caminho_html}"):
                    print(f"Arquivo não encontrado: {caminho_html}")
                    continue
                with open(caminho_html, 'r', encoding='utf-8') as file:
                    soup = BeautifulSoup(file, 'html.parser')
                links_html = soup.find_all('a')
                for link in links_html:
                    if 'href' in link.attrs:
                        href = link['href']
                        if href.startswith('/books/') and not href.startswith('/books/' + book):
                            novo_link = href.replace(book)
                            link['href'] = novo_link
                with open(caminho_html, 'w', encoding='utf-8') as file:
                    file.write(str(soup))
    return "Correção finalizada com sucesso!"

def addlinkshead(json_file="./data/books/books.json"):
    # Carregando dados do arquivo JSON
    with open(json_file, 'r') as file:
        data = json.load(file)

    for key, paths in data.items():
        for path in paths:
            if path.endswith('.html'):
                # Caminho completo do arquivo HTML
                full_path = os.path.join(".", path)

                # Verifica se o arquivo existe
                if os.path.exists(full_path):
                    with open(full_path, 'r', encoding='utf-8') as html_file:
                        soup = BeautifulSoup(html_file, 'html.parser')

                    # Adiciona cada link e script ao cabeçalho do HTML
                    head = soup.head
                    if head:
                        for link in LINKS:
                            head.append(BeautifulSoup(link, 'html.parser'))

                    # Escreve de volta o conteúdo modificado no arquivo HTML
                    with open(full_path, 'w', encoding='utf-8') as html_file:
                        html_file.write(str(soup))
                else:
                    print(f"Arquivo não encontrado: {full_path}")

########### PARAMETROS E TESTE  ###########

LINKS = [
    '<link href="/wss/fonts.css?families=SF+Pro,v3"  rel="stylesheet"/>',
    '<link href="/ac/img/logo/estatistica.svg" rel="icon" type="image/svg+xml"/>',
    '<link href="/ac/img/logo/logo.png" rel="icon" type="image/png"/>',
    '<script src="/ac/books/quarto-nav/quarto-nav.js"></script>',
    '<script src="/ac/books/quarto-search/autocomplete.umd.js"></script>',
    '<script src="/ac/books/quarto-search/fuse.min.js"></script>',
]

PATTERN_BOOKS_NAME = re.compile(r'^[A-Z]{3}\d{4}$')

print(corpathhtml())
