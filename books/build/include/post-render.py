import os
import sys
from backend.core.books.functions import listabooks, corrlinksheadbooks, includeinbody

# Adiciona o diretório base ao sys.path
base_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../../"))
sys.path.append(base_path)

caminho_base = os.path.join(base_path, "books")
print(caminho_base)
books = listabooks(path=caminho_base)
corrlinksheadbooks(books, base_path=caminho_base)
includeinbody()
print("-"*13, "Links corrigidos com sucesso!", "-"*13, sep=" ")
