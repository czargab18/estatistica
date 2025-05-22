# Função que pega o caminhos dos arquivos em /ac/ e suas subpastas


def getpaths(directory):
    file_paths = []
    # Verifica se o diretório existe
    if not os.path.exists(directory):
        print(f"Diretório '{directory}' não encontrado.")
        return file_paths
    for root, _, files in os.walk(directory):
        for file in files:
            file_paths.append(os.path.join(root, file))
    return file_paths


# Use um caminho absoluto ou ajuste para o caminho correto
directory = "/ac/"  # Ajusta para o caminho absoluto
print(getpaths(directory))
