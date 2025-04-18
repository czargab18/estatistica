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
 * - Algumas funções:
 *      - read: Lê o conteúdo de um arquivo no caminho especificado.
 *      - escrever: Escreve o conteúdo em um arquivo no caminho especificado.
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
    
if __name__ == "__main__":
    for key, value in CAMINHOS.items():
        if key == "lista_books":
            value = os.path.join("./", value.replace("\\", "/"))
            print(escrever(path=value, conteudo=ler(path=value)))

    print("Fim da execução do script!")