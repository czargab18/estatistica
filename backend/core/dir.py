import os

def createdir(structure: list = None):
    """
    Cria a estrutura de diretórios e arquivos especificada.
    :param structure: Lista contendo caminhos de diretórios e arquivos.
    * Observação:
     -  O cenário abaixo retorna o erro ao criar a pasta /dir/ mas cri 'dir' e 'dir.txt'.
        Exemplo:
            --------
            >>> paths= ["test/dir.txt", "test/dir", "test/dir/"]
            >>> createdir(structure=paths)
            >>> Erro ao tentar criar 'test/dir/': O caminho já existe e não pode ser sobrescrito.
    """
    for path in structure:
        try:
            normalized_path = f"\\\\?\\{os.path.abspath(path)}"
            if path.endswith("/"):
                os.makedirs(normalized_path, exist_ok=True)
            else: 
                os.makedirs(os.path.dirname(normalized_path), exist_ok=True)  # Cria os diretórios necessários
                with open(normalized_path, "w") as file:
                    pass 
        except FileExistsError as erro:
            print(f"Erro ao tentar criar '{path}': O caminho já existe e não pode ser sobrescrito.")
        except PermissionError as erro:
            print(f"Erro de permissão ao tentar criar '{path}': {erro}")
        except Exception as erro:
            print(f"Erro ao tentar criar '{path}': {erro}")


def listdir(folder: str = None, save: str = None):
    """
    Lista todos os diretórios e arquivos na pasta especificada, retornando caminhos completos.

    :param folder: Caminho do diretório a ser listado.
    :param save: Caminho do arquivo de saída para salvar a estrutura do diretório.
    :return: Lista com a estrutura do diretório no formato completo.
    """
    if not folder:
        raise ValueError("O parâmetro 'folder' precisa ser especificado.")

    if not os.path.exists(folder):
        raise FileNotFoundError(
            f"O diretório especificado '{folder}' não existe.")

    structure = []
    for root, dirs, files in os.walk(folder):
        for file in files:
            structure.append(os.path.join(root, file).replace("\\", "/"))
    if save:
        with open(save, 'w', encoding='utf-8') as file:
            file.write("\n".join(structure))
    return structure

