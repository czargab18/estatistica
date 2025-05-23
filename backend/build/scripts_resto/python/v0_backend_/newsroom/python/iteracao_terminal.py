import os
import re
import json
import string
import random
from bs4 import BeautifulSoup
import requests
#################### OUTRAS FUNÇÕES ###


def existe(folder="backend/scripts/newsroom/posts/article/"):
    pergunta = input(
        f"Há conteúdo na pasta {folder}? Digite Sim ou Não: ").lower()
    resposta = fazer_pergunta("p", pergunta)
    return resposta


def dados_nome(path="backend/scripts/newsroom/posts/article/"):
    arquivos_txt = glob.glob(os.path.join(path, "*.txt"))
    if not arquivos_txt:
        raise FileNotFoundError(
            "Nenhum arquivo .txt encontrado no caminho fornecido.")

    nome_arquivo_com_extensao = os.path.basename(arquivos_txt[0])
    nome_arquivo = os.path.splitext(nome_arquivo_com_extensao)[0]
    match = re.match(r"(0?[1-9]|1[0-2])-(\d{4})", nome_arquivo)
    if match:
        mes, ano = match.groups()
        dados = {
            "mes": str(mes),
            "ano": str(ano),
            "nome": nome_arquivo_com_extensao,
        }
        return dados
    else:
        raise ValueError(
            "O nome do arquivo não está no formato esperado 'mes-ano'.")


def ler_conteudo_arquivo(path="backend/scripts/newsroom/posts/article/"):
    try:
        dados_arquivo = dados_nome()
        path = os.path.join(path, dados_arquivo["nome"])
        with open(path, "r") as arquivo:
            conteudo = arquivo.read()
            return {"path": path, "conteudo": conteudo}
    except FileNotFoundError:
        print(f"Erro: O arquivo '{path}' não foi encontrado.")
        return {"path": path, "conteudo": None}


def conteudo(tipos=["introducao", "desenvolvimento", "conclusao", "rodape"]):
    identificador = gen_identificador()
    titulo = str(input("Forneça o título: ")).strip().lower()
    subtitulo = str(input("Forneça o subtítulo: ")).strip().lower()
    data = str(input(
        "Forneça a data no formato 'dia mês ano' (ex: 01 12 2026): ")).strip().lower()
    codigo_disciplina = codigo()
    disciplina = str(input("Forneça o nome da disciplina: ")).strip().upper()
    path = path_article(data=data, identificador=identificador).strip().lower()
    tags = str(input("Forneça as tags separadas por uma virgula ',': ")
               ).strip().lower().split(",")

    tipos_validos = ["introducao", "desenvolvimento", "conclusao", "rodape"]
    for tipo in tipos:
        if tipo not in tipos_validos:
            raise ValueError(
                f"Tipo inválido. Use um dos seguintes: {', '.join(tipos_validos)}")

    conteudo = {tipo: [] for tipo in tipos}

    for tipo in tipos:
        resposta = str(input(f"Tem {tipo}? ")).strip().lower()

        if resposta in ["sim", "s", "y", "yes"]:
            while True:
                p_ou_f = str(input(
                    "Deseja inserir um paragrafo, figura ou link ? Digite p, f ou l. ")).strip().lower()
                if p_ou_f in ["paragrafo", "p"]:
                    string = str(input("Insira o seu paragrafo: ")).strip()
                    conteudo[tipo].append(string)
                elif p_ou_f in ["figure", "figura", "f"]:
                    string = str(input("Insira o seu figura: ")).strip()
                    conteudo[tipo].append(string)
                else:
                    string = str(input("Insira o seu link: ")).strip()
                    conteudo[tipo].append(string)

                continuar = str(
                    input("Deseja continuar inserindo? Digite sim ou não: ")).strip().lower()
                if continuar not in ["sim", "s", "y", "yes"]:
                    break
        else:
            conteudo[tipo] = f"{tipo.capitalize()} sem conte\u00fado"

    info_artigo = {
        identificador: {
            "meta_info": {
                "identificador": identificador,
                "titulo": titulo,
                "subtitulo": subtitulo,
                "data": data,
                "codigo": codigo_disciplina,
                "disciplina": disciplina,
                "path": path,
                "tags": tags,
            },
            "conteudo": conteudo,
        }
    }

    return json.dumps(info_artigo, indent=2)


def up_article_json(artigo=None, path="/newsroom/posts/data/articles.json"):
    if artigo is None:
        print("Conteúdo do artigo não foi informado!")
        if fazer_pergunta("t", "Deseja executar função: conteudo()"):
            artigo = conteudo()

    if os.path.exists(path):
        with open(path, "r", encoding="utf-8") as file:
            try:
                conteudo_existente = json.load(file)
            except json.JSONDecodeError:
                conteudo_existente = {}
    else:
        conteudo_existente = {}

    conteudo_atualizado = {**artigo, **conteudo_existente}

    with open(path, "w", encoding="utf-8") as file:
        json.dump(conteudo_atualizado, file, ensure_ascii=False, indent=2)

    return "ARQUIVO ATUALIZADO: article.json"


def mover(pais="pt_BR"):
    resposta = str(
        input("Deseja MOVER os arquivos? Sim ou Não: ")).strip().lower()
    if resposta in ["sim", "s"]:
        dados_nome_arquivo = dados_nome()
        mes = dados_nome_arquivo["mes"]
        ano = dados_nome_arquivo["ano"]
        origem = "backend/scripts/newsroom/posts/article/"
        destino = os.path.join(
            f"newsroom/articles/{pais}", ano + "/", mes + "/")

        if not os.path.exists(destino):
            os.makedirs(destino)

        for item in os.listdir(origem):
            s = os.path.join(origem, item)
            d = os.path.join(destino, item)
            if os.path.isdir(s):
                shutil.move(s, d)
            else:
                shutil.move(s, d)

        return f"Arquivos movidos com sucesso para {destino}."
    else:
        return f"Processo NÃO FEZ NADA com os arquivos. Resposta '{resposta}' diferente de 'Sim'."


def excluir_arquivos(resposta="Não", path="backend/scripts/newsroom/posts/article/"):
    resposta = str(
        input("Deseja EXCLUIR os arquivos? Sim ou Não: ")).strip().lower()
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
