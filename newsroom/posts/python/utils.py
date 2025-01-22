import os
import shutil
import glob
import re
import json
import random
import string
from datetime import datetime

""" FUNÇÕES ÚTEIS """


def verificacao(pergunta):
    """
    Verifica se a resposta é sim ou não
    """
    if pergunta in ["sim", "s"]:
        return True
    else:
        if pergunta in ["não", "nao", "n"]:
            return False


def continuar(pergunta):
    pergunta = input("Deseja continuar? Digite Sim ou Não: ").lower()
    verificacao(pergunta)


def existe(folder="newsroom/posts/article/"):
    """
    Função que verifica se a pasta desejada existe.
     - folder: str, nome da pasta. Padrão: 'newsroom/posts/article/'
    """
    pergunta = input(f"Há conteúdo na pasta {folder}? Digite Sim ou Não: ").lower()
    resposta = verificacao(pergunta)
    return resposta


def ler_nome_file(path="newsroom/posts/article/"):
    """
    Função que retorna o mês, o ano e o nome do arquivo .txt, sem a extensão, a partir do caminho fornecido.
    exemplo-padrão: "newsroom/posts/article/mes-ano.txt"
     - mes: vai de 1 até 12
     - ano: exemplo 2025
    """
    arquivos_txt = glob.glob(os.path.join(path, "*.txt"))
    if not arquivos_txt:
        raise FileNotFoundError("Nenhum arquivo .txt encontrado no caminho fornecido.")

    nome_arquivo_com_extensao = os.path.basename(arquivos_txt[0])
    nome_arquivo = os.path.splitext(nome_arquivo_com_extensao)[0]
    match = re.match(r"(0?[1-9]|1[0-2])-(\d{4})", nome_arquivo)
    if match:
        mes, ano = match.groups()
        return {
            "mes": str(mes),
            "ano": str(ano),
            "nome_arquivo": nome_arquivo_com_extensao,
        }
    else:
        raise ValueError("O nome do arquivo não está no formato esperado 'mes-ano'.")


def ler_conteudo_arquivo(path="newsroom/posts/article/"):
    """
    Função que lê o arquivo e retorna o conteúdo do arquivo dentro de um objeto.
     - path: str, nome do arquivo a ser lido.
    """
    try:
        with open(path, "r") as arquivo:
            conteudo = arquivo.read()
            return {"path": path, "conteudo": conteudo}
    except FileNotFoundError:
        print(f"Erro: O arquivo '{path}' não foi encontrado.")
        return {"path": path, "conteudo": None}


def gen_identificador():
    length = 9
    characters = string.ascii_lowercase + "123456789"
    identificador = ""
    for _ in range(length):
        identificador += random.choice(characters)
    return identificador

    # def gerar_caminho_artigo(data identificador, nome_arquivo="index.html"):
    """
    Função que gera o caminho para um artigo baseado no identificador, ano, mês e nome do arquivo.
    """
    # Pastas de destino
    destino_base = "articles/pt_BR/"
    data = None

    # Caminho final
    destino_final = os.path.join(destino_base, ano, mes, identificador, nome_arquivo)

    return destino_final


def path_article(data, identificador):
    """
    Função que gera o caminho para um artigo baseado no identificador, ano, mês e nome do arquivo.
    """
    data = data.replace('-', ' ')
    dia, mes, ano = map(str, data.split())

    # Caminho final
    path = os.path.join(
        "/articles/pt_BR/",
        ano + "/",
        mes.zfill(2) + "/",
        dia + "/",
        identificador + "/",
    )
    return path

# print(path_article(data="31-10-2025", identificador="shbsghbsrtgd"))


""" EXTRAIR INFORMAÇÕES DO .txt """


def ocultar():
    def extrair_titulo(): ...

    def extrair_subtitulo(): ...

    def extrair_tags(): ...

    def extrair_introducao(): ...

    def extrair_desenvolvimento(): ...

    def extrair_rodape(): ...

    return


""" ADICIONAR INFORMAÇÕES NO index.html """


""" FUNÇÃO RECEBER DADOS ITERAÇÃO """

