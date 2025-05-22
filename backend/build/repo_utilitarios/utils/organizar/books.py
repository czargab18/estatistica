"""
Função 1:
* Captura o nome das pastas do repositório atual e retorna um JSON com os nomes.
* Padrão das pastas:
    - Estão em maiúscula.
    - Seguem o padrão: 3 letras e 4 números.

Função 2:
* Modifica os links-path HTML, CSS e JS gerados pelo Book-Quarto.
* Exemplo: de './../../EST0033/' para '/EST0033/'.
"""
import os
import re
import json


def list_name_books(base_path="books/"):
    """
    Captura o nome das pastas do repositório atual e salva um JSON com o nome delas.

    Args:
        base_path (str): Caminho base para a pasta que deseja vasculhar.

    Returns:
        None
    """
    padrao_pasta = re.compile(r'^[A-Z]{3}\d{4}$')
    pastas = []
    for d in os.listdir(base_path):
        if os.path.isdir(os.path.join(base_path, d)) and padrao_pasta.match(d):
            pastas.append(d)
    json_data = json.dumps(pastas, indent=4)
    
    # Caminho para salvar o JSON
    json_path = os.path.join(base_path, '.automacao', 'books.json')
    os.makedirs(os.path.dirname(json_path), exist_ok=True)
    
    with open(json_path, 'w', encoding='utf-8') as json_file:
        json_file.write(json_data)
    
    print(f"JSON salvo em: {json_path}")


def corrigir_path(base_path="bookks/", restricao_path="books/book/"):
    """
    Modifica os links-path HTML, CSS e JS gerados pelo Book-Quarto.

    Args:
        base_path (str): Caminho base para a pasta que deseja vasculhar.
        restricao_path (str): Caminho da pasta que não deve ser acessada.

    Returns:
        None
    """
    arquivos_modificados = []
    padrao = re.compile(r'(\./|\.\./|\./\.\./)+')

    for root, dirs, files in os.walk(base_path):
        # Remover diretórios que correspondem à restrição
        dirs_filtrados = []
        for d in dirs:
            if restricao_path not in os.path.join(root, d):
                dirs_filtrados.append(d)
        dirs[:] = dirs_filtrados

        for file in files:
            if file.endswith(('.html', '.css', '.js')):
                caminho_arquivo = os.path.join(root, file)
                with open(caminho_arquivo, 'r', encoding='utf-8') as f:
                    conteudo = f.read()
                conteudo_modificado = padrao.sub('/', conteudo)
                with open(caminho_arquivo, 'w', encoding='utf-8') as f:
                    f.write(conteudo_modificado)
                arquivos_modificados.append(caminho_arquivo)
    for arquivo in arquivos_modificados:
        print(f"Arquivo modificado: {arquivo}")
    return None


def corrigir_links_conteudo():
    """
      * Destinado a corrigir os links dos paths:
      * Exemplo: de "conteudo/* => /<book_name>/conteúdo/*
    """
    # Carregar o arquivo books.json
    with open('books.json', 'r', encoding='utf-8') as f:
        books = json.load(f)
    
    # Para cada livro, acessar a pasta /conteudo/
    for book in books:
        conteudo_path = os.path.join(book, 'conteudo')
        
        # Verificar se a pasta /conteudo/ existe
        if os.path.exists(conteudo_path):
            # Percorrer todos os arquivos na pasta /conteudo/
            for root, dirs, files in os.walk(conteudo_path):
                for file in files:
                    if file.endswith('.html'):
                        file_path = os.path.join(root, file)
                        
                        # Ler o conteúdo do arquivo HTML
                        with open(file_path, 'r', encoding='utf-8') as f:
                            content = f.read()
                        
                        # Modificar os links HTML que seguem o padrão especificado
                        new_content = re.sub(r'(?<=href="|src=")/conteudo/', f'/{book}/conteúdo/', content)
                        
                        # Escrever o conteúdo modificado de volta no arquivo HTML
                        with open(file_path, 'w', encoding='utf-8') as f:
                            f.write(new_content)

def main():
    pular_perguntas = input("Deseja pular todas as perguntas? (s/n): ").strip().lower()
    
    if pular_perguntas == 's':
        # Executar todas as funções diretamente
        corrigir_links_conteudo()
    else:
        # Perguntar se deseja rodar a função corrigir_path
        rodar = input("Deseja rodar a função corrigir_path? (s/n): ").strip().lower()
        if rodar == 's':
            usar_books_json = input("Deseja usar as pastas capturadas em books.json? (s/n): ").strip().lower()
            if usar_books_json == 's':
                corrigir_links_conteudo()
            else:
                print("A função não foi executada.")
        else:
            print("A função não foi executada.")

if __name__ == "__main__":
    main()
