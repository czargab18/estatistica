from backend.core.books.functions import listabooks, corrlinksheadbooks, includeinbody
import sys
import os

# Define o diretório base como sendo a pasta "estatistica"
BASE_DIR = os.path.abspath(os.path.join(
    # Caminho relativo até "estatistica"
    os.path.dirname(__file__), '../../../'))
# Caminho do arquivo JSON
json_path = os.path.join(BASE_DIR, 'backend/data/books/books.json')

# Adiciona o BASE_DIR ao sys.path para permitir importações relativas
sys.path.append(BASE_DIR)

# Define uma variável de ambiente para o Quarto
os.environ["QUARTO_BASE_DIR"] = BASE_DIR

# Importa funções necessárias do backend

if __name__ == '__main__':
    # Exibe o caminho base no formato Unix
    print("Caminho Base:", BASE_DIR.replace("\\", "/"))

    # Ajusta os caminhos relativos para usar o BASE_DIR
    try:
        # Gera a lista de livros usando o caminho correto
        books = listabooks(path=os.path.join(BASE_DIR, "books"))

        # Corrige os links no cabeçalho usando o caminho base
        corrlinksheadbooks(books, base_path=os.path.join(BASE_DIR, "books"))

        # Inclui o conteúdo no corpo do documento
        includeinbody()

        # Mensagem de sucesso
        print("-" * 13, "Links corrigidos com sucesso!", "-" * 13, sep=" ")

    except FileNotFoundError as e:
        # Erro caso o arquivo JSON ou algum caminho não seja encontrado
        print(f"[Erro]: Arquivo ou diretório não encontrado: {e}")
    except Exception as e:
        # Tratamento genérico de erros
        print(f"[Erro]: Ocorreu um erro inesperado: {e}")
