import os
import re

"""
 * Este script é destinado a auxiliar na automatização de books quarto.
 * Ele será usado principalmente para:
 * - injetar html (navbar e footer padrão do site) nas páginas do book_html.
 * - excluir pastas de output_libs_dir dos criadas pelos book_html.
 * - corrigir links no head dos arquivos book_html.
 * - corrigir links do search.json de cada book_html.
 * - criar e deletar a lista dos books disponíveis no repositório.
"""

CAMINHOS = [
    "_comment_: caminhos para o repositório do projeto",
    os.path.abspath(os.path.join(os.path.dirname(__file__), "../../../")).replace("\\", "/"),
    re.compile(r'^[A-Z]{3}\d{4}$'),
    os.path.normpath("/backend/data/books/books.json"), 
    os.path.normpath("./newshub/build/conteudo/"),
    os.path.normpath("./books/"),
    os.path.normpath("./data/books/"),
    os.path.normpath("./books/build/include/include-in-body"),
]

def read(path: str = None, tipefile: list = None):
    """
    Lê o conteúdo de um arquivo no caminho especificado.

    Parâmetros:
    ----------
    path : str
        O caminho completo para o arquivo que será lido.
    tipefile : list, opcional
        Uma lista de tipos de arquivos suportados (não utilizado atualmente na lógica).

    Retorna:
    -------
    str
        O conteúdo do arquivo como uma string, caso seja um arquivo de texto.

    Exceções:
    --------
    FileNotFoundError
        Se o arquivo especificado no caminho não for encontrado.
    UnicodeDecodeError
        Se o arquivo não puder ser decodificado como UTF-8.

    Exemplo:
    --------
    >>> content = read("caminho/para/arquivo.txt")
    >>> print(content)
    """
    with open(path, "r", encoding="utf-8") as file:
        return file.read()

if __name__ == "__main__":
    ...
    print("Fim da execução do script!")