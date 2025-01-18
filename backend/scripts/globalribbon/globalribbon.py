import os
import json
import logging
from bs4 import BeautifulSoup

# Configuração do logging
logging.basicConfig(level=logging.INFO)


def globalribbon(filepath, titulo=None, display_none=True, tipo="avisos"):
    # Caminho do arquivo JSON
    json_filepath = "backend/scripts/globalribbon/globalribbon.json"

    # Buscar o item pelo título
    item_titulo = None
    item_conteudo = None
    item_link = None
    item_classes = None

    try:
        with open(json_filepath, "r", encoding="utf-8") as file:
            data = json.load(file)

        for tipo in ["avisos", "eventos"]:
            for item in data.get(tipo, []):
                if titulo and item.get("titulo") == titulo:
                    item_titulo = item["titulo"]
                    item_conteudo = item["conteudo"]
                    item_link = item["link"]
                    item_classes = item["classes"]
                    break
    except FileNotFoundError:
        logging.error(f"Arquivo {json_filepath} não encontrado.")
    except json.JSONDecodeError:
        logging.error(f"Erro ao decodificar {json_filepath}.")

    if item_titulo is None:
        logging.info(f"Título '{titulo}' não encontrado.")
        return

    logging.info(
        f"Item encontrado: Título: {item_titulo}, Conteúdo: {item_conteudo}, Link: {item_link}, Classes: {item_classes}"
    )

    # Caminhar pelos arquivos HTML e atualizar conforme necessário
    for subdir, _, files in os.walk(filepath):
        for file in files:
            if file == "index.html":
                file_path = os.path.join(subdir, file)
                try:
                    with open(file_path, "r", encoding="utf-8") as f:
                        html_content = f.read()

                    soup = BeautifulSoup(html_content, "html.parser")
                    globalribbon_section = soup.select_one(
                        "#globalheader #globalribbon"
                    )

                    if globalribbon_section:
                        if display_none:
                            globalribbon_section["style"] = "display: none;"
                        else:
                            globalribbon_section.attrs.pop("style", None)

                        # Atualizar o texto do conteúdo
                        news_content = globalribbon_section.find(
                            "span", id="news-content"
                        )
                        if news_content:
                            news_content.string = item_conteudo
                            if item_classes:
                                news_content["class"] = " ".join(item_classes)

                        # Atualizar o link
                        news_link = globalribbon_section.find("a")
                        if news_link:
                            news_link["href"] = item_link

                        updated_html = str(soup)

                        with open(file_path, "w", encoding="utf-8") as f:
                            f.write(updated_html)

                        logging.info(f"Arquivo atualizado: {file_path}")
                except Exception as e:
                    logging.error(f"Falha ao atualizar {file_path}: {e}")


# Exemplo de uso
globalribbon(
    filepath="c:/Users/cesargabrielphd/Documents/github/estatistica",
    titulo="Calendário Acadêmico",
    display_none=False,
)
