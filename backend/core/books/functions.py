# ADICIONAR links de CSS e JavaScript em cada <head> dos html
import markdown
import os
import json
from pickle import TRUE
import re
from bs4 import BeautifulSoup

def readjson(caminho: str = "./data/books/books.json"):
    with open(caminho, 'r', encoding='utf-8') as file:
        return json.load(file)

def readmeqmd(
    caminho: str = "./newshub/build/conteudo/",
    extensoes: list = ['.qmd', '.bib'],
    buscar: bool = True
):
    """
    Processa arquivos em um diretório ou um único arquivo e retorna um JSON com o conteúdo.

    :param caminho: Caminho do diretório ou arquivo.
    :param extensoes: Lista de extensões de arquivo a serem procuradas (usado apenas se buscar=True).
    :param buscar: Booleano que indica se deve buscar arquivos no diretório ou processar um único arquivo.
    :return: JSON com o nome do arquivo como chave e o conteúdo como valor.
    """
    resultado = {}

    if buscar:
        arquivos_encontrados = []
        for root, _, files in os.walk(caminho):
            for file in files:
                if any(file.endswith(ext) for ext in extensoes):
                    arquivos_encontrados.append(os.path.join(root, file))
    else:
        # Trata como um único arquivo.
        arquivos_encontrados = [caminho]

    for arquivo in arquivos_encontrados:
        try:
            with open(arquivo, 'r', encoding='utf-8') as file:
                conteudo = file.read()
            conteudo_html = markdown.markdown(
                conteudo, extensions=['extra', 'tables', 'toc'])
            resultado[os.path.basename(arquivo)] = conteudo_html
        except Exception as e:
            resultado[os.path.basename(
                arquivo)] = f"Erro ao processar o arquivo: {e}"

    return json.dumps(resultado, ensure_ascii=False, indent=4)
    
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
        listabooks = readjson(path)

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
            search_data = readjson(search_json_path)
            for item in search_data:
                if "objectID" in item:
                    item["objectID"] = f"/books/{book}/{item['objectID']}"
            with open(search_json_path, 'w', encoding='utf-8') as file:
                json.dump(search_data, file, ensure_ascii=False, indent=4)
    with open(path, 'w', encoding='utf-8') as file:
        json.dump(listabooks, file, ensure_ascii=False, indent=4)

    return listabooks

def corpathlinksearchjson(listabooks: dict = readjson('./data/books/books.json')):
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
        searchjsonbook = readjson(os.path.join(f"./books/{book}/search.json"))
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
    '<script src="https://cdn.jsdelivr.net/npm/mathjax@3/es5/tex-chtml-full.js" type="text/javascript"></script>'
]

PATTERN_BOOKS_NAME = re.compile(r'^[A-Z]{3}\d{4}$')

if __name__ == '__main__':
    diretorio = "./newshub/build/conteudo/"
    extensoes = ['.qmd']
    resultado = readmeqmd(
        caminho=diretorio, extensoes=extensoes, buscar=True)
    print(resultado)
