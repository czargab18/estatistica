from bs4.dammit import html_meta
import os
import re
import json
from bs4 import BeautifulSoup
from bs4.element import Tag
from backend.variaveis import CAMINHO_BASE, CAMINHOS, CORRECOESLINK

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


def corrigirlinksinhead(
    path: str,
    corlink: dict,
    rmhead: str,
    patternfolders: str,
    tipoarquivo: str = ".html",
    cordefer: bool = False,
):
    """
    Inclui ou corrige links no <head> de arquivos HTML encontrados no diretório especificado.

    A função processa todos os arquivos HTML no diretório base e seus subdiretórios, realizando as seguintes operações:
    1. Adiciona links especificados ao elemento <head>.
    2. Corrige links existentes com base em padrões fornecidos.
    3. Remove links ou scripts desnecessários que contenham um texto específico no atributo `href` ou `src`.

    :param path: Caminho do diretório base onde os arquivos HTML estão localizados.
    :param corlink: Dicionário com padrões antigos como chave e substituições como valor, usado para corrigir links existentes.
    :param rmhead: Texto que, se encontrado no atributo `href` ou `src`, indica que a tag <link> ou <script> deve ser removida.
    :param patternfolders: Padrão para identificar pastas relevantes dentro do diretório base.
    :param tipoarquivo: Tipo de arquivo a ser processado (padrão: ".html").
    :return: Nenhum retorno explícito, mas os arquivos HTML são atualizados diretamente no disco.

    Detalhes adicionais:
    - A função busca pastas que correspondem ao padrão especificado em `patternfolders`.
    - Links e scripts no <head> são corrigidos ou removidos com base nos parâmetros fornecidos.
    - O conteúdo atualizado é salvo diretamente nos arquivos HTML processados.
    """

    def buscarpasta(base_path, pattern):
        """Busca pastas que correspondem ao padrão especificado."""
        return [
            os.path.join(base_path, pasta)
            for pasta in os.listdir(base_path)
            if os.path.isdir(os.path.join(base_path, pasta))
            and re.match(pattern, pasta)
        ]

    def corrigirlinks(tags, corlink):
        """Corrige os atributos href ou src das tags encontradas."""
        for tag in tags:
            if tag.has_attr("href"):
                for old, new in corlink.items():
                    if old in tag["href"]:
                        tag["href"] = tag["href"].replace(old, new)
            if tag.has_attr("src"):
                for old, new in corlink.items():
                    if old in tag["src"]:
                        tag["src"] = tag["src"].replace(old, new)

    # def cordefer(tags):
    # CORRIGIR NA FORÇA
    # DETECTAR AS TAGS SCRIPTS E APENAS SUBSTITUIR O ATRIBUTO POR 'DEFER'
    
    #     """Corrige scripts com: 'defer=""' => 'defer'."""
    #     for tag in tags:
    #         # Ensure tag is not None and is a valid Tag
    #         if tag and isinstance(tag, Tag):
    #             if tag.has_attr("defer"):
    #                 # Remove o valor do atributo, deixando apenas 'defer'
    #                 tag["defer"] = None

    def corlinkrel(soup: BeautifulSoup, nome_livro: str):
        """
        Corrige os links das páginas de links que tenham atributo rel="next" ou rel="prev".

        Args:
            soup (BeautifulSoup): Objeto BeautifulSoup representando o conteúdo HTML.
            nome_livro (str): Nome do livro para ajustar os caminhos no atributo href.

        Returns:
            None: As alterações são feitas diretamente no objeto `soup`.
        """
        # Corrigir links com rel="next" ou rel="prev"
        for tag in soup.find_all("link", rel=["next", "prev"]):
            href_atual = tag.get("href")
            if href_atual and not href_atual.startswith("/books/"):
                # Atualizar o atributo href
                tag["href"] = f"/books/{nome_livro}{href_atual}"

    def removerhead(tags, texto_para_remover):
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
    pastas_relevantes = buscarpasta(path, patternfolders)

    for pasta in pastas_relevantes:
        nome_livro = os.path.basename(pasta)  # Extrair o nome do livro
        for root, _, files in os.walk(pasta):
            for file in files:
                if file.endswith(".html"):
                    filepath = os.path.join(root, file)
                    with open(filepath, "r", encoding="utf-8") as f:
                        # Processar o HTML com BeautifulSoup
                        soup = BeautifulSoup(f, "html.parser")

                    # Chamar corlinkrel para corrigir os links
                    # Passar o objeto soup e o nome do livro
                    corlinkrel(soup, nome_livro)

                    # Aplicar as outras correções e salvar no final
                    head = soup.head
                    if head:
                        tags = head.find_all(["link", "script"])
                        corrigirlinks(tags, corlink)  # Corrigir os links
                        # Remover links desnecessários
                        removerhead(tags, rmhead)
                        # cordefer(tags)  # Ajustar scripts com defer

                    # Salvar o HTML final com todas as alterações
                    salvar_arquivo(filepath, soup)


