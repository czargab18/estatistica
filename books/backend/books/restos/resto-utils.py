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