def conteudo(tipos=["introducao", "conclusao", "resumo"]):
    """
    Coleta informações de meta e conteúdo.

    Para meta:
    - Qual o título?
    - Qual o subtítulo?
    - Quais as tags?

    Para conteúdo:
    - Esta função coleta conteúdo para os tipos especificados (introducao, conclusao, resumo).
    - Para cada tipo, a função pergunta ao usuário se há conteúdo a ser inserido.
    - Se a resposta for afirmativa, a função solicita a quantidade de parágrafos, figuras ou links.
    - Em seguida, coleta o conteúdo correspondente e o armazena em um dicionário.

    Parâmetros:
    tipos (list): Uma lista de strings que especifica os tipos de conteúdo a serem coletados.

    Retorna:
    dict: Um dicionário com as informações de meta e conteúdo coletado.
    """

    # Coleta de meta informações
    identificador = gen_identificador()
    titulo = str(input("Forneça o título: ")).strip().lower()
    subtitulo = str(input("Forneça o subtítulo: ")).strip().lower()
    data = (
        str(input("Forneça a data no formato 'dia mês ano' (ex: 01 12 2026): "))
        .strip()
        .lower()
    )
    codigo = str(input("Código da disciplina (ex. EST0042): ")).strip().upper()
    disciplina = str(input("Forneça o nome da disciplina: ")).strip().upper()
    path = path_article(data=data, identificador=identificador).strip().lower()

    tags = (
        str(input("Forneça as tags separadas por vírgulas: "))
        .strip()
        .lower()
        .split(",")
    )

    # Informações para o .JSON
    meta_info = {
        "identificador": identificador,
        "titulo": titulo,
        "subtitulo": subtitulo,
        "data": data,
        "codigo": codigo,
        "disciplina": disciplina,
        "path": path,
        "tags": tags,
    }

    # Coleta de conteúdo
    tipos_validos = ["introducao", "conclusao", "resumo"]
    for tipo in tipos:
        if tipo not in tipos_validos:
            raise ValueError(
                f"Tipo inválido. Use um dos seguintes: {', '.join(tipos_validos)}"
            )

    conteudo = {tipo: [] for tipo in tipos}

    for tipo in tipos:
        resposta = str(input(f"Tem {tipo}? ")).strip().lower()

        if resposta in ["sim", "s", "y", "yes"]:
            while True:
                p_ou_f = (
                    str(
                        input(
                            "Deseja inserir um paragrafo, figura ou link ? Digite p, f ou l. "
                        )
                    )
                    .strip()
                    .lower()
                )
                if p_ou_f in ["paragrafo", "p"]:
                    string = str(input("Insira o seu paragrafo: ")).strip()
                    conteudo[tipo].append(string)
                elif p_ou_f in ["figure", "figura", "f"]:
                    string = str(input("Insira o seu figura: ")).strip()
                    conteudo[tipo].append(string)
                else:
                    string = str(input("Insira o seu link: ")).strip()
                    conteudo[tipo].append(string)

                continuar = (
                    str(input("Deseja continuar inserindo? Digite sim ou não: "))
                    .strip()
                    .lower()
                )
                if continuar not in ["sim", "s", "y", "yes"]:
                    break
        else:
            conteudo[tipo] = f"{tipo.capitalize()} sem conteúdo"

    info_artigo = {identificador: {"meta_info": meta_info, "conteudo": conteudo}}

    return json.dumps(info_artigo, indent=2)


""" ADICIONAR DADOS AO index.html """


""" MANIPULAR DADOS DO article.json """


def up_article_json(json=conteudo(), path="newsroom/data/articles.json"):
    ...
    return "ARQUIVO ATUALIZADO: article.json"


""" FINALIZAR PROCESSO """


def mover_arquivos():
    """
    Função que copia todo o conteúdo de uma pasta, incluindo subpastas e arquivos, para outra pasta.
    Antes de mover, cria uma pasta que receberá como nome o valor do identificador.
    """
    resposta = str(input("Deseja MOVER os arquivos? Sim ou Não: ")).strip().lower()
    if resposta in ["sim", "s"]:
        # Pastas de origem e destino
        origem_base = "newsroom/posts/article/"
        destino_base = "articles/pt_BR/"
        src_subpasta = os.path.join(origem_base, "src")

        # Gera o identificador
        identificador = gen_identificador()

        # Obtém o nome do arquivo .txt e as informações de ano e mês
        arquivo_info = ler_nome_file(origem_base)
        ano = str(arquivo_info["ano"])
        mes = str(arquivo_info["mes"])

        # Caminhos
        src_arquivo = os.path.join(origem_base, arquivo_info["nome_arquivo"])
        destino_final = os.path.join(
            destino_base, ano + "/", mes + "/", identificador + "/"
        )

        # Cria a pasta do identificador dentro da estrutura de pasta existente
        os.makedirs(destino_final, exist_ok=True)

        # Copia a subpasta e seus arquivos
        shutil.copytree(
            src_subpasta, os.path.join(destino_final, "src"), dirs_exist_ok=True
        )

        # Copia o arquivo .txt
        shutil.copy(src_arquivo, destino_final)
    else:
        return f"Processo NÃO FEZ NADA com os arquivos. Resposta '{resposta}' diferente de 'Sim'."

    return {destino_final, "\nProcesso finalizado!"}


def excluir_arquivos(resposta="Não", path="newsroom/posts/article/"):
    resposta = str(input("Deseja EXCLUIR os arquivos? Sim ou Não: ")).strip().lower()
    if resposta in ["sim", "s"]:
        try:
            for item in os.listdir(path):
                item_path = os.path.join(path, item)
                if os.path.isdir(item_path):
                    shutil.rmtree(item_path)
                else:
                    os.remove(item_path)
            return f"Arquivos e pastas dentro de '{path}' foram excluídos."
        except FileNotFoundError:
            return f"Erro: O caminho '{path}' não foi encontrado."
        except Exception as e:
            return f"Erro ao excluir arquivos e pastas: {e}"
    else:
        return (
            f"Processo NÃO excluiu os arquivos. Resposta '{resposta}' diferente de Sim"
        )


""" TESTANDO A FUNÇÃO """
