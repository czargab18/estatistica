import os
import re

CAMINHO_BASE = os.path.abspath(__file__).split(
    "estatistica")[0] + "estatistica"

CAMINHOS = {
    "rm_head": "/delete/site_libs/",
    "pattern_book": re.compile(r"^[A-Z]{3}\d{4}$"),
    "dir_base": os.path.abspath(__file__).split("estatistica")[0] + "estatistica",
    "dir_include": os.path.normpath("./books/build/include/"),
    "lista_books": os.path.join(CAMINHO_BASE, "backend/data/books/books.json").replace(
        "\\", "/"
    ),
    "path_books": os.path.join(CAMINHO_BASE, "books").replace("\\", "/"),
}

CORRECOESLINK = {
    "./": "/",  # Caminho relativo redundante
    "../": "/",  # Caminho para o diretório pai
    "././": "/",  # Caminho redundante para o mesmo diretório
    "//": "/",  # Caminho com barras duplas
    "../../": "/",  # Caminho para dois níveis acima
    "./../../": "/",  # Caminho redundante para dois níveis acima
    "////": "/",  # Caminho com múltiplas barras
    "./../": "/",  # Caminho redundante para o diretório pai
    "./././": "/",  # Caminho redundante para o mesmo diretório
    "../../../": "/",  # Caminho para três níveis acima
    "./../../../": "/",  # Caminho redundante para três níveis acima
    "index.html/": "index.html",  # Caminho incorreto com barra no final
    "/./": "/",  # Caminho redundante com barra inicial
    "/../": "/",  # Caminho redundante com barra inicial para o diretório pai
    "//./": "/",  # Caminho com barra dupla e redundância
    "//../": "/",  # Caminho com barra dupla e redundância para o diretório pai
    "///": "/",
    "///": "/",  # Caminho com três barras
    "////": "/",  # Caminho com quatro barras
    "/////": "/",  # Caminho com cinco barras
    "/././": "/",  # Caminho redundante com barras e pontos
    "/.././": "/",  # Caminho redundante para o diretório pai com barra inicial
    "././././": "/",  # Caminho redundante com múltiplos pontos
    "////./": "/",  # Caminho com múltiplas barras e ponto
    "////../": "/",  # Caminho com múltiplas barras e diretório pai
    "././.././": "/",  # Caminho redundante com mistura de pontos e diretório pai
    "////././": "/",  # Caminho com múltiplas barras e redundância
    "estatistica/ac/": "/ac/",
    "estatistica/sd/": "/sd/",
}
