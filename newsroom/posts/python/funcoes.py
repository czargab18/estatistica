import os
path = "posts/article/*.txt"
path = "posts/article/imgs-*"

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

def existe_files_in_article(folder="article"):
    """
    Função que verifica se a pasta desejada existe.
     - folder: str, nome da pasta a ser verificada. Padrão: 'article'
    """
    pergunta = input(f"A pasta {folder} existe? Digite Sim ou Não: ").lower()
    resposta = verificacao(pergunta)
    return resposta

def ler_nome_arquivo(path="path"):
    """
  Função que retorna apenas o nome do arquivo, sem a extensão, a partir do caminho fornecido.
  """
    nome_arquivo = os.path.splitext(os.path.basename(path))
    return nome_arquivo[0]

def ler_conteudo_arquivo(path="path"):
    """
    Função que lê o arquivo e retorna o conteúdo do arquivo como uma string.
     - path: str, nome do arquivo a ser lido.
    """
    try:
        with open(path, "r") as arquivo:
            return arquivo.read()
    except FileNotFoundError:
        print(f"Erro: O arquivo '{path}' não foi encontrado.")
        return None

def ler_path_imgs_in_article(path="path"):
    """
    Função que lê o arquivo e retorna o conteúdo do arquivo como uma string.
    """
    padrao_src = ""

def verificar_arquivo_txt(path="posts/article/"):
    """
    Função que verifica se um arquivo .txt existe no caminho fornecido e retorna o nome do arquivo e o caminho completo.
    """
    

def verificar_pasta_imgs(path="posts/article/imgs-e-formulas"):
    """
    Função que verifica se uma pasta imgs-e-formulas existe no caminho fornecido.
    """
    
