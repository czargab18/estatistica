import os
import re
import json

"""
 * Este script é destinado a auxiliar na automatização de books quarto.
 * Ele será usado principalmente para:
 * - injetar html (navbar e footer padrão do site) nas páginas do book_html.
 * - excluir pastas de output_libs_dir dos criadas pelos book_html.
 * - corrigir links no head dos arquivos book_html.
 * - corrigir links do search.json de cada book_html.
 * - criar e deletar a lista dos books disponíveis no repositório.
 * - Algumas funções:
 *      - [x] read: Lê o conteúdo de um arquivo no caminho especificado.
 *      - [x]  escrever: Sobrescreve o conteúdo em um arquivo no caminho especificado.
 *      - tempadrao: Compara se path tem o padrão informado
 *      - caminho: Retorna o caminho absoluto diretório ou subdiretórios.
 *      - corigirlinks: Corrige os links no head dos arquivos book_html.
 *   *      - corigirlinkssearch: Corrige os links do search.json de cada book_html.
 *      - listabooks: Cria uma lista dos books e seus arquivo disponíveis.
 *   *      - criarbooks: Criar a lista dos books que não estão disponíveis.
 *   *      - deletarbooks: Deleta a lista dos books que não estão disponíveis.
 *      - incluirin: Inclui o conteúdo em um arquivo
 *    *      - incluirinhead: Inclui o conteúdo de um arquivo no head dos arquivos book_html.
 *    *      - incluirinbody: Inclui o conteúdo de um arquivo no body dos arquivos book_html.
"""

CAMINHOS = {
    "pattern_book": re.compile(r'^[A-Z]{3}\d{4}$'),
    "dir_base": os.path.abspath(os.path.join(os.path.dirname(__file__), "../../../")).replace("\\", "/"),
    "dir_include": os.path.normpath("./books/build/include/"),
    "lista_books": os.path.normpath("./backend/data/books/books.json"),
}

def criardir(path: str = None):
    return os.makedirs(path, exist_ok=True)

def ler(path: str = None):
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
    >>> content = ler("caminho/para/arquivo.txt")
    >>> print(content)
    """
    with open(path, "r", encoding="utf-8") as file:
        return file.read()

def escrever(path, conteudo):
    """
    Escreve conteúdo em um arquivo.

    Parâmetros:
    ----------
    path : str
        O caminho completo para o arquivo onde o conteúdo será escrito.
    conteudo : str
        O conteúdo que será escrito no arquivo.

    Retorna:
    -------
    None
    """
    with open(path, "w", encoding="utf-8") as file:
        file.write(conteudo)
        return True


def listarbooks(path: str = None, salvedir: str = None, nomefile: str = "books.json"):
    if path is None or not os.path.exists(path):
        return "Erro: Não aponta para um arquivo ou diretório válido!"
    
    if not os.path.isdir(path):
        return "Erro: O caminho especificado não é um diretório!"
    
    path = path.replace("\\", "/")
    CAMINHOS_ARQUIVOS = {}
    PATTERN_BOOKS_NAME = CAMINHOS["pattern_book"]

    try:
        for pasta in os.listdir(path):
            pasta_path = os.path.join(path, pasta)
            if os.path.isdir(pasta_path) and PATTERN_BOOKS_NAME.match(pasta):
                CAMINHOS_ARQUIVOS[pasta] = []
                for subroot, subpastas, subarquivos in os.walk(pasta_path):
                    subpastas[:] = [
                        subpasta for subpasta in subpastas if subpasta not in ['ac', 'wss', 'book', '.quarto', 'site_libs']
                    ]
                    for arquivo in subarquivos:
                        caminho_relativo = os.path.relpath(
                            os.path.join(subroot, arquivo), path
                        ).replace("\\", "/")
                        caminho_completo = f"/books/{caminho_relativo}"
                        CAMINHOS_ARQUIVOS[pasta].append(caminho_completo)
    except Exception as e:
        print(f"Erro ao processar o diretório '{path}': {e}")
        return {}

    if salvedir is not None:
        os.makedirs(salvedir, exist_ok=True)
        salvedir = os.path.join(salvedir, nomefile).replace("\\", "/")
        with open(salvedir, 'w', encoding='utf-8') as file:
            json.dump(CAMINHOS_ARQUIVOS, file, ensure_ascii=False, indent=4)
    else:
        return CAMINHOS_ARQUIVOS

print(listarbooks(path= "./books", salvedir="./backend/data/books/"))
