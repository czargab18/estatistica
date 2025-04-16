# ADICIONAR links de CSS e JavaScript em cada <head> dos html
import markdown
import os
import json
from pickle import TRUE
import re
from bs4 import BeautifulSoup

# Parametros
LINKS = [
    "<meta charset='utf-8' />",
    "<meta content='Estatística' name='topic' />",
    "<meta content='index,follow' name='robots' />",
    "<meta content='width=device-width, initial-scale=1.0' name='viewport' />",
    "<meta content=\"img-src 'self' https://www.estatistica.pro/; script-src 'self' https://www.estatistica.pro/ac/ https://www.estatistica.pro/sd/\" http-equiv='Content-Security-Policy' />",
    "<link href='/sd/images/favicons/estatistica.svg' rel='shortcut icon' type='image/x-icon' />",
    "<link href='/ac/globalpattern/1/pt_BR/styles/globalpattern.css' rel='stylesheet' />",
    "<link href='/ac/globalaside/1/pt_BR/styles/globalaside.css' rel='stylesheet' />",
    "<link href='/ac/globalnavbar/1/pt_BR/styles/globalnavbar.css' rel='stylesheet' />",
    "<link href='/ac/globalribbon/1/pt_BR/styles/globalribbon.css' rel='stylesheet' />",
    "<link href='/ac/globaltipografia/1/pt_BR/style/globaltipografia.css' rel='stylesheet' />",
    "<link href='/ac/globalmain/1/pt_BR/styles/globalmain.css' rel='stylesheet' />",
    "<link href='/ac/globalnoticias/1/pt_BR/style/globalnoticias.css' rel='stylesheet' />",
    "<link href='/ac/globalfooter/1/pt_BR/styles/globalfooter.css' rel='stylesheet' />",
    "<link href='/wss/fonts.css?families=SF+Pro,v3|SF+Pro+Icons,v3' media='all' rel='stylesheet' type='text/css' />",
    "<script defer='' src='/ac/globalnoticias/1/pt_BR/scripts/globalnoticias.js'></script>",
    "<script defer='' src='/ac/globalpattern/1/pt_BR/scripts/globalpattern.js'></script>",
    "<script defer='' src='/ac/globalfooter/1/pt_BR/scripts/globalfooter.js'></script>",
    "<script defer='' src='/utils/libs/js/navbar.js'></script>",
    "<link rel='stylesheet' href='/ac/books/custombooks.css'>",
    "<link rel='stylesheet' href='/ac/books/bootstrap/bootstrap.min.css'>",
    "<link rel='stylesheet' href='/ac/books/bootstrap/bootstrap-icons.css'>",
    "<link rel='stylesheet' href='/ac/books/quarto-html/quarto-syntax-highlighting.css'>",
    "<link rel='stylesheet' href='/ac/books/quarto-html/tippy.css'>",
    "<script src='/ac/books/bootstrap/bootstrap.min.js'></script>",
    "<script src='/ac/books/clipboard/clipboard.min.js'></script>",
    "<script src='/ac/books/quarto-html/anchor.min.js'></script>",
    "<script src='/ac/books/quarto-html/popper.min.js'></script>",
    "<script src='/ac/books/quarto-html/quarto.js'></script>",
    "<script src='/ac/books/quarto-html/tippy.umd.min.js'></script>",
    "<script src='/ac/books/quarto-nav/headroom.min.js'></script>",
    "<script src='/ac/books/quarto-nav/quarto-nav.js'></script>",
    "<script src='/ac/books/quarto-search/autocomplete.umd.js'></script>",
    "<script src='/ac/books/quarto-search/fuse.min.js'></script>",
    "<script src='/ac/books/quarto-search/quarto-search.js'></script>"
]

PATTERN_BOOKS_NAME = re.compile(r'^[A-Z]{3}\d{4}$')

def readjson(caminho: str = "./backend/data/books/books.json"):
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
    
