import sys
import os

# Define o caminho base do repositório
BASE_DIR = os.path.abspath(os.path.join(os.path.dirname(__file__), '../../../'))

# Adiciona o diretório base ao sys.path
sys.path.append(BASE_DIR)

# Define uma variável de ambiente para o caminho base
os.environ["QUARTO_BASE_DIR"] = BASE_DIR

from backend.core.books.functions import listabooks, corrlinksheadbooks, includeinbody

if __name__ == '__main__':
    print("Caminho Base:", BASE_DIR.replace("\\", "/"))
    # Ajusta os caminhos relativos para usar o BASE_DIR
    books = listabooks(path=os.path.join(BASE_DIR, "books"))
    corrlinksheadbooks(books, base_path=os.path.join(BASE_DIR, "books"))
    includeinbody()
    print("-"*13, "Links corrigidos com sucesso!", "-"*13, sep=" ")
