# ADICIONAR links de CSS e JavaScript em cada <head> dos. html
import markdown
import os
import sys
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


def readjson(caminho: str):
    with open(caminho, 'r', encoding='utf-8') as file:
        return json.load(file)


def readmeqmd(
    caminho: str = "./newshub/build/conteudo/",
    extensoes: list = ['.qmd', '.bib'],
    buscar: bool = True
):
    """
    Processa arquivos em um diretório ou um único arquivo e retorna um JSON com o conteúdo.

    :param caminho: Caminho do diretório ou arquivo.
    :param extensoes: Lista de extensões de arquivo a serem procuradas (usado apenas se buscar=True).
    :param buscar: Booleano que indica se deve buscar arquivos no diretório ou processar um único arquivo.
    :return: JSON com o nome do arquivo como chave e o conteúdo como valor.
    """
    resultado = {}

    if buscar:
        arquivos_encontrados = []
        for root, _, files in os.walk(caminho):
            for file in files:
                if any(file.endswith(ext) for ext in extensoes):
                    arquivos_encontrados.append(os.path.join(root, file))
    else:
        # Trata como um único arquivo.
        arquivos_encontrados = [caminho]

    for arquivo in arquivos_encontrados:
        try:
            with open(arquivo, 'r', encoding='utf-8') as file:
                conteudo = file.read()
            conteudo_html = markdown.markdown(
                conteudo, extensions=['extra', 'tables', 'toc'])
            resultado[os.path.basename(arquivo)] = conteudo_html
        except Exception as e:
            resultado[os.path.basename(
                arquivo)] = f"Erro ao processar o arquivo: {e}"

    return json.dumps(resultado, ensure_ascii=False, indent=4)


def listabooks(path: str = "./books/"):
    """
    Lista as pastas do tipo: '3 letras e 4 números'
    Ignora pastas na raiz do repositório: /ac/ ou /wss/.
    - return: Dicionário
        - formato: { "pastaPai": [ "path-arquivo1", "path-arquivo2" ] }
    """
    if not os.path.exists(path):
        print(f"Erro: O diretório '{path}' não existe.")
        return {}

    if not os.path.isdir(path):
        print(f"Erro: O caminho '{path}' não é um diretório.")
        return {}

    CAMINHOS_ARQUIVOS = {}
    PATTERN_BOOKS_NAME = re.compile(r'^[A-Z]{3}\d{4}$')
    try:
        for pasta in next(os.walk(path))[1]:
            if PATTERN_BOOKS_NAME.match(pasta):
                CAMINHO_PASTAS = os.path.join(path, pasta)
                CAMINHOS_ARQUIVOS[pasta] = []
                for subroot, subpastas, subarquivos in os.walk(CAMINHO_PASTAS):
                    subpastas_filtradas = [
                        subpasta for subpasta in subpastas if subpasta not in ['ac', 'wss', 'book', '.quarto', 'site_libs']
                    ]
                    subpastas[:] = subpastas_filtradas

                    for arquivo in subarquivos:
                        caminho_relativo = os.path.relpath(
                            os.path.join(subroot, arquivo), path
                        ).replace("\\", "/")
                        caminho_completo = f"/books/{caminho_relativo}"
                        CAMINHOS_ARQUIVOS[pasta].append(caminho_completo)
    except StopIteration:
        print(
            f"Erro: O diretório '{path}' está vazio ou não contém subdiretórios.")
        return {}

    # Salvar o resultado em um arquivo JSON
    os.makedirs('./data/books/', exist_ok=True)
    with open('./backend/data/books/books.json', 'w', encoding='utf-8') as file:
        json.dump(CAMINHOS_ARQUIVOS, file, ensure_ascii=False, indent=4)

    return CAMINHOS_ARQUIVOS


