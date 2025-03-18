"""
Script que pergunta as informações do artigo
"""
from os import link
import resto_funcoes as rf
import manual


def pergunta(pergunta: str):
    """
    Função que pergunta as informações do artigo
    """
    resposta = input(f'{pergunta}? (s/n): ').lower().strip()
    return resposta

def main():
    """
    Função principal
    """
    # Meta Informações
    identificador = manual.identificador()
    titulo = pergunta(pergunta="Qual o título do artigo")
    subtitulo = pergunta(pergunta="Qual o subtítulo do artigo")
    autor = pergunta(pergunta="Qual o autor do artigo")
    data = pergunta(pergunta="Qual a data do artigo")
    descricao = pergunta(pergunta="Qual a descrição do artigo")
    keywords = pergunta(pergunta="Quais as palavras-chaves do artigo")
    tags = pergunta(pergunta="Quais as tags do artigo")
    categoria = pergunta(pergunta="Qual a categoria do artigo")
    disciplina = pergunta(pergunta="Qual a disciplina do artigo")

    # Introdução do Artigo
    secao = pergunta(pergunta="Quais as seções do artigo: (sep=' ')? ").lower().strip()
    resp_secao_valida = ["resumo", "introducao", "desenvolvimento",
              "conclusao", "referencias", "anexos"]
    
    for secao in resp_secao_valida:
        if secao is not resp_secao_valida:
           raise ValueError(
               f"Tipo inválido. Use um dos seguintes: {', '.join(resp_secao_valida)}")

    conteudo = {}
    for secao in resp_secao_valida:
        conteudo[secao] = []

    # CONTEÚDO DAS SEÇÕES DO ARTIGO
    for secao in resp_secao_valida:
        resposta = pergunta(
            pergunta=f"Deseja adicionar conteúdo a seção: {secao}? (s/n)"
            ).lower().strip()
        
        if resposta in ["s", "sim","y","yes"]:
            paragrafos = pergunta(
                pergunta=f"Quantos parágrafos tem a {secao} ?").strip()

            # TALVEZ SUBSTITUIR POR UM LOOP WHILE
            for paragrafo in range(1, int(paragrafos), 1):
                tipo = pergunta(pergunta="O parágrafo é texto, link ou figura?")
                if tipo in ["texto", "text","t"]:
                    paragrafo = pergunta(pergunta="Escreva o parágrafo: ")
                    
                elif tipo in ["link", "l"]:
                    paragrafo = pergunta(pergunta="O link é clicavél ou arquivo para download?: (c/d)")
                    if paragrafo in ["clicavel", "c","click"]:
                        pass    
                    else:
                        pass
                    pass
                
                elif tipo in ["figura", "figure", "f"]:
                    paragrafo = pergunta(pergunta="O parágrafo é uma figura?")
                    if paragrafo in ["sim", "s","y","yes"]:
                        pass
                    pass

    # Salvar o CONTEÚDO em um JSON
    artigo = {
        identificador: {
            "meta_info": {
                "date-title-article": titulo,
                "date-subtitle-article": subtitulo,
                "date-author-article": autor,
                "date-data-article": data,
                "date-description-article": descricao,
                "date-keywords-article": keywords,
                "date-category-article": categoria,
                "date-disciplina-article": disciplina,
                "tags": tags
                },
            "content_artigo": conteudo
        }
    }

    return artigo

# Usar outras funções para:
# - atualizar articles.json
# - criar o identificar automaticamente
# - mover os arquivos automaticamente


# restante:
# - criar automaticamente o index.js do artigo
