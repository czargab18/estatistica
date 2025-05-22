from bs4 import BeautifulSoup
import os
import re

from bs4.dammit import html_meta
from core import *

def corlinkrel(tags, corlink):
    """
    Corrige o links das páginas de links que tenham atributo rel:
      exemplos de
      rel="next" : <link href="/books/{book}/references.html" rel="next"/> 
      rel="prev": <link href="/books/{book}/index.html" rel="prev"/> 
    """


def corlinkrel(tags, corlink, pasta_books):
    """
    Corrige o links das páginas de links que tenham atributo rel:
      exemplos de
      rel="next" : <link href="/books/{book}/references.html" rel="next"/> 
      rel="prev": <link href="/books/{book}/index.html" rel="prev"/> 
    """
    for root, _, files in os.walk(pasta_books):
        for file in files:
            if file.endswith(".html"):
                caminho_arquivo = os.path.join(root, file)
                with open(caminho_arquivo, "r", encoding="utf-8") as f:
                    soup = BeautifulSoup(f, "html.parser")

                # Corrigir links com rel="next" ou rel="prev"
                for tag in soup.find_all("link", rel=["next", "prev"]):
                    href_atual = tag.get("href")
                    if href_atual and not href_atual.startswith("/books/"):
                        # Extrair o nome do livro a partir do caminho do arquivo
                        nome_livro = os.path.basename(root)
                        # Atualizar o atributo href
                        tag["href"] = f"/books/{nome_livro}{href_atual}"

                # Salvar as alterações no arquivo
                with open(caminho_arquivo, "w", encoding="utf-8") as f:
                    f.write(str(soup))


# Exemplo de uso
corlinkrel("./books/")
if __name__ == "__main__" :
  index = """
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Index</title>
    <link href="/references.html" rel="next">
</head>
<body>
    <h1>Bem-vindo ao livro TAS000</h1>
</body>
</html>

  """
