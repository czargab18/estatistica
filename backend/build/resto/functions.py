# ADICIONAR links de CSS e JavaScript em cada <head> dos. html
import markdown
import os
import json
from pickle import TRUE
import re
from bs4 import BeautifulSoup

caminhos = [
    re.compile(r'^[A-Z]{3}\d{4}$'),  # PATTERN_BOOKS_NAME
    os.path.normpath("/backend/data/books/books.json"),  # PATH_BOOKS_JSON
    # Caminho para readmeqmd
    os.path.normpath("./newshub/build/conteudo/"),
    os.path.normpath("./books/"),  # Caminho base para listabooks
    os.path.normpath("./data/books/"),  # Caminho para salvar JSON
    os.path.normpath("./books/docs/"),  # Origem para corsearchjson
    os.path.normpath("./books/"),  # Destino para corsearchjson
    # Caminho para corpathlinksearchjson
    os.path.normpath("./backend/data/books/books.json"),
    # Caminho para includeinbody
    os.path.normpath("./books/build/include/include-in-body"),
]


def includeinhead(linkstoinclude, pathbooks: str = "./books/", tipoarquivo: str = ".html"):
    """
    Inclui os links especificados no <head> de arquivos HTML encontrados no diretório especificado.

    :param pathbooks: Caminho base onde os arquivos HTML estão localizados.
    :param tipoarquivo: Tipo de arquivo a ser processado (por padrão, ".html").
    :param linkstoinclude: Lista de links a serem incluídos no <head>.
    :return: Dicionário com os arquivos processados e seu status.
    """
    arquivos_processados = {}

    for root, _, files in os.walk(pathbooks):
        for file in files:
            if file.endswith(tipoarquivo):
                caminho_arquivo = os.path.join(root, file)
                try:
                    with open(caminho_arquivo, 'r', encoding='utf-8') as f:
                        conteudo = f.read()

                    # Verifica se o <head> já contém os links
                    if any(link in conteudo for link in linkstoinclude):
                        arquivos_processados[caminho_arquivo] = "Links já incluídos"
                        continue

                    # Insere os links no <head>
                    if "<head>" in conteudo:
                        conteudo = conteudo.replace(
                            "<head>", f"<head>\n{''.join(linkstoinclude)}\n"
                        )
                    else:
                        arquivos_processados[caminho_arquivo] = "Tag <head> não encontrada"
                        continue

                    # Salva o arquivo atualizado
                    with open(caminho_arquivo, 'w', encoding='utf-8') as f:
                        f.write(conteudo)

                    arquivos_processados[caminho_arquivo] = "Links incluídos com sucesso"
                except Exception as e:
                    arquivos_processados[caminho_arquivo] = f"Erro: {e}"

    return arquivos_processados


def corrlinksheadbooks(listabooks: dict, base_path: str = "./books", ignore: list = None, rm: bool = True, remove: list = ["delete/site_libs"]):
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
            relative_path = filepath.lstrip('/')
            absolute_path = os.path.normpath(os.path.join(
                base_path, relative_path.replace("books/", "")))
            
            # Log para verificar o caminho do arquivo
            # print(f"Processando arquivo: {absolute_path}")
            
            if absolute_path.endswith(".html"):
                try:
                    with open(absolute_path, 'r', encoding='utf-8') as f:
                        soup = BeautifulSoup(f, 'html.parser')

                    # Corrigir links no <head>
                    head = soup.head
                    if head:
                        for tag in head.find_all(['link', 'script']):
                            # Log para verificar as tags encontradas
                            # print(f"Tag encontrada: {tag}")

                            # Remover tags que contenham padrões na lista remove
                            if rm and (tag.has_attr('href') and any(pattern in tag['href'] for pattern in remove) or
                                       tag.has_attr('src') and any(pattern in tag['src'] for pattern in remove)):
                                # print(f"Removendo tag: {tag}")
                                tag.decompose()
                                continue

                            # Verificar e corrigir o atributo 'href'
                            if tag.has_attr('href') and tag['href'].startswith('./') and not any(ignored in tag['href'] for ignored in ignore):
                                original_href = tag['href']
                                tag['href'] = tag['href'].replace('./', '/')
                                # print(f"Corrigido href: {original_href} -> {tag['href']}")

                            # Verificar e corrigir o atributo 'src'
                            if tag.has_attr('src') and tag['src'].startswith('./') and not any(ignored in tag['src'] for ignored in ignore):
                                original_src = tag['src']
                                tag['src'] = tag['src'].replace('./', '/')
                                # print(f"Corrigido src: {original_src} -> {tag['src']}")

                    # Sobrescrever o arquivo com o conteúdo corrigido
                    with open(absolute_path, 'w', encoding='utf-8') as f:
                        f.write(str(soup))
                        # print(f"Arquivo salvo: {absolute_path}")
                except FileNotFoundError:
                    print(f"Arquivo não encontrado: {absolute_path}")
                except Exception as e:
                    print(f"Erro ao processar {absolute_path}: {e}")


def includeinbody(pathbooks: str = "./books/", tipoarquivo: str = ".html", include_file: str = "./books/build/include/include-in-body"):
    """
    Adiciona o conteúdo do globalheader e globalfooter nos arquivos HTML dos books.

    :param pathbooks: Caminho base onde os arquivos HTML estão localizados.
    :param tipoarquivo: Tipo de arquivo a ser processado (por padrão, ".html").
    :param include_file: Caminho do arquivo contendo os conteúdos de globalheader e globalfooter.
    :return: Dicionário com os arquivos processados e seu status.
    """
    arquivos_processados = {}

    # Ler o conteúdo do arquivo include-in-body
    try:
        with open(include_file, 'r', encoding='utf-8') as f:
            include_content = f.read()
        globalheader = include_content.split('globalheader = """')[1].split('"""')[0]
        globalfooter = include_content.split('globalfooter = """')[1].split('"""')[0]
    except Exception as e:
        return {"Erro": f"Não foi possível ler o arquivo include-in-body: {e}"}

    for root, _, files in os.walk(pathbooks):
        for file in files:
            if file.endswith(tipoarquivo):
                filepath = os.path.join(root, file)
                try:
                    with open(filepath, 'r', encoding='utf-8') as f:
                        soup = BeautifulSoup(f, 'html.parser')

                    # Verificar se já existe o globalheader
                    if not soup.find('div', id='globalheader'):
                        body = soup.find('body')
                        if body:
                            body.insert(0, BeautifulSoup(globalheader, 'html.parser'))

                    # Verificar se já existe o globalfooter
                    if not soup.find('footer', id='globalfooter'):
                        body = soup.find('body')
                        if body:
                            body.append(BeautifulSoup(globalfooter, 'html.parser'))

                    # Salvar as alterações no arquivo
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(str(soup))

                    arquivos_processados[filepath] = "Sucesso"
                except Exception as e:
                    arquivos_processados[filepath] = f"Erro: {e}"

    return arquivos_processados

if __name__ == '__main__':
    books = listabooks(path="./books")
    corrlinksheadbooks(books, base_path="./books")
    includeinbody()
    print("-"*13, "Links corrigidos com sucesso!", "-"*13,sep=" ")
