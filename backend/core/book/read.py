import mimetypes
import os
import re
import pandas
CAMINHOS = [
    # SYS_BASE_CAMINHO
    re.compile(r'^[A-Z]{3}\d{4}$'),  # PATTERN_BOOKS_NAME
    os.path.normpath("/backend/data/books/books.json"),  # PATH_BOOKS_JSON
    os.path.normpath("./newshub/build/conteudo/"),
    os.path.normpath("./books/"),  # Caminho base para listabooks
    os.path.normpath("./data/books/"),  # Caminho para salvar JSON
    os.path.normpath("./books/docs/"),  # Origem para corsearchjson
    os.path.normpath("./books/"),  # Destino para corsearchjson
    os.path.normpath("./backend/data/books/books.json"),
    os.path.normpath("./books/build/include/include-in-body"),
]

def read(path: str = None, tipefile: list = None):
    with open(path, "r", encoding="utf-8") as file:
        return file.read()


if __name__ == "__main__":
    # Testando a função read com um arquivo de exemplo
    arquivo = os.path.normpath("./backend/data/books/teste.qmd")
    conteudo = read(arquivo)
    print(conteudo)
