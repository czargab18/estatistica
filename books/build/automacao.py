import os
import json
from core import ler, corrlinksheadbooks, CAMINHOS

if __name__ == "__main__":
    caminho = CAMINHOS["lista_books"]
    print(caminho)
    books = ler(caminho)
    if isinstance(books, str):
        books = json.loads(books)
        for book in books:
            print(book, type(book))
            print(corrlinksheadbooks(books, base_path=CAMINHOS["path_books"]))
