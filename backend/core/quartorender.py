import os
import re
import json
from bs4 import BeautifulSoup

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
                        subpasta
                        for subpasta in subpastas
                        if subpasta not in ["ac", "wss", "book", ".quarto", "site_libs"]
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
        with open(salvedir, "w", encoding="utf-8") as file:
            json.dump(CAMINHOS_ARQUIVOS, file, ensure_ascii=False, indent=4)
    else:
        return CAMINHOS_ARQUIVOS


def includeinheadbooks(
    links,
    booksin: str = "./books/",
    tipoarquivo: str = ".html",
    linksin: str = "./books/build/include/include-in-head",
    headclean: bool = False,
):
    return ...


def corrlinksheadbooks(
    listabooks: dict,
    base_path: str = "./books",
    ignore: list = None,
    rm: bool = True,
    remove: list = ["delete/site_libs"],
):
    """
    Corrige os links no head dos arquivos HTML listados em listabooks,
    substituindo './' por '/'. Remove links e scripts que contenham padrões
    especificados na lista remove, se rm for True.

    Args:
        listabooks (dict): Dicionário com os livros e seus respectivos arquivos HTML.
        base_path (str): Caminho base onde os arquivos estão localizados.
        ignore (list): Lista de partes do caminho ou links a serem ignorados. Se None, corrige todos os links.
        rm (bool): Se True, remove links e scripts que contenham padrões na lista remove.
        remove (list): Lista de padrões de links ou scripts a serem removidos.
    """
    if ignore is None:
        ignore = []

    for book, files in listabooks.items():
        for filepath in files:
            relative_path = filepath.lstrip("/")
            absolute_path = os.path.normpath(
                os.path.join(base_path, relative_path.replace("books/", ""))
            )

            # Log para verificar o caminho do arquivo
            # print(f"Processando arquivo: {absolute_path}")

            if absolute_path.endswith(".html"):
                try:
                    with open(absolute_path, "r", encoding="utf-8") as f:
                        soup = BeautifulSoup(f, "html.parser")

                    # Corrigir links no <head>
                    head = soup.head
                    if head:
                        for tag in head.find_all(["link", "script"]):
                            # Log para verificar as tags encontradas
                            # print(f"Tag encontrada: {tag}")

                            # Remover tags que contenham padrões na lista remove
                            if rm and (
                                tag.has_attr("href")
                                and any(pattern in tag["href"] for pattern in remove)
                                or tag.has_attr("src")
                                and any(pattern in tag["src"] for pattern in remove)
                            ):
                                # print(f"Removendo tag: {tag}")
                                tag.decompose()
                                continue

                            # Verificar e corrigir o atributo 'href'
                            if (
                                tag.has_attr("href")
                                and tag["href"].startswith("./")
                                and not any(
                                    ignored in tag["href"] for ignored in ignore
                                )
                            ):
                                original_href = tag["href"]
                                tag["href"] = tag["href"].replace("./", "/")
                                # print(f"Corrigido href: {original_href} -> {tag['href']}")

                            # Verificar e corrigir o atributo 'src'
                            if (
                                tag.has_attr("src")
                                and tag["src"].startswith("./")
                                and not any(ignored in tag["src"] for ignored in ignore)
                            ):
                                original_src = tag["src"]
                                tag["src"] = tag["src"].replace("./", "/")
                                # print(f"Corrigido src: {original_src} -> {tag['src']}")

                    # Sobrescrever o arquivo com o conteúdo corrigido
                    with open(absolute_path, "w", encoding="utf-8") as f:
                        f.write(str(soup))
                        # print(f"Arquivo salvo: {absolute_path}")
                except FileNotFoundError:
                    print(f"Arquivo não encontrado: {absolute_path}")
                except Exception as e:
                    print(f"Erro ao processar {absolute_path}: {e}")


