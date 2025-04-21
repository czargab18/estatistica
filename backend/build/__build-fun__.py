# def includeinhead(linkstoinclude, pathbooks: str = "./books/", tipoarquivo: str = ".html"):
#     """
#     Inclui os links especificados no <head> de arquivos HTML encontrados no diretório especificado.
#     :param pathbooks: Caminho base onde os arquivos HTML estão localizados.
#     :param tipoarquivo: Tipo de arquivo a ser processado (por padrão, ".html").
#     :param linkstoinclude: Lista de links a serem incluídos no <head>.
#     :return: Dicionário com os arquivos processados e seu status.
#     """
#     arquivos_processados = {}
#     for root, _, files in os.walk(pathbooks):
#         for file in files:
#             if file.endswith(tipoarquivo):
#                 caminho_arquivo = os.path.join(root, file)
#                 try:
#                     with open(caminho_arquivo, 'r', encoding='utf-8') as f:
#                         conteudo = f.read()
#                     # Verifica se o <head> já contém os links
#                     if any(link in conteudo for link in linkstoinclude):
#                         arquivos_processados[caminho_arquivo] = "Links já incluídos"
#                         continue
#                     # Insere os links no <head>
#                     if "<head>" in conteudo:
#                         conteudo = conteudo.replace(
#                             "<head>", f"<head>\n{''.join(linkstoinclude)}\n"
#                         )
#                     else:
#                         arquivos_processados[caminho_arquivo] = "Tag <head> não encontrada"
#                         continue
#                     # Salva o arquivo atualizado
#                     with open(caminho_arquivo, 'w', encoding='utf-8') as f:
#                         f.write(conteudo)
#                     arquivos_processados[caminho_arquivo] = "Links incluídos com sucesso"
#                 except Exception as e:
#                     arquivos_processados[caminho_arquivo] = f"Erro: {e}"
#     return arquivos_processados

from bs4 import BeautifulSoup
import core
import os
import re

def includeinheadbooks(
    links,
    booksin: str = "./books/",
    tipoarquivo: str = ".html",
    linksin: str = "./books/build/include/include-in-head",
    headclean: bool = False,
):
    """
    Inclui links no <head> de arquivos HTML encontrados no diretório especificado.

    :param links: Lista de links (ex.: tags <link> ou <script>) a serem incluídos no <head>.
    :param booksin: Caminho base onde os arquivos HTML dos books estão localizados (padrão: "./books/").
    :param tipoarquivo: Tipo de arquivo a ser processado (padrão: ".html").
    :param linksin: Caminho para um arquivo contendo links adicionais a serem incluídos no <head>.
    :param headclean: Se True, limpa o conteúdo existente do <head> antes de adicionar os novos links.
    :return: Dicionário com os arquivos processados e seu status, indicando sucesso ou erros encontrados.

    A função processa todos os arquivos no diretório especificado e seus subdiretórios.
    Se `headclean` for True, o conteúdo existente do <head> será removido antes de adicionar os links.
    Links adicionais podem ser carregados de um arquivo especificado em  linksin`.
    """
    # ...existing code...
    return ...