def corsearchjson(path: str, books: bool = True):
    """
    Corrige os caminhos duplicados no arquivo SEARCH.JSON
    """
    if not os.path.exists(path):
        listabooks = listabooks()
    else:
        listabooks = readjson(path)

    # scripts para mover subpastas de books/docs/ para books/
    destino = "./books/"
    origem = "./books/docs/"
    if not os.path.exists(destino):
        os.makedirs(destino)

    for subpasta in next(os.walk(origem))[1]:
        origem_completa = os.path.join(origem, subpasta)
        destino_completo = os.path.join(destino, subpasta)

        if not os.path.exists(destino_completo):
            os.rename(origem_completa, destino_completo)
        else:
            for root, _, arquivos in os.walk(origem_completa):
                for arquivo in arquivos:
                    origem_arquivo = os.path.join(root, arquivo)
                    destino_arquivo = os.path.join(destino_completo, arquivo)
                    if not os.path.exists(destino_arquivo):
                        os.rename(origem_arquivo, destino_arquivo)
                    else:
                        print(
                            f"Arquivo {arquivo} já existe em {destino_completo}.")

    # scripts para atualizar o searchJSON dos books para /books/{book}/...
    for book, arquivos in listabooks.items():
        search_json_path = f"./books/{book}/search.json"
        if os.path.exists(search_json_path):
            search_data = readjson(search_json_path)
            for item in search_data:
                if "objectID" in item:
                    item["objectID"] = f"/books/{book}/{item['objectID']}"
            with open(search_json_path, 'w', encoding='utf-8') as file:
                json.dump(search_data, file, ensure_ascii=False, indent=4)
    with open(path, 'w', encoding='utf-8') as file:
        json.dump(listabooks, file, ensure_ascii=False, indent=4)

    return listabooks


def corpathlinksearchjson(listabooks: dict = readjson('./backend/data/books/books.json')):
    """
    Corrige Links do ./BOOKS/{books}/SEARCH.JSON
    :param listabooks: dict com os livros
    :return: None
    """
    def exportjson(data, filepath):
        """
        Exporta dados para um arquivo JSON.
        :param data: Dados a serem salvos (normalmente um dicionário ou lista).
        :param filepath: Caminho do arquivo onde os dados serão salvos.
        """
        with open(filepath, 'w', encoding='utf-8') as json_file:
            json.dump(data, json_file, ensure_ascii=False, indent=4)
        return True
    for book in listabooks:
        searchjsonbook = readjson(os.path.join(f"./books/{book}/search.json"))
        for item in searchjsonbook:
            object_id = item.get("objectID")
            href = item.get("href")
            if object_id and not object_id.startswith(f"/teste/books/{book}/"):
                item["objectID"] = f"/teste/books/{book}/{object_id}"
            if href and not href.startswith(f"/teste/books/{book}/"):
                item["href"] = f"/teste/books/{book}/{href}"
        exportjson(searchjsonbook, os.path.join(f"./books/{book}/search.json"))
    return "Atualização concluída."


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
        globalheader = include_content.split('globalheader = """')[
            1].split('"""')[0]
        globalfooter = include_content.split('globalfooter = """')[
            1].split('"""')[0]
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
                            body.insert(0, BeautifulSoup(
                                globalheader, 'html.parser'))

                    # Verificar se já existe o globalfooter
                    if not soup.find('footer', id='globalfooter'):
                        body = soup.find('body')
                        if body:
                            body.append(BeautifulSoup(
                                globalfooter, 'html.parser'))

                    # Salvar as alterações no arquivo
                    with open(filepath, 'w', encoding='utf-8') as f:
                        f.write(str(soup))

                    arquivos_processados[filepath] = "Sucesso"
                except Exception as e:
                    arquivos_processados[filepath] = f"Erro: {e}"

    return arquivos_processados


if __name__ == '__main__':

    # Adiciona o diretório base ao sys.path
    base_path = os.path.abspath(os.path.join(os.path.dirname(__file__), "../../../"))
    sys.path.append(base_path)

    caminho_base = os.path.join(base_path, "books")
    print(caminho_base)
    books = listabooks(path=caminho_base)
    corrlinksheadbooks(books, base_path=caminho_base)
    includeinbody()
    print("-"*13, "Links corrigidos com sucesso!", "-"*13, sep=" ")