def includeinbody(
    pathbooks: str = "./books/",
    tipoarquivo: str = ".html",
    substituirtag: bool = True,
    globalheader: bool = True,
    globalheadertagsid: list = [
        "globalnavbar", "globalaside", "section-ribbon"],
    include_file: dict = {
        "globalnavbar": "./ac/components/1/pt_BR/navbar.html",
        "globalfooter": "./ac/components/1/pt_BR/footer.html",
    },
):
    """
    Adiciona ou substitui o conteúdo de componentes nos arquivos HTML dos books.

    :param pathbooks: Caminho base onde os arquivos HTML estão localizados.
    :param tipoarquivo: Tipo de arquivo a ser processado (por padrão, ".html").
    :param include_file: Dicionário com caminhos dos arquivos contendo o conteúdo de cada componente.
    :param substituirtag: Define se as tags existentes devem ser substituídas ou apenas alteradas.
    :param globalheader: Define se as tags permitidas devem ser agrupadas em uma <div id="globalheader"></div>.
    :param globalheadertagsid: Lista de IDs de tags permitidas para inclusão no globalheader.
    :return: Dicionário com os arquivos processados e seu status.
    """
    arquivos_processados = {}
    # Ler o conteúdo dos arquivos de componentes
    componentes = {}
    for tag_id, file_path in include_file.items():
        try:
            with open(file_path, "r", encoding="utf-8") as f:
                componentes[tag_id] = f.read()
        except Exception as e:
            return {"Erro": f"Não foi possível ler o arquivo {file_path}: {e}"}

    for root, _, files in os.walk(pathbooks):
        for file in files:
            if file.endswith(tipoarquivo):
                filepath = os.path.join(root, file)
                try:
                    with open(filepath, "r", encoding="utf-8") as f:
                        soup = BeautifulSoup(f, "html.parser")

                    body = soup.find("body")
                    if body:
                        globalheader_div = None
                        if globalheader:
                            # Criar ou localizar a tag <div id="globalheader">
                            globalheader_div = soup.find(
                                "div", id="globalheader")
                            if not globalheader_div:
                                globalheader_div = soup.new_tag(
                                    "div", id="globalheader")
                                body.insert(0, globalheader_div)

                        for tag_id, content in componentes.items():
                            if globalheader and tag_id in globalheadertagsid:
                                # Adicionar ao globalheader se permitido
                                existing_tag = globalheader_div.find(id=tag_id)
                                if existing_tag:
                                    if substituirtag:
                                        existing_tag.replace_with(
                                            BeautifulSoup(content, "html.parser"))
                                    else:
                                        existing_tag.clear()
                                        existing_tag.append(
                                            BeautifulSoup(content, "html.parser"))
                                else:
                                    globalheader_div.append(
                                        BeautifulSoup(content, "html.parser"))
                            else:
                                # Adicionar diretamente ao body
                                existing_tag = soup.find(id=tag_id)
                                if existing_tag:
                                    if substituirtag:
                                        existing_tag.replace_with(
                                            BeautifulSoup(content, "html.parser"))
                                    else:
                                        existing_tag.clear()
                                        existing_tag.append(
                                            BeautifulSoup(content, "html.parser"))
                                else:
                                    if tag_id == "globalnavbar":
                                        body.insert(0, BeautifulSoup(
                                            content, "html.parser"))
                                    elif tag_id == "globalfooter":
                                        body.append(BeautifulSoup(
                                            content, "html.parser"))

                    # Salvar as alterações no arquivo
                    with open(filepath, "w", encoding="utf-8") as f:
                        f.write(str(soup))

                    arquivos_processados[filepath] = "Sucesso"
                except Exception as e:
                    arquivos_processados[filepath] = f"Erro: {e}"

    return arquivos_processados


# if __name__ == "__main__":
#     includeinbody(
#         pathbooks="./books",
#         tipoarquivo=".html",
#         substituirtag=True,
#         globalheader=True,
#         globalheadertagsid=["globalnavbar", "globalaside", "section-ribbon"],
#         include_file={
#             "head": "./ac/components/1/pt_BR/books/head.html",
#             "globalnavbar": "./ac/components/1/pt_BR/navbar.html",
#             "globalfooter": "./ac/components/1/pt_BR/footer.html",
#         },
#     )
#     print("FIM da execução de: includeinbody()")

#     #Chama a função para corrigir os arquivos HTML na pasta ./books
#     corrigirlinksinhead(
#         path="./books",
#         corlink=CORRECOESLINK,
#         rmhead="delete/site_libs",
#         patternfolders=CAMINHOS["pattern_book"],
#         tipoarquivo=".html")
#     print("FIM da execução de: corrigirlinksinhead()")
