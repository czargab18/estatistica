import os
import json
import re
from bs4 import BeautifulSoup

# Parâmetros globais
PATTERN_BOOKS_NAME = re.compile(r'^[A-Z]{3}\d{4}$')


def readjson(caminho: str):
    """
    Lê um arquivo JSON e retorna seu conteúdo.
    """
    with open(caminho, 'r', encoding='utf-8') as file:
        return json.load(file)

def listabooks(path: str = "./books/"):
    """
    Lista as pastas do tipo: '3 letras e 4 números' e retorna os arquivos encontrados.
    """
    if not os.path.exists(path):
        print(f"Erro: O diretório '{path}' não existe.")
        return {}

    if not os.path.isdir(path):
        print(f"Erro: O caminho '{path}' não é um diretório.")
        return {}

    CAMINHOS_ARQUIVOS = {}
    try:
        for pasta in next(os.walk(path))[1]:
            if PATTERN_BOOKS_NAME.match(pasta):
                CAMINHO_PASTAS = os.path.join(path, pasta)
                CAMINHOS_ARQUIVOS[pasta] = []
                for subroot, _, subarquivos in os.walk(CAMINHO_PASTAS):
                    for arquivo in subarquivos:
                        caminho_relativo = os.path.relpath(
                            os.path.join(subroot, arquivo), path
                        ).replace("\\", "/")
                        CAMINHOS_ARQUIVOS[pasta].append(f"/books/{caminho_relativo}")
    except StopIteration:
        print(f"Erro: O diretório '{path}' está vazio ou não contém subdiretórios.")
        return {}

    return CAMINHOS_ARQUIVOS

def corrlinksheadbooks(listabooks: dict, base_path: str = "./books", ignore: list = None, rm: bool = True, remove: list = ["delete/site_libs"]):
    """
    Corrige os links no head dos arquivos HTML listados em listabooks,
    substituindo './' por '/'. Remove links e scripts que contenham padrões
    especificados na lista remove, se rm for True.
    """
    if ignore is None:
        ignore = []

    for book, files in listabooks.items():
        for filepath in files:
            relative_path = filepath.lstrip('/')
            absolute_path = os.path.normpath(os.path.join(
                base_path, relative_path.replace("books/", "")))
            
            # Log para verificar o caminho do arquivo
            print(f"Processando arquivo: {absolute_path}")
            
            if absolute_path.endswith(".html"):
                try:
                    with open(absolute_path, 'r', encoding='utf-8') as f:
                        soup = BeautifulSoup(f, 'html.parser')

                    # Corrigir links no <head>
                    head = soup.head
                    if head:
                        for tag in head.find_all(['link', 'script']):
                            # Log para verificar as tags encontradas
                            print(f"Tag encontrada: {tag}")

                            # Remover tags que contenham padrões na lista remove
                            if rm and (tag.has_attr('href') and any(pattern in tag['href'] for pattern in remove) or
                                       tag.has_attr('src') and any(pattern in tag['src'] for pattern in remove)):
                                print(f"Removendo tag: {tag}")
                                tag.decompose()
                                continue

                            # Verificar e corrigir o atributo 'href'
                            if tag.has_attr('href') and not any(ignored in tag['href'] for ignored in ignore):
                                original_href = tag['href']
                                tag['href'] = tag['href'].replace('./', '/')
                                print(f"Corrigido href: {original_href} -> {tag['href']}")

                            # Verificar e corrigir o atributo 'src'
                            if tag.has_attr('src') and not any(ignored in tag['src'] for ignored in ignore):
                                original_src = tag['src']
                                tag['src'] = tag['src'].replace('./', '/')
                                print(f"Corrigido src: {original_src} -> {tag['src']}")

                    # Sobrescrever o arquivo com o conteúdo corrigido
                    with open(absolute_path, 'w', encoding='utf-8') as f:
                        f.write(str(soup))
                        print(f"Arquivo salvo: {absolute_path}")
                except FileNotFoundError:
                    print(f"Arquivo não encontrado: {absolute_path}")
                except Exception as e:
                    print(f"Erro ao processar {absolute_path}: {e}")

if __name__ == '__main__':
    # Obter a lista de livros e arquivos
    books = listabooks(path="./books")
    print(books)

    # Corrigir links nos arquivos HTML
    corrlinksheadbooks(books, base_path="./books")
    print("Links corrigidos com sucesso!")
