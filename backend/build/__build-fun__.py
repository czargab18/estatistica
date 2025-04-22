from bs4 import BeautifulSoup
import os
import re
from core import *
from core.variaveis import CAMINHOS


def corrigirlinksinhead(
    path: str,
    corlink: dict,
    rmhead: str,
    patternfolders: str,
    tipoarquivo: str = ".html",
    cordefer: bool = False,
):
    """
    Inclui ou corrige links no <head> de arquivos HTML encontrados no diretório especificado.

    A função processa todos os arquivos HTML no diretório base e seus subdiretórios, realizando as seguintes operações:
    1. Adiciona links especificados ao elemento <head>.
    2. Corrige links existentes com base em padrões fornecidos.
    3. Remove links ou scripts desnecessários que contenham um texto específico no atributo `href` ou `src`.

    :param path: Caminho do diretório base onde os arquivos HTML estão localizados.
    :param corlink: Dicionário com padrões antigos como chave e substituições como valor, usado para corrigir links existentes.
    :param rmhead: Texto que, se encontrado no atributo `href` ou `src`, indica que a tag <link> ou <script> deve ser removida.
    :param patternfolders: Padrão para identificar pastas relevantes dentro do diretório base.
    :param tipoarquivo: Tipo de arquivo a ser processado (padrão: ".html").
    :return: Nenhum retorno explícito, mas os arquivos HTML são atualizados diretamente no disco.

    Detalhes adicionais:
    - A função busca pastas que correspondem ao padrão especificado em `patternfolders`.
    - Links e scripts no <head> são corrigidos ou removidos com base nos parâmetros fornecidos.
    - O conteúdo atualizado é salvo diretamente nos arquivos HTML processados.
    """
     
    def buscarpasta(base_path, pattern):
        """Busca pastas que correspondem ao padrão especificado."""
        return [
            os.path.join(base_path, pasta)
            for pasta in os.listdir(base_path)
            if os.path.isdir(os.path.join(base_path, pasta))
            and re.match(pattern, pasta)
        ]

    def corrigirlinks(tags, corlink):
        """Corrige os atributos href ou src das tags encontradas."""
        for tag in tags:
            if tag.has_attr("href"):
                for old, new in corlink.items():
                    if old in tag["href"]:
                        tag["href"] = tag["href"].replace(old, new)
            if tag.has_attr("src"):
                for old, new in corlink.items():
                    if old in tag["src"]:
                        tag["src"] = tag["src"].replace(old, new)


    def cordefer(tags):
        """Corrige scripts com: 'defer=""' => 'defer'."""
        for tag in tags:
            if tag.has_attr("defer") and tag["defer"] == "":
                tag["defer"] = "defer"

    def removerhead(tags, texto_para_remover):
        """Remove tags <link> e <script> que contenham o texto no href ou src."""
        for tag in tags:
            if tag.has_attr("href") and texto_para_remover in tag["href"]:
                tag.decompose()  # Remove a tag do documento
            elif tag.has_attr("src") and texto_para_remover in tag["src"]:
                tag.decompose()  # Remove a tag do documento

    def salvar_arquivo(filepath, soup):
        """Sobrescreve o arquivo HTML com as alterações."""
        with open(filepath, "w", encoding="utf-8") as file:
            file.write(str(soup))

    # Busca pastas que correspondem ao padrão
    pastas_relevantes = buscarpasta(path, patternfolders)

    for pasta in pastas_relevantes:
        # Percorre todas as subpastas e arquivos HTML
        for root, _, files in os.walk(pasta):
            for file in files:
                if file.endswith(".html"):
                    filepath = os.path.join(root, file)
                    with open(filepath, "r", encoding="utf-8") as f:
                        soup = BeautifulSoup(f, "html.parser")
                    head = soup.head
                    if head:
                        tags = head.find_all(["link", "script"])
                        corrigirlinks(tags, corlink)
                        removerhead(tags, rmhead)
                        salvar_arquivo(filepath, soup)






if __name__ == "__main__":

        # HTML de exemplo para criar tags
    html_exemplo = """
    <html>
    <head>
        <script src="script1.js" defer=""></script>
        <script src="script2.js"></script>
        <script src="script3.js" defer=""></script>
        <script src="script4.js" defer="defer"></script>
    </head>
    <body>
    </body>
    </html>
    """

    # Parseando o HTML com BeautifulSoup
    soup = BeautifulSoup(html_exemplo, "html.parser")

    # Selecionando todas as tags <script>
    tags = soup.find_all("script")

    # Função cordefer


    def cordefer(tags):
        """Corrige scripts com: 'defer=""' => 'defer'."""
        for tag in tags:
            if tag.has_attr("defer") and tag["defer"] == "":
                tag["defer"] = "defer"


    # Testando a função
    cordefer(tags)

    # Verificando o resultado
    print(soup.prettify())
