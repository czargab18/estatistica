import os

# Função para renomear os arquivos
def renomear_arquivos_no_diretorio(diretorio):
    # Percorre todos os arquivos e subdiretórios
    for pasta_atual, subpastas, arquivos in os.walk(diretorio):
        for arquivo in arquivos:
            # Obtém o caminho completo do arquivo
            caminho_antigo = os.path.join(pasta_atual, arquivo)
            
            # Divide o nome do arquivo e a extensão
            nome, extensao = os.path.splitext(arquivo)
            
            # Verifica se o nome do arquivo contém hífens, e os substitui por sublinhados
            novo_nome = nome.replace('-', '_').lower() + extensao
            
            # Cria o caminho do novo arquivo
            caminho_novo = os.path.join(pasta_atual, novo_nome)
            
            # Renomeia o arquivo
            if caminho_antigo != caminho_novo:
                os.rename(caminho_antigo, caminho_novo)
                print(f'Renomeado: {caminho_antigo} -> {caminho_novo}')

# Diretório principal onde começa a busca
diretorio_inicial = '.'  # Altere para o diretório desejado

# Chama a função para percorrer as pastas e renomear os arquivos
renomear_arquivos_no_diretorio(diretorio_inicial)


# Função para renomear os arquivos
def renomear_arquivos_no_diretorio(diretorio):
    # Percorre todos os arquivos e subdiretórios
    for pasta_atual, subpastas, arquivos in os.walk(diretorio):
        for arquivo in arquivos:
            # Obtém o caminho completo do arquivo
            caminho_antigo = os.path.join(pasta_atual, arquivo)
            
            # Divide o nome do arquivo e a extensão
            nome, extensao = os.path.splitext(arquivo)
            
            # Verifica se o nome do arquivo contém hífens, e os substitui por sublinhados
            novo_nome = nome.replace('-', '_').lower() + extensao
            
            # Cria o caminho do novo arquivo
            caminho_novo = os.path.join(pasta_atual, novo_nome)
            
            # Renomeia o arquivo, se necessário
            if caminho_antigo != caminho_novo:
                os.rename(caminho_antigo, caminho_novo)
                print(f'Renomeado: {caminho_antigo} -> {caminho_novo}')

# Diretório principal onde começa a busca
diretorio_inicial = '.'  # Altere para o diretório desejado

# Chama a função para percorrer as pastas e renomear os arquivos
renomear_arquivos_no_diretorio(diretorio_inicial)
