# Automação-manual de section.avisos do site.
# Afeta toda página HTML que tiver section#globalribbon como filhos de um doby>div#globalheader >
# Serve apenas para alterar o conteúdo e a tag `a`.
import os
import json
from bs4 import BeautifulSoup


def find_and_update_index_files(root_dir, new_text, new_link, new_classes=None):
    for subdir, _, files in os.walk(root_dir):
        for file in files:
            if file == "index.html":
                file_path = os.path.join(subdir, file)
                with open(file_path, "r", encoding="utf-8") as f:
                    html_content = f.read()

                updated_html = update_globalribbon(
                    html_content, new_text, new_link, new_classes
                )
                if updated_html:
                    with open(file_path, "w", encoding="utf-8") as f:
                        f.write(updated_html)
                    print(f"Arquivo atualizado: {file_path}")

def update_globalribbon(html_content, new_text, new_link, new_classes=None):
    soup = BeautifulSoup(html_content, "html.parser")

    # Encontrar a div globalheader
    globalheader_div = soup.find("div", id="globalheader")
    if not globalheader_div:
        return None

    # Encontrar a seção globalribbon dentro de globalheader
    globalribbon_section = globalheader_div.find("section", id="globalribbon")
    if not globalribbon_section:
        return None

    # Atualizar o texto
    news_content = globalribbon_section.find("span", id="news-content")
    if news_content:
        news_content.string = new_text
        if new_classes:
            news_content["class"] = new_classes

    # Atualizar o link
    news_link = globalribbon_section.find("a")
    if news_link:
        news_link["href"] = new_link

    return str(soup)

def update_globalribbon_style(html_content, display_none=False):
    soup = BeautifulSoup(html_content, "html.parser")

    # Encontrar a div globalheader
    globalheader_div = soup.find("div", id="globalheader")
    if not globalheader_div:
        return None

    # Encontrar a seção globalribbon dentro de globalheader
    globalribbon_section = globalheader_div.find("section", id="globalribbon")
    if not globalribbon_section:
        return None

    # Adicionar ou remover o estilo inline
    if display_none:
        globalribbon_section["style"] = "display: none;"
    else:
        if "style" in globalribbon_section.attrs:
            del globalribbon_section["style"]

    return str(soup)

def find_and_update_index_files_style(root_dir, display_none=False):
    for subdir, _, files in os.walk(root_dir):
        for file in files:
            if file == "index.html":
                file_path = os.path.join(subdir, file)
                with open(file_path, "r", encoding="utf-8") as f:
                    html_content = f.read()

                updated_html = update_globalribbon_style(html_content, display_none)
                if updated_html:
                    with open(file_path, "w", encoding="utf-8") as f:
                        f.write(updated_html)
                    print(f"Arquivo atualizado: {file_path}")

def buscar_por_titulo(tipo="avisos", titulo=None):
    filepath = "c:/Users/cesar.oliveira/Documents/github/estatistica/backend/scripts/globalribbon/globalribbon.json"
    with open(filepath, "r", encoding="utf-8") as file:
        data = json.load(file)

    if tipo not in ["avisos", "eventos"]:
        print(f"Tipo '{tipo}' não encontrado no arquivo JSON.")
        return None

    for item in data[tipo]:
        if titulo and item["titulo"] == titulo:
            return item

    print(f"Título '{titulo}' não encontrado no tipo '{tipo}'.")
    return None

# Exemplo de uso
tipo = "avisos"
titulo = "Calendário Acadêmico 2025"

item_encontrado = buscar_por_titulo(titulo=titulo)

if item_encontrado:
    print(f"{tipo.capitalize()} encontrado:", item_encontrado)
else:
    print(f"{tipo.capitalize()} não encontrado.")

# Adicionar display: none
root_dir = "c:/Users/cesar.oliveira/Documents/github/estatistica"
display_none = True

find_and_update_index_files_style(root_dir, display_none=False)
