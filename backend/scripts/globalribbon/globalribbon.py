# Automação-manual de section.avisos do site.
# Afeta toda página HTML que tiver section#globalribbon como filhos de um doby>div#globalheader >
# Serve apenas para alterar o conteúdo e a tag `a`.
from bs4 import BeautifulSoup
import json


def update_globalribbon(html_content, new_text, new_link, new_classes=None):
    soup = BeautifulSoup(html_content, "html.parser")

    # Encontrar a div globalheader
    globalheader_div = soup.find("div", id="globalheader")
    if not globalheader_div:
        print("Div #globalheader não encontrada.")
        return html_content

    # Encontrar a seção globalribbon dentro de globalheader
    globalribbon_section = globalheader_div.find("section", id="globalribbon")
    if not globalribbon_section:
        print("Seção #globalribbon não encontrada dentro de #globalheader.")
        return html_content

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
    filepath = "/c:/Users/cesar.oliveira/Documents/github/estatistica/backend/scripts/globalribbon/ribbon-avisos.json"
    with open(filepath, 'r', encoding='utf-8') as file:
        data = json.load(file)

    for aviso in data['avisos']:
        if (titulo and aviso['titulo'] == titulo) or (aviso_id and aviso['id'] == aviso_id):
            return aviso
    return None


# Exemplo de uso
titulo = "Calendário Acadêmico 2025"
aviso_id = 1

aviso_encontrado = buscar_aviso_por_titulo_ou_id(titulo=titulo)
if not aviso_encontrado:
    aviso_encontrado = buscar_aviso_por_titulo_ou_id(aviso_id=aviso_id)

if aviso_encontrado:
    print("Aviso encontrado:", aviso_encontrado)
else:
    print("Aviso não encontrado.")