def listabooks(path: str = "./books/docs/"):
    """
    Lista as pastas do tipo: '3 lestras e 4 numéros'
    Ignora pastas na raiz do repositório: /ac/ ou /wss/ .
    - return: Dicionário
        - formato: { "pastaPai": [ "path-arquivo1", "path-arquivo2" ] }
    """
    CAMINHOS_ARQUIVOS = {}
    PATTERN_BOOKS_NAME = re.compile(r'^[A-Z]{3}\d{4}$')
    for pasta in next(os.walk(path))[1]:
        if PATTERN_BOOKS_NAME.match(pasta):
            CAMINHO_PASTAS = os.path.join(path, pasta)
            CAMINHOS_ARQUIVOS[pasta] = []
            for subroot, subpastas, subarquivos in os.walk(CAMINHO_PASTAS):
                subpastas_filtradas = []
                for subpasta in subpastas:
                    if subpasta not in ['ac', 'wss', 'book', '.quarto', 'site_libs']:
                        subpastas_filtradas.append(subpasta)
                subpastas[:] = subpastas_filtradas

                for arquivo in subarquivos:
                    caminho_relativo = os.path.relpath(
                        os.path.join(subroot, arquivo), path)
                    caminho_relativo = caminho_relativo.replace("\\", "/")
                    caminho_completo = f"/books/{caminho_relativo}"
                    CAMINHOS_ARQUIVOS[pasta].append(caminho_completo)

    if not os.makedirs('./data/books/', exist_ok=True): 
        with open('./backend/data/books/books.json', 'w', encoding='utf-8') as file:
            json.dump(CAMINHOS_ARQUIVOS, file, ensure_ascii=False, indent=4)

    return CAMINHOS_ARQUIVOS

def corsearchjson(books: bool = True, path: str = "./backend/data/books/books.json"):
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
                        print(f"Arquivo {arquivo} já existe em {destino_completo}.")

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


def corrlinksheadbooks(listabooks: dict, base_path: str = "./books", ignore: list = None, rm:bool=True, remove: list = ["delete/site_libs"]):
    """
    Corrige os links no head dos arquivos HTML listados em listabooks,
    substituindo './' por '/'.

    Args:
        listabooks (dict): Dicionário com os livros e seus respectivos arquivos HTML.
        base_path (str): Caminho base onde os arquivos estão localizados.
        ignore (list): Lista de partes do caminho ou links a serem ignorados. Se None, corrige todos os links.
    """
    if ignore is None:
        ignore = []  # Define uma lista vazia se nenhum padrão for fornecido

    for book, files in listabooks.items():
        for filepath in files:
            # Construir caminho absoluto e normalizar as barras
            relative_path = filepath.lstrip('/')  # Remove a barra inicial, se existir
            absolute_path = os.path.normpath(os.path.join(base_path, relative_path.replace("books/", "")))
            if absolute_path.endswith(".html"):
                try:
                    with open(absolute_path, 'r', encoding='utf-8') as f:
                        soup = BeautifulSoup(f, 'html.parser')
                    
                    # Corrigir links no <head>
                    head = soup.head
                    if head:
                        for tag in head.find_all(['link', 'script']):
                            # Verificar e corrigir o atributo 'href'
                            if tag.has_attr('href') and not any(ignored in tag['href'] for ignored in ignore):
                                tag['href'] = tag['href'].replace('./', '/')
                            # Verificar e corrigir o atributo 'src'
                            if tag.has_attr('src') and not any(ignored in tag['src'] for ignored in ignore):
                                tag['src'] = tag['src'].replace('./', '/')
                    
                    # Sobrescrever o arquivo com o conteúdo corrigido
                    with open(absolute_path, 'w', encoding='utf-8') as f:
                        f.write(str(soup))
                except FileNotFoundError:
                    print(f"Arquivo não encontrado: {absolute_path}")
                except Exception as e:
                    print(f"Erro ao processar {absolute_path}: {e}")

if __name__ == '__main__':
    # A função listabooks já está definida neste arquivo
    books = listabooks(path="./books")
    corrlinksheadbooks(books, base_path="./books")
    print("Fim!!!")
