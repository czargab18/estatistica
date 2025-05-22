import json
import os
import markdown
## pip install markdown


def readarticleqmd(diretorio: str = "./newsroom/newshub/build/artigo/artigo.qmd"):
    with open(diretorio, 'r', encoding='utf-8') as file:
        conteudo = file.read()
    return markdown.markdown(conteudo, extensions=['extra', 'tables', 'toc'])


print(readarticleqmd())


def qmdtojson(
    diretorio_ou_arquivo: str = "./newsroom/newshub/build/artigo/",
    extensoes: list = ['.qmd', '.bib'],
    buscar: bool = True
    ):
    """
    Processa arquivos em um diretório ou um único arquivo e retorna um JSON com o conteúdo.

    :param diretorio_ou_arquivo: Caminho do diretório ou arquivo.
    :param extensoes: Lista de extensões de arquivo a serem procuradas (usado apenas se buscar=True).
    :param buscar: Booleano que indica se deve buscar arquivos no diretório ou processar um único arquivo.
    :return: JSON com o nome do arquivo como chave e o conteúdo como valor.
    """
    resultado = {}

    if buscar:
        arquivos_encontrados = []
        for root, _, files in os.walk(diretorio_ou_arquivo):
            for file in files:
                if any(file.endswith(ext) for ext in extensoes):
                    arquivos_encontrados.append(os.path.join(root, file))
    else:
        arquivos_encontrados = [diretorio_ou_arquivo]  # Trata como um único arquivo.

    for arquivo in arquivos_encontrados:
        try:
            with open(arquivo, 'r', encoding='utf-8') as file:
                conteudo = file.read()
            conteudo_html = markdown.markdown(conteudo, extensions=['extra', 'tables', 'toc'])
            resultado[os.path.basename(arquivo)] = conteudo_html
        except Exception as e:
            resultado[os.path.basename(arquivo)] = f"Erro ao processar o arquivo: {e}"

    return json.dumps(resultado, ensure_ascii=False, indent=4)

# if __name__ == '__main__':
#     diretorio = "./newsroom/newshub/build/artigo/"
#     extensoes = ['.qmd']
#     resultado = qmdtojson(diretorio_ou_arquivo=diretorio,
#                         extensoes=extensoes, buscar=True)
#     print(resultado)