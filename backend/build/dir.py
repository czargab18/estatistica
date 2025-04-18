import os
import core

def listdir(folder: str = None, save: str = None):
    """
    Lista todos os diretórios e arquivos na pasta especificada, retornando caminhos completos.

    :param folder: Caminho do diretório a ser listado.
    :param save: Caminho do arquivo de saída para salvar a estrutura do diretório.
    :return: Lista com a estrutura do diretório no formato completo.
    """
    if not folder:
        raise ValueError("O parâmetro 'folder' precisa ser especificado.")

    structure = []

    # Percorre os arquivos e diretórios
    for root, dirs, files in os.walk(folder):
        for direrc in dirs:
            structure.append(os.path.join(root, direrc).replace("\\", "/"))
        for file in files:
            structure.append(os.path.join(root, file).replace("\\", "/"))

    # Salva a estrutura em um arquivo, se especificado
    if save:
        with open(save, 'w', encoding='utf-8') as file:
            file.write("\n".join(structure))

    return structure

if __name__ == "__main__":
    # Corrigido para criar diretórios e arquivos separadamente
    paths = [
        "test/dir.txt",  # Arquivo
        "test/dir",      # Arquivo
        "test/dir/"      # Diretório (conflito com o caminho anterior)
    ]

    # Cria a estrutura de diretórios e arquivos
    core.createdir(paths)

    # Explicação sobre o erro
    print("\nNota: Apenas o último caminho ('test/dir/') não é criado devido ao conflito com 'test/dir'.")

    # Lista a estrutura de um diretório e salva em um arquivo
    estrutura = listdir(folder="test/dir", save="estrutura.txt")

    # Apenas retorna a estrutura sem salvar
    estrutura = listdir(folder="test/dir")


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
