"""
 * Scripts
 * Scripts
 * Scripts
"""
import os
import re
import json

def folders(path="./"):
    """
    Lista as pastas do tipo: '3 lestras e 4 numéros'
    Ignora pastas na raiz do repositório: /ac/ ou /wss/ .
    - return: Dicionário
        - formato: { "pastaPai": [ "path-arquivo1", "path-arquivo2" ] }
    """
    padrao_pasta = re.compile(r'^[A-Z]{3}\d{4}$')
    caminhos_arquivos = {}

    # Itera apenas sobre as pastas na raiz do diretório especificado
    for pasta in next(os.walk(path))[1]:
        if padrao_pasta.match(pasta):
            caminho_pasta = os.path.join(path, pasta)
            caminhos_arquivos[pasta] = []
            for subroot, subpastas, subarquivos in os.walk(caminho_pasta):
                # Ignora subpastas como /ac/ ou /wss/
                subpastas_filtradas = []
                for subpasta in subpastas:
                    if subpasta not in ['ac', 'wss', 'book', '.quarto']:
                        subpastas_filtradas.append(subpasta)
                subpastas[:] = subpastas_filtradas

                for arquivo in subarquivos:
                    caminho_relativo = os.path.relpath(
                        os.path.join(subroot, arquivo), path)
                    caminho_relativo = caminho_relativo.replace("\\", "/")
                    caminho_completo = f"/books/{caminho_relativo}"
                    caminhos_arquivos[pasta].append(caminho_completo)

    # Cria o diretório se ele não existir
    os.makedirs('.automacao/', exist_ok=True)

    # Salva o dicionário em um arquivo JSON
    with open('./.automacao/books.json', 'w', encoding='utf-8') as f:
        json.dump(caminhos_arquivos, f, ensure_ascii=False, indent=4)

    return caminhos_arquivos

# Função para substituir o padrão nos arquivos
def substituir_padrao(diretorio=None, padroes=None, fun=False):
    """
    Substitui padrões especificados em arquivos de texto dentro de um diretório e suas subpastas.
    """
    # Atualizar books.json antes da execução.
    if fun:
        folders()
    
    # Substituir os padrões
    for root, _, arquivos in os.walk(diretorio):
        for arquivo in arquivos:
            caminho_arquivo = os.path.join(root, arquivo)
            if caminho_arquivo.endswith((".html", ".css", ".js", ".txt")):
                try:
                    with open(caminho_arquivo, "r", encoding="utf-8") as file:
                        conteudo = file.read()
                    novo_conteudo = conteudo
                    for padrao, correcao in padroes:
                        # Verifica se o arquivo está em uma subpasta chamada /conteudo/
                        if '/conteudo/' in caminho_arquivo:
                            # Obtém o nome da pasta pai
                            pasta_pai = os.path.basename(os.path.dirname(os.path.dirname(caminho_arquivo)))
                            # Define o novo padrão de substituição
                            correcao = f'/books/{pasta_pai}/conteudo/'
                        novo_conteudo = re.sub(padrao, correcao, novo_conteudo)
                    if conteudo != novo_conteudo:
                        with open(caminho_arquivo, "w", encoding="utf-8") as file:
                            file.write(novo_conteudo)
                        print(f"Atualizado: {caminho_arquivo}")
                except IOError as e:
                    print(f"Erro ao processar {caminho_arquivo}: {e}")

def decisao_g_ou_l(diretorio="./"):
    """
    Pergunta ao usuário se a substituição deve ser feita localmente ou para GitHub Pages.
    Define uma lista de padrões e substituições com base na resposta do usuário.
    Chama a função substituir_padrao para aplicar as substituições nos arquivos dentro do diretório especificado.
    """
    pergunta = input("Corrigir Local para Pages? (l/g): ").lower().strip()
    if pergunta in ["\\n", "github", "g", "github-pages", "gp", "pages", "p"]:
        padroes = [
            (r'src="\.\./', 'src="/books/'),
            (r'src="\./', 'src="/books/'), 
            (r'href="\.\./', 'href="/books/'),  
            (r'href="\./', 'href="/books/'),  
        ]
        for padrao, correcao in padroes:
            substituir_padrao(diretorio, [(padrao, correcao)], fun = False)
        # Tratar erros do tipo: '/books//books/' quando houver padrão: './../'
        tratar = [
            (r'href="/books//books/', 'href="/books/'),
            (r'href="/books/+(\.\./)', 'src="/books/'),
            (r'href="/books/+(\.\./)+(\.\./)', 'src="/books/'),
            (r'src="/books//books/', 'src="/books/'),
            (r'src="/books/+(\.\./)', 'src="/books/'),
            (r'src="/books/+(\.\./)+(\.\./)', 'src="/books/'),
        ]
        for padrao, correcao in tratar:
            substituir_padrao(diretorio, [(padrao, correcao)], fun = False)
    else:
        padroes = [
            (r'(src="|href=")/books/', '/'),
            (r'(src="|href=")/books/', './'),
            (r'(src="|href=")/books/ac/site_libs/', '/ac/site_libs/'),
            (r'(src="|href=")+(/books/)', '/books/'),
        ]
        for padrao, correcao in padroes:
            substituir_padrao(diretorio, [(padrao, correcao)], fun = False)
        padroes = [
            (r'(/books/)+', '/books/'),
        ]
        for padrao, correcao in padroes:
            substituir_padrao(diretorio, [(padrao, correcao)], fun = False)

