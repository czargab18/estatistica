import os
import json
from bs4 import BeautifulSoup


def globalribbon(
    html_content_test=None,
    root_dir=None,
    new_text=None,
    new_link=None,
    new_classes=None,
    display_none=False,
    tipo="avisos",
    titulo=None,
):
    def buscar_por_titulo(tipo, titulo):
        filepath = "/globalribbon/globalribbon.json"
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

    def find_and_update_index_files(
        root_dir, new_text, new_link, new_classes, display_none
    ):
        for subdir, _, files in os.walk(root_dir):
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

    if html_content_test:
        if display_none is not None:
            return update_globalribbon_style(html_content_test, display_none)
        else:
            return update_globalribbon(
                html_content_test, new_text, new_link, new_classes
            )

    if root_dir:
        find_and_update_index_files(
            root_dir, new_text, new_link, new_classes, display_none
        )


# Exemplo de uso
root_dir = "c:/Users/cesar.oliveira/Documents/github/estatistica"
new_text = "Novo conteúdo de aviso."
new_link = "https://www.exemplo.com/novo-link"
new_classes = ["nova-classe1", "nova-classe2"]
display_none = True
tipo = "avisos"
titulo = "Calendário Acadêmico 2025"


# Função para ser usada
globalribbon(
    root_dir=root_dir,
    new_text=new_text,
    new_link=new_link,
    new_classes=new_classes,
    display_none=display_none,
    tipo=tipo,
    titulo=titulo,
)
