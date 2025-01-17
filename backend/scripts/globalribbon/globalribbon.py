import os
import json
from bs4 import BeautifulSoup


def globalribbon(
    filepath,
    titulo=None,
    display_none=True,  # Valor padrão
    tipo="avisos",  # Valor padrão
):
    def buscar_por_titulo(titulo):
        json_filepath = "c:/Users/cesar.oliveira/Documents/github/estatistica/backend/scripts/globalribbon/globalribbon.json"
        with open(json_filepath, "r", encoding="utf-8") as file:
            data = json.load(file)

        for tipo in ["avisos", "eventos"]:
            for item in data[tipo]:
                if titulo and item["titulo"] == titulo:
                    return {
                        "tipo": tipo,
                        "titulo": item["titulo"],
                        "conteudo": item["conteudo"],
                        "link": item["link"],
                        "classes": item["classes"],
                    }

        print(f"Título '{titulo}' não encontrado.")
        return None

    def update_globalribbon(html_content, new_text, new_link, new_classes):
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

    def update_globalribbon_style(html_content, display_none):
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

    def find_and_update_index_files(
        filepath, new_text, new_link, new_classes, display_none
    ):
        for subdir, _, files in os.walk(filepath):
            for file in files:
                if file == "index.html":
                    file_path = os.path.join(subdir, file)
                    with open(file_path, "r", encoding="utf-8") as f:
                        html_content = f.read()

                    if display_none is not None:
                        updated_html = update_globalribbon_style(
                            html_content, display_none
                        )
                    else:
                        updated_html = update_globalribbon(
                            html_content, new_text, new_link, new_classes
                        )

                    if updated_html:
                        with open(file_path, "w", encoding="utf-8") as f:
                            f.write(updated_html)
                        print(f"Arquivo atualizado: {file_path}")

    item_encontrado = buscar_por_titulo(titulo)
    if item_encontrado:
        print(f"Item encontrado: {item_encontrado}")
        new_text = item_encontrado["conteudo"]
        new_link = item_encontrado["link"]
        new_classes = item_encontrado["classes"]
        find_and_update_index_files(
            filepath, new_text, new_link, new_classes, display_none
        )
    else:
        print(f"Item com título '{titulo}' não encontrado.")


# Exemplo de uso
filepath = "c:/Users/cesar.oliveira/Documents/github/estatistica"
titulo = "Calendário Acadêmico 2025"

globalribbon(
    filepath=filepath,
    titulo=titulo,
    display_none=False,
)
