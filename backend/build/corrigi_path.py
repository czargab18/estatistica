"""
  * Automação para correção de links de caminho nos books
"""

import os
import re
import json
from bs4 import BeautifulSoup

def foldersBooks(path="./"):
    """
    * Lista as pastas do tipo: '3 letras e 4 números'
    * Ignora pastas na raiz do repositório: /ac/ ou /wss/ .
    * - return: Dicionário
    *     - formato: { "pastaPai": [ "path-arquivo1", "path-arquivo2" ] }
    """
    padrao_pasta = re.compile(r"^[A-Z]{3}\d{4}$")
    caminhos_arquivos = {}
    for pasta in next(os.walk(path))[1]:
        if padrao_pasta.match(pasta):
            caminho_pasta = os.path.join(path, pasta)
            caminhos_arquivos[pasta] = []
            for subroot, subpastas, subarquivos in os.walk(caminho_pasta):
                subpastas_filtradas = []
                for subpasta in subpastas:
                    if subpasta not in ["ac", "wss", "book", ".quarto"]:
                        subpastas_filtradas.append(subpasta)
                subpastas[:] = subpastas_filtradas
                for arquivo in subarquivos:
                    caminho_relativo = os.path.relpath(
                        os.path.join(subroot, arquivo), path
                    )
                    caminho_relativo = caminho_relativo.replace("\\", "/")
                    caminho_completo = f"/books/{caminho_relativo}"
                    caminhos_arquivos[pasta].append(caminho_completo)
    os.makedirs("automacao/dados/", exist_ok=True)
    with open("./automacao/dados/books.json", "w", encoding="utf-8") as f:
        json.dump(caminhos_arquivos, f, ensure_ascii=False, indent=4)
    return caminhos_arquivos

def listaBooks(path="./automacao/dados/books.json", fun = True):
    """
    * Importa a lista dos nomes dos Books em: "./automacao/dados/books.json"
    """
    if fun is True:
        if not os.path.exists(path):
            foldersBooks()
        with open(path, 'r', encoding='utf-8') as file:
            book = json.load(file).keys()
        return list(book)
    else:
        with open(path, 'r', encoding='utf-8') as file:
            book = json.load(file).keys()
        return list(book)


def corrigirSearchJson(fun=False, books=None):
    """
    Corrige os caminhos duplicados no arquivo SEARCH.JSON
    """
    if fun is True:
        listabooks = listaBooks()
    else:
        listabooks = books
        for book in listabooks:
            path = f'./{book}/search.json'
            if os.path.exists(path):
                with open(path, 'r', encoding='utf-8') as file:
                    data = json.load(file)
                padrao = re.compile(rf'/books/{book}/')
                for item in data:
                    for key in ['objectID', 'href']:
                        if key in item:
                            item[key] = re.sub(padrao, './', item[key])
                with open(path, 'w', encoding='utf-8') as file:
                    json.dump(data, file, indent=4, ensure_ascii=False)
            else:
                print(f"Arquivo não encontrado: {path}")

def adicionarBooksIndex(index="./index.html"):
    """
    Adiciona o Path de cada Book Online criado à lista de Books em index.html
    """
    books = listaBooks()
    with open(index, "r", encoding="utf-8") as file:
        conteudo = file.read()
    soup = BeautifulSoup(conteudo, 'html.parser')
    section = soup.find('section', class_='lista-books')
    if section:
        existing_links = section.find_all('a')
        for link in existing_links:
            book_name = link.string
            if book_name not in books:
                link.decompose()
        for book in books:
            book_path = f"/books/{book}/index.html"
            if not section.find('a', href=book_path):
                new_link = soup.new_tag('a', href=book_path)
                new_link.string = book
                section.append(new_link)
        with open(index, "w", encoding="utf-8") as file:
            file.write(str(soup))

def correcao(diretorio="./", fun=True):
    """
    * Correcao de padrões de 'paths'
    """
    books = listaBooks()
    # Corrige os caminhos nos arquivos
    for pasta in books:
        caminho_arquivos = f"./{pasta}/"
        for root, _, arquivos in os.walk(caminho_arquivos):
            for arquivo in arquivos:
                absoluto = os.path.join(root, arquivo)
                absoluto = os.path.abspath(absoluto)
                if os.path.exists(absoluto):
                    with open(absoluto, "r", encoding="utf-8") as file:
                        conteudo = file.read()
                    tratar_titulos_books = [
                        (r'<a href="\./">', f'<a href="/books/{pasta}/">'),
                        (r'<a href="\.\./">', f'<a href="/books/{pasta}/">'),
                        (r'<a href="\.\./\.\./">', f'<a href="/books/{pasta}/">'),
                    ]
                    for padrao, padrao_novo in tratar_titulos_books:
                        if re.search(padrao, conteudo):
                            conteudo = re.sub(padrao, padrao_novo, conteudo)
                    estilos = [
                        (r'href="/ac/', 'href="/books/ac/'),
                        (r'src="/ac/', 'src="/books/ac/'),
                    ]
                    for padrao, padrao_novo in estilos:
                        if re.search(padrao, conteudo):
                            conteudo = re.sub(padrao, padrao_novo, conteudo)
                    with open(absoluto, "w", encoding="utf-8") as file:
                        file.write(conteudo)
                    tratar = [
                        (r'href="//', 'href="/'),
                        (r'href="\./', 'href="/'),
                        (r'href="\./\.\./', 'href="/'),
                        (r'href="\.\.\.\./', 'href="/'),
                        (r'href="\.\./', 'href="/'),
                        (r'href="\.\./\.\./', 'href="/'),
                        (r'href="/\.\./', 'href="/'),
                        (r'href="/\.\./\.\./', 'href="/'),
                        (r'src="//', 'src="/'),
                        (r'src="\./', 'src="/'),
                        (r'src="\./\.\./', 'src="/'),
                        (r'src="\.\./', 'src="/'),
                        (r'src="\.\./\.\./', 'src="/'),
                        (r'src="/\.\./', 'src="/'),
                        (r'src="/\.\./\.\./', 'src="/'),
                        (r'href="[^"]*//+', 'href="/'),
                        (r'src="[^"]*//+', 'src="/'),
                    ]
                    for padrao, padrao_novo in tratar:
                        if re.search(padrao, conteudo):
                            conteudo = re.sub(padrao, padrao_novo, conteudo)
                    with open(absoluto, "w", encoding="utf-8") as file:
                        file.write(conteudo)

                        estilos = [
                            (r'href="/ac/', 'href="/books/ac/'),
                            (r'src="/ac/', 'src="/books/ac/')
                        ]
                    for padrao, padrao_novo in estilos:
                        if re.search(padrao, conteudo):
                            conteudo = re.sub(padrao, padrao_novo, conteudo)
                    with open(absoluto, "w", encoding="utf-8") as file:
                        file.write(conteudo)
                    for book in books:
                        corrigirSearchJson(books=[book])
                    
                else:
                    print(f"Arquivo não encontrado: {absoluto}")
    return diretorio, fun, books


###### => RUN FUNCTIONS <=######
# correcao()
print(corrigirSearchJson(fun=False, books="TAS0000"))
