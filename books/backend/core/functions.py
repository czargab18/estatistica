# ADICIONAR links de CSS e JavaScript em cada <head> dos html
import os
import json
import re

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

def lista_books(path:str="./"):
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

    if not os.makedirs('./backend/data/books/', exist_ok=True): 
        with open('./backend/data/books/books.json', 'w', encoding='utf-8') as file:
            json.dump(CAMINHOS_ARQUIVOS, file, ensure_ascii=False, indent=4)

    return CAMINHOS_ARQUIVOS



# EXECUÇÃO DA FUNÇÃO
if __name__ == "__main__":
    print(lista_books())
