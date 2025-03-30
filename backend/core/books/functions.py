# ADICIONAR links de CSS e JavaScript em cada <head> dos html
import os
import json
from pickle import TRUE
import re
from bs4 import BeautifulSoup

def importjson(caminho: str = "./data/books/books.json"):
    with open(caminho, 'r', encoding='utf-8') as file:
        return json.load(file)

def listabooks(path: str = "./books/docs/"):
    """
    Lista as pastas do tipo: '3 lestras e 4 numéros'
    Ignora pastas na raiz do repositório: /ac/ ou /wss/ .
    - return: Dicionário
        - formato: { "pastaPai": [ "path-arquivo1", "path-arquivo2" ] }
    """
    CAMINHOS_ARQUIVOS = {}
    PATTERN_BOOKS_NAME = re.compile(r'^[A-Z]{3}\d{4}$')
    for pasta in next(os.walk(path))[1]:
        if PATTERN_BOOKS_NAME.match(pasta):
            CAMINHO_PASTAS = os.path.join(path, pasta)
            CAMINHOS_ARQUIVOS[pasta] = []
            for subroot, subpastas, subarquivos in os.walk(CAMINHO_PASTAS):
                subpastas_filtradas = []
                for subpasta in subpastas:
                    if subpasta not in ['ac', 'wss', 'book', '.quarto', 'site_libs']:
                        subpastas_filtradas.append(subpasta)
                subpastas[:] = subpastas_filtradas

                for arquivo in subarquivos:
                    caminho_relativo = os.path.relpath(
                        os.path.join(subroot, arquivo), path)
                    caminho_relativo = caminho_relativo.replace("\\", "/")
                    caminho_completo = f"/books/{caminho_relativo}"
                    CAMINHOS_ARQUIVOS[pasta].append(caminho_completo)

    if not os.makedirs('./data/books/', exist_ok=True): 
        with open('./data/books/books.json', 'w', encoding='utf-8') as file:
            json.dump(CAMINHOS_ARQUIVOS, file, ensure_ascii=False, indent=4)

    return CAMINHOS_ARQUIVOS

def corsearchjson(books: bool = True, path: str = "./data/books/books.json"):
    """
    Corrige os caminhos duplicados no arquivo SEARCH.JSON
    """
    if not os.path.exists(path): 
        listabooks = listabooks()
    else:
        listabooks = importjson(path)

    # scripts para mover subpastas de books/docs/ para books/
    destino = "./books/"
    origem = "./books/docs/"
    if not os.path.exists(destino):
        os.makedirs(destino)

    for subpasta in next(os.walk(origem))[1]:
        origem_completa = os.path.join(origem, subpasta)
        destino_completo = os.path.join(destino, subpasta)

        if not os.path.exists(destino_completo):
            os.rename(origem_completa, destino_completo)
        else:
            for root, _, arquivos in os.walk(origem_completa):
                for arquivo in arquivos:
                    origem_arquivo = os.path.join(root, arquivo)
                    destino_arquivo = os.path.join(destino_completo, arquivo)
                    if not os.path.exists(destino_arquivo):
                        os.rename(origem_arquivo, destino_arquivo)
                    else:
                        print(f"Arquivo {arquivo} já existe em {destino_completo}.")

    # scripts para atualizar o searchJSON dos books para /books/{book}/...
    for book, arquivos in listabooks.items():
        search_json_path = f"./books/{book}/search.json"
        if os.path.exists(search_json_path):
            search_data = importjson(search_json_path)
            for item in search_data:
                if "objectID" in item:
                    item["objectID"] = f"/books/{book}/{item['objectID']}"
            with open(search_json_path, 'w', encoding='utf-8') as file:
                json.dump(search_data, file, ensure_ascii=False, indent=4)
    with open(path, 'w', encoding='utf-8') as file:
        json.dump(listabooks, file, ensure_ascii=False, indent=4)

    return listabooks

def corpathlinksearchjson(listabooks: dict = importjson('./data/books/books.json')):
    """
    Corrige Links do ./BOOKS/{books}/SEARCH.JSON
    :param listabooks: dict com os livros
    :return: None
    """
    def exportjson(data, filepath):
        """
        Exporta dados para um arquivo JSON.
        :param data: Dados a serem salvos (normalmente um dicionário ou lista).
        :param filepath: Caminho do arquivo onde os dados serão salvos.
        """
        with open(filepath, 'w', encoding='utf-8') as json_file:
            json.dump(data, json_file, ensure_ascii=False, indent=4)
        return True
    for book in listabooks:
        searchjsonbook = importjson(os.path.join(f"./books/{book}/search.json"))
        for item in searchjsonbook:
            object_id = item.get("objectID")
            href = item.get("href")
            if object_id and not object_id.startswith(f"/teste/books/{book}/"):
                item["objectID"] = f"/teste/books/{book}/{object_id}"
            if href and not href.startswith(f"/teste/books/{book}/"):
                item["href"] = f"/teste/books/{book}/{href}"
        exportjson(searchjsonbook, os.path.join(f"./books/{book}/search.json"))
    return "Atualização concluída."

# funções adicionais

LINKS = [
    '<link href="/wss/fonts.css?families=SF+Pro,v3"  rel="stylesheet"/>',
    '<link href="/ac/img/logo/estatistica.svg" rel="icon" type="image/svg+xml"/>',
    '<link href="/ac/img/logo/logo.png" rel="icon" type="image/png"/>',
    '<link href="/ac/styles.css" rel="stylesheet"/>',
    '<link href="/ac/books/bootstrap/bootstrap.min.css" rel="stylesheet"/>',
    '<link href="/ac/books/bootstrap/bootstrap-icons.css" rel="stylesheet"/>',
    '<link href="/ac/books/bootstrap/bootstrap-icons.woff" rel="stylesheet"/>',
    '<script src="/ac/books/bootstrap/bootstrap.min.js"></script>',
    '<script src="/ac/books/clipboard/clipboard.min.js"></script>',
    '<script src="/ac/books/quarto-html/anchor.min.js"></script>',
    '<script src="/ac/books/quarto-html/popper.min.js"></script>',
    '<link href="/ac/books/quarto-html/quarto-syntax-highlighting.css" rel="stylesheet"/>',
    '<script src="/ac/books/quarto-html/quarto.js"></script>',
    '<link href="/ac/books/quarto-html/tippy.css" rel="stylesheet"/>',
    '<script src="/ac/books/quarto-html/tippy.umd.min.js"></script>',
    '<script src="/ac/books/quarto-nav/headroom.min.js"></script>',
    '<script src="/ac/books/quarto-nav/quarto-nav.js"></script>',
    '<script src="/ac/books/quarto-search/autocomplete.umd.js"></script>',
    '<script src="/ac/books/quarto-search/fuse.min.js"></script>',
    '<script src="/ac/books/quarto-search/quarto-search.js"></script>',
]

PATTERN_BOOKS_NAME = re.compile(r'^[A-Z]{3}\d{4}$')
