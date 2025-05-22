"""
 * Pacote de funções para automatizar criação de artiglos para o site:
 * AINDA NÃO SERÁ 100% AUTOMATIZADO. PRECISAREI FAZER MUITAS COISAS MANUALMENTE
"""

import os
import re
import json
import string
import random
from bs4 import BeautifulSoup, Comment
import shutil

def verificar_resposta(resposta):
    if resposta in ["sim", "s", "yes", "y"]:
        return True
    elif resposta in ["não", "nao", "n", "no", "ñ"]:
        return False
    else:
        return None

def fazer_pergunta(opcao: str, pergunta: str):
    """
    Função para automatizar perguntas e verificação.
    """
    resposta = input(f'{pergunta}? (s/n): ').lower().strip()
    return verificar_resposta(resposta)


def path_article(data, identificador, pais="pt_BR"):
    """
    Função que gera o caminho para um artigo baseado no identificador, ano, mês e nome do arquivo.
    """
    data = data.replace('-', ' ')
    dia, mes, ano = map(str, data.split())

    path = os.path.join(
        f"/newsroom/articles/{pais}/",
        ano + "/",
        mes.zfill(2) + "/",
        dia + "/",
        identificador + "/",
    )
    return path


def codigo():
    resposta = str(input("Código da disciplina (ex. EST0042): ")).strip().upper()
    padrao = bool(re.compile(r"^[A-Z]{3}\d{4}$").match(resposta))

    if padrao:
        return resposta
    else:
        print(f"O código '{resposta}' não segue o padrão de 3 letras e 4 digitos! ex. EST0043")
        if fazer_pergunta(opcao="t", pergunta="Deseja tentar novamente"):
            return codigo()
        else:
            return f"Usuário informou codigo inválido! Resposta fornecida (em maiúscula): {resposta}"


def import_article(filepath='./config/scripts/newsroom/posts/article/artigo.txt'):
    if not os.path.exists(filepath):
        raise FileNotFoundError(f"Arquivo não encontrado: {filepath}")
    with open(filepath, 'r', encoding='utf-8') as file:
        article = file.read()
    return article


def identificador_existe(identificador):
    try:
        with open('./config/data/articles.json', 'r', encoding='utf-8') as file:
            data = json.load(file)
            return identificador in data
    except FileNotFoundError:
        return False

def gen_identificador():
    length = 9
    characters = string.ascii_lowercase + "123456789"
    identificador = "".join(random.choice(characters) for _ in range(length))
    while identificador_existe(identificador):
        identificador = "".join(random.choice(characters) for _ in range(length))
    return identificador


def get_article_info(article):
    """
    Função para capturar todas as informações do artigo.
    """
    info = {
        "titulo": re.search(r'Titulo:\s*(.*)\s*;', article).group(1),
        "subtitulo": re.search(r'Subtitulo:\s*(.*)\s*;', article).group(1),
        "data": re.search(r'data:\s*(.*)\s*', article).group(1),
        "autor": re.search(r'autor:\s*(.*)\s*', article).group(1),
        "tags": re.search(r'tags:\s*(.*)\s*', article).group(1).split(', '),
        "categoria": re.search(r'categoria:\s*(.*)\s*', article).group(1),
        "resumo": re.search(r'resumo:\s*(.*)\s*', article).group(1),
        "imagens": [img.strip() for img in re.search(r'imagem:\s*\[(.*?)\]\s*', article, re.DOTALL).group(1).split('; ') if img.strip()],
        "introducao": get_section(article, 'Introdução'),
        "desenvolvimento": get_section(article, 'Desenvolvimento'),
        "conclusao": get_section(article, 'Conclusão'),
        "rodape": get_section(article, 'Rodapé')
    }
    return info


def get_section(article, section_name):
    pattern = rf'--- inicio {section_name} ---\s*(.*?)\s*--- fim {section_name} ---'
    match = re.search(pattern, article, re.DOTALL)
    if match:
        return match.group(1).strip()
    return ''


def extract_article_info():
    article = import_article()
    return get_article_info(article)


def save_article_info_to_json(article_info, identificador):
    article_data = {
        identificador: {
            "meta_info": {
                "titulo": article_info["titulo"],
                "subtitulo": article_info["subtitulo"],
                "data": article_info["data"],
                "autor": article_info["autor"],
                "tags": article_info["tags"],
                "categoria": article_info["categoria"],
                "resumo": article_info["resumo"],
                "imagem": article_info["imagens"]
            },
            "conteudo": {
                "introducao": article_info["introducao"].split('\n'),
                "desenvolvimento": article_info["desenvolvimento"].split('\n'),
                "conclusao": article_info["conclusao"].split('\n'),
                "rodape": article_info["rodape"].split('\n')
            }
        }
    }

    try:
        with open('./config/data/articles.json', 'r', encoding='utf-8') as file:
            data = json.load(file)
    except FileNotFoundError:
        data = {}

    data.update(article_data)

    with open('./config/data/articles.json', 'w', encoding='utf-8') as file:
        json.dump(data, file, ensure_ascii=False, indent=2)

