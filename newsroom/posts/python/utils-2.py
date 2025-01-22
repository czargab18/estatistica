""" FUNÇÃO RECEBER DADOS ITERAÇÃO """

""" ADICIONAR DADOS AO index.html """

""" MANIPULAR DADOS DO article.json """
# Script iegativo que pergunta as informações do artigo


def meta_informacao():
    """
    Qual o título ?
    Qual o subtítulo?
    Quais as tags?
    """
    titulo = str(input("Forneça o título: ")).strip().lower()
    subtitulo = str(input("Forneça o subtítulo: ")).strip().lower()
    tags = (
        str(input("Forneça as tags separadas por vírgulas: "))
        .strip()
        .lower()
        .split(",")
    )
    return {"titulo": titulo, "subtitulo": subtitulo, "tags": tags}


""" TESTE """
## print(meta_informacao())

def conteudo_introducao():
    """
  Tem introdução?
  - quantos parágrafos?
  - parágrafo ou figure?
   - se link: imagem ou arquivo para download?
  - quer escrever um parágrafo ou um ahref?
  Terminou introdução?
  """
    resposta = str(input("Forneça o título: ")).strip().lower()
    if resposta in  ["sim","s","y","yes"]:
      ...
    if resposta not in ["sim","s","y","yes"]:
      ...
    else:
      return "Introdução sem conteúdo"


# Tem desenvolvimento?
# Quantos parágrafos?
# ....

# Tem rodapé?
# - parágrafo, link, figure
# ...
# - se link: link referência ou download

# Usar outras funções para:
# - atualizar articles.json
# - criar o identificar automaticamente
# - criar automaticamente o index.js do artigo
# - mover os arquivos automaticamente