def decisao(diretorio="./"):
    """
    Pergunta ao usuário se a substituição deve ser feita localmente ou para GitHub Pages.
    Define uma lista de padrões e substituições com base na resposta do usuário.
    Chama a função substituir_padrao para aplicar as substituições nos arquivos dentro do diretório especificado.
    """
    padroes = [
        (r'src="\.\./', 'src="/books/'),
        (r'src="\./', 'src="/books/'),
        (r'href="\.\./', 'href="/books/'),
        (r'href="\./', 'href="/books/'),
    ]
    for padrao, correcao in padroes:
        substituir_padrao(diretorio, [(padrao, correcao)], fun = False)
    tratar = [
        (r'href="/books//books/', 'href="/books/'),
        (r'href="/books/\.\./', 'src="/books/'),
        (r'href="/books/\.\./\.\./', 'src="/books/'),
        (r'src="/books//books/', 'src="/books/'),
        (r'src="/books/\.\./', 'src="/books/'),
        (r'src="/books/\.\./\.\./', 'src="/books/'),
    ]
    for padrao, correcao in tratar:
        substituir_padrao(diretorio, [(padrao, correcao)], fun = False)
            
## ==> Teste <== ###

# decisao()



import os
import shutil
import re

class GerenciadorDisciplinas:
    def __init__(self):
        pass

    @staticmethod
    def criar_estrutura(disciplina="padrao"):
        """
        Criar a estrutura do repositório.
        """
        name = re.sub(r'[<>:"/\\|?*]', '', disciplina)
        dirs = [
            f"{name}/Estudos/conteúdos/bibliografia",
            f"{name}/Estudos/conteúdos/teoria-leve",
            f"{name}/Estudos/conteúdos/teoria-avançada",
        ]

        if os.path.exists(disciplina):
            print(f"O diretório '{disciplina}' já existe.")
            return

        for dir in dirs:
            os.makedirs(dir, exist_ok=True)
            # Cria um arquivo vazio em cada subpasta
            with open(os.path.join(dir, "README.md"), 'w') as f:
                f.write(f"# {os.path.basename(dir)}\n")

        print(f"Estrutura de diretórios para '{disciplina}' criada com sucesso!")

    @staticmethod
    def deletar_estrutura(disciplinas):
        for disciplina in disciplinas:
            if os.path.exists(disciplina):
                shutil.rmtree(disciplina)
                print(f"Estrutura de diretórios para '{disciplina}' deletada com sucesso!")
            else:
                print(f"O diretório '{disciplina}' não existe.")

    @staticmethod
    def executar():
        acao = input("Digite 'c' para criar uma disciplina ou 'd' para deletar uma disciplina: ").strip().lower()

        if acao in ['c', 'criar', 'create']:
            disciplinas_input = input("Digite os nomes das disciplinas separados por vírgula (ex: disciplina-01,disciplina-02): ")
            if not disciplinas_input.strip():
                criar_padrao = input("Nenhuma disciplina foi digitada. Deseja criar a disciplina padrão 'disciplina-01'? (s/n): ").strip().lower()
                if criar_padrao in ['s', 'sim']:
                    GerenciadorDisciplinas.criar_estrutura("disciplina-01")
                else:
                    print("Nenhuma disciplina foi criada.")
            else:
                disciplinas = [disciplina.strip() for disciplina in disciplinas_input.split(",")]
                for disciplina in disciplinas:
                    GerenciadorDisciplinas.criar_estrutura(disciplina)

        elif acao in ['d', 'deletar', 'delete']:
            disciplinas_input = input("Digite os nomes das disciplinas a serem deletadas separados por vírgula (ex: disciplina-01,disciplina-02): ")
            if not disciplinas_input.strip():
                print("Nenhuma disciplina foi digitada. Por favor, digite pelo menos uma disciplina.")
            else:
                disciplinas = [disciplina.strip() for disciplina in disciplinas_input.split(",")]
                confirmar = input(f"Tem certeza que deseja deletar as disciplinas: {', '.join(disciplinas)}? (s/n): ").strip().lower()
                if confirmar in ['s', 'sim']:
                    GerenciadorDisciplinas.deletar_estrutura(disciplinas)
                else:
                    print("Nenhuma disciplina foi deletada.")

        else:
            print("Ação inválida. Por favor, digite 'c' para criar ou 'd' para deletar.")
