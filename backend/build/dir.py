import os


def createdir(structure: list = None):
    for path in structure:
        dir_path = os.path.dirname(path)
        os.makedirs(dir_path, existindo=True)
        with open(path, "w") as file: 
            pass

# Executar a função
# createdir()

def listdir(caminho: str = "./", output_file: str = None):
    """
    Lista todos os arquivos e diretórios em um caminho especificado e salva a estrutura em um arquivo, se fornecido.

    :param caminho: Caminho do diretório a ser listado.
    :param output_file: Caminho do arquivo de saída para salvar a estrutura do diretório.
    """
    try:
        # Verifica se o caminho existe
        if not os.path.exists(caminho):
            raise FileNotFoundError(f"O caminho '{caminho}' não existe.")

        # Abre o arquivo de saída, se especificado
        with open(output_file, 'w', encoding='utf-8') if output_file else None as f:
            # Lista todos os arquivos e diretórios
            for dirpath, dirnames, filenames in os.walk(caminho):
                level = dirpath.replace(caminho, '').count(os.sep)
                indent = '    ' * level
                dir_line = f"{indent}{os.path.basename(dirpath)}/"
                print(dir_line)
                if f:
                    f.write(dir_line + "\n")
                sub_indent = '    ' * (level + 1)
                for filename in filenames:
                    file_line = f"{sub_indent}{filename}"
                    print(file_line)
                    if f:
                        f.write(file_line + "\n")

    except Exception as e:
        print(f"Erro: {e}")


def list_caminhos(caminho):
    """
    Lista os caminhos completos de todos os arquivos em uma pasta e suas subpastas.

    :param caminho: Caminho da pasta onde os arquivos serão listados.
    :return: Lista de caminhos completos dos arquivos.
    """
    if not os.path.exists(caminho):
        return []

    caminhos_completos = []
    for raiz, subpastas, arquivos in os.walk(caminho):
        for arquivo in arquivos:
            caminho_completo = os.path.join(raiz, arquivo).replace("\\", "/")
            caminhos_completos.append(caminho_completo)
    return caminhos_completos


# if __name__ == "__main__":
#     caminho = r"ac/books"
#     paths = list_caminhos(caminho)
#     for path in paths:
#         print(path)
#     # output_file_path = "./directory_structure.txt"
#     # listdir(caminho, output_file_path)