def clean_json_data(json_data):
    def clean_string(s):
        return s.replace('\n', '').replace('\t', '').replace('\r', '').replace('\"', '').replace('<p>', '').strip()

    def clean_list(lst):
        return [clean_string(item) for item in lst]

    cleaned_data = {}
    for key, value in json_data.items():
        if isinstance(value, dict):
            cleaned_data[key] = clean_json_data(value)
        elif isinstance(value, list):
            cleaned_data[key] = clean_list(value)
        elif isinstance(value, str):
            cleaned_data[key] = clean_string(value)
        else:
            cleaned_data[key] = value

    return cleaned_data


def load_and_clean_json(filepath):
    with open(filepath, 'r', encoding='utf-8') as file:
        data = json.load(file)

    cleaned_data = clean_json_data(data)

    with open(filepath, 'w', encoding='utf-8') as file:
        json.dump(cleaned_data, file, ensure_ascii=False, indent=2)



# Salvar informações do artigo em um HTML

def load_html_template(filepath):
    with open(filepath, 'r', encoding='utf-8') as file:
        template_html = file.read()
    return template_html

def save_article_to_html(article_info, template_html, output_filepath):
    soup = BeautifulSoup(template_html, 'html.parser')

    # Atualizar os títulos
    title_tag = soup.find('h1', {'id': 'title-article'})
    if title_tag:
        title_tag.string = article_info['titulo']

    subtitle_tag = soup.find('h2', {'id': 'subtitle-article'})
    if subtitle_tag:
        subtitle_tag.string = article_info['subtitulo']

    # Atualizar as seções
    def update_section(section_name, content):
        section_meta = soup.find('meta', {'data-section-article': section_name})
        if section_meta:
            section_div = section_meta.find_next_sibling('div', class_='pagebody-copy')
            if section_div:
                section_div.clear()
                # Adicionar cada parágrafo separadamente
                for paragraph in content.split('\n'):
                    p_tag = soup.new_tag('p')
                    p_tag.string = paragraph.strip()
                    section_div.append(p_tag)

    update_section('Introdução', article_info['introducao'])
    update_section('Desenvolvimento', article_info['desenvolvimento'])
    update_section('Conclusão', article_info['conclusao'])

    # Remover comentários gerados pelo artigo
    for comment in soup.find_all(string=lambda text: isinstance(text, Comment)):
        if "Conteúdo da" in comment:
            comment.extract()

    # Garantir que o diretório de saída exista
    os.makedirs(os.path.dirname(output_filepath), exist_ok=True)

    # Salvar o HTML final
    with open(output_filepath, 'w', encoding='utf-8') as file:
        file.write(str(soup))

# Exemplo de uso
template_html = load_html_template('./config/scripts/newsroom/posts/template.html')
article_info = extract_article_info()
identificador = gen_identificador()
article_info['identificador'] = identificador  # Adicionar o identificador ao article_info
save_article_to_html(article_info, template_html, f'./config/scripts/newsroom/posts/article/{identificador}/index.html')


# Salvar arquivos do artigo na pasta raiz: /newsroom/

def update_article_path(identificador):
    path = f"/newsroom/articles/pt_BR/{identificador}/index.html"
    try:
        with open('./config/data/articles.json', 'r', encoding='utf-8') as file:
            data = json.load(file)
    except FileNotFoundError:
        data = {}

    if identificador in data:
        data[identificador]['meta_info']['path'] = path
    else:
        print(f"Identificador {identificador} não encontrado no arquivo JSON.")

    with open('./config/data/articles.json', 'w', encoding='utf-8') as file:
        json.dump(data, file, ensure_ascii=False, indent=2)


# Exemplo de uso
article_info = extract_article_info()
identificador = gen_identificador()
save_article_info_to_json(article_info, identificador)
update_article_path(identificador)

for key, value in article_info.items():
    print(f"{key}: {value}")

load_and_clean_json('./config/data/articles.json')

update_article_path(identificador=identificador)


## Mover arquivis para pasta local: index.html e src/ dentro de posts/article/ para a pasta raiz: /newsroom/identificador/


def mover_arquivos(identificador):
    origem_html = './config/scripts/newsroom/posts/article/index.html'
    destino_html = f'./newsroom/articles/pt_BR/{identificador}/index.html'
    origem_src = './config/scripts/newsroom/posts/article/src/'
    destino_src = f'./newsroom/articles/pt_BR/{identificador}/src/'
    # Garantir que o diretório de destino exista
    os.makedirs(os.path.dirname(destino_html), exist_ok=True)

    # Mover o arquivo index.html
    shutil.move(origem_html, destino_html)

    # Mover a pasta src
    if os.path.exists(origem_src):
        shutil.move(origem_src, destino_src)
    else:
        print(f"Pasta de origem {origem_src} não encontrada.")


# Exemplo de uso
# mover_arquivos(identificador)