def corrigirlinksinhead(path: str, corrections: dict, rmhead: str, patternfolders: str):
    """
    Processa pastas que contenham o padrão especificado e executa as funções de correção e remoção de links.

    :param path: Caminho do diretório base.
    :param corrections: Dicionário com padrões antigos como chave e substituições como valor.
    :param rmhead: Texto que, se encontrado no href ou src, indica que o elemento deve ser removido.
    :param patternfolders: Padrão para identificar pastas relevantes.
    """
    from bs4 import BeautifulSoup
    import os
    import re

    def buscar_pastas_com_padrao(base_path, pattern):
        """Busca pastas que correspondem ao padrão especificado."""
        return [
            os.path.join(base_path, pasta)
            for pasta in os.listdir(base_path)
            if os.path.isdir(os.path.join(base_path, pasta)) and re.match(pattern, pasta)
        ]

    def corrigir_links(tags, corrections):
        """Corrige os atributos href ou src das tags encontradas."""
        for tag in tags:
            if tag.has_attr("href"):
                for old, new in corrections.items():
                    if old in tag["href"]:
                        tag["href"] = tag["href"].replace(old, new)
            if tag.has_attr("src"):
                for old, new in corrections.items():
                    if old in tag["src"]:
                        tag["src"] = tag["src"].replace(old, new)

    def remover_links_e_scripts(tags, texto_para_remover):
        """Remove tags <link> e <script> que contenham o texto no href ou src."""
        for tag in tags:
            if tag.has_attr("href") and texto_para_remover in tag["href"]:
                tag.decompose()  # Remove a tag do documento
            elif tag.has_attr("src") and texto_para_remover in tag["src"]:
                tag.decompose()  # Remove a tag do documento

    def salvar_arquivo(filepath, soup):
        """Sobrescreve o arquivo HTML com as alterações."""
        with open(filepath, "w", encoding="utf-8") as file:
            file.write(str(soup))

    # Busca pastas que correspondem ao padrão
    pastas_relevantes = buscar_pastas_com_padrao(path, patternfolders)

    for pasta in pastas_relevantes:
        # Percorre todas as subpastas e arquivos HTML
        for root, _, files in os.walk(pasta):
            for file in files:
                if file.endswith(".html"):
                    filepath = os.path.join(root, file)
                    with open(filepath, "r", encoding="utf-8") as f:
                        soup = BeautifulSoup(f, "html.parser")
                    head = soup.head
                    if head:
                        tags = head.find_all(["link", "script"])
                        corrigir_links(tags, corrections)
                        remover_links_e_scripts(tags, rmhead)
                        salvar_arquivo(filepath, soup)


CORRECOESLINK = {
    "./": "/",           # Caminho relativo redundante
    "../": "/",          # Caminho para o diretório pai
    "././": "/",         # Caminho redundante para o mesmo diretório
    "//": "/",           # Caminho com barras duplas
    "../../": "/",       # Caminho para dois níveis acima
    "./../../": "/",     # Caminho redundante para dois níveis acima
    "////": "/",         # Caminho com múltiplas barras
    "./../": "/",        # Caminho redundante para o diretório pai
    "./././": "/",       # Caminho redundante para o mesmo diretório
    "../../../": "/",    # Caminho para três níveis acima
    "./../../../": "/",  # Caminho redundante para três níveis acima
    "index.html/": "index.html",  # Caminho incorreto com barra no final
    "/./": "/",          # Caminho redundante com barra inicial
    "/../": "/",         # Caminho redundante com barra inicial para o diretório pai
    "//./": "/",         # Caminho com barra dupla e redundância
    "//../": "/",        # Caminho com barra dupla e redundância para o diretório pai
    "///": "/",
    "///": "/",          # Caminho com três barras
    "////": "/",         # Caminho com quatro barras
    "/////": "/",        # Caminho com cinco barras
    "/././": "/",        # Caminho redundante com barras e pontos
    "/.././": "/",       # Caminho redundante para o diretório pai com barra inicial
    "././././": "/",     # Caminho redundante com múltiplos pontos
    "////./": "/",       # Caminho com múltiplas barras e ponto
    "////../": "/",      # Caminho com múltiplas barras e diretório pai
    "././.././": "/",    # Caminho redundante com mistura de pontos e diretório pai
    "////././": "/",     # Caminho com múltiplas barras e redundância
    "estatistica/ac/": "/ac/",
    "estatistica/sd/": "/sd/"
}
corrigirlinksinhead("./books", corrections=CORRECOESLINK,
                    rmhead="/delete/site_libs/", patternfolders=CAMINHOS["pattern_book"])

