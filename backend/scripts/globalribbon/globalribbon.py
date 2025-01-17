# Automação-manual de section.avisos do site.
# Afeta toda página HTML que tiver section#globalribbon como filhos de um doby>div#globalheader >
# Serve apenas para alterar o conteúdo e a tag `a`.
import os
import json
from bs4 import BeautifulSoup


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


def buscar_aviso_por_titulo_ou_id(titulo=None, aviso_id=None):
    filepath = "c:/Users/cesar.oliveira/Documents/github/estatistica/backend/scripts/globalribbon/globalribbon.json"
    with open(filepath, "r", encoding="utf-8") as file:
        data = json.load(file)

    for aviso in data["avisos"]:
        if (titulo and aviso["titulo"] == titulo) or (
            aviso_id and aviso["id"] == aviso_id
        ):
            return aviso
    return None


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


# Exemplo de uso
root_dir = "c:/Users/cesar.oliveira/Documents/github/estatistica"
titulo = "Calendário Acadêmico 2025"
aviso_id = 1

aviso_encontrado = buscar_aviso_por_titulo_ou_id(titulo=titulo)
if not aviso_encontrado:
    aviso_encontrado = buscar_aviso_por_titulo_ou_id(aviso_id=aviso_id)

if aviso_encontrado:
    new_text = aviso_encontrado["conteudo"]
    new_link = aviso_encontrado["link"]
    new_classes = aviso_encontrado["classes"]
    find_and_update_index_files(root_dir, new_text, new_link, new_classes)
else:
    print("Aviso não encontrado.")
