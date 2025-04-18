import os

def createdir(structure: list = None):
    """
    Cria a estrutura de diretórios e arquivos especificada.

    :param structure: Lista contendo caminhos de diretórios e arquivos.
    """
    for path in structure:
        try:
            normalized_path = f"\\\\?\\{os.path.abspath(path)}"
            if path.endswith("/"):  # Verifica se é um diretório
                os.makedirs(normalized_path, exist_ok=True)
            else:  # Caso contrário, é um arquivo
                os.makedirs(os.path.dirname(normalized_path), exist_ok=True)  # Cria os diretórios necessários
                with open(normalized_path, "w") as file:
                    pass  # Cria o arquivo vazio
        except FileExistsError as erro:
            print(f"Erro ao tentar criar '{path}': O caminho já existe e não pode ser sobrescrito.")
        except PermissionError as erro:
            print(f"Erro de permissão ao tentar criar '{path}': {erro}")
        except Exception as erro:
            print(f"Erro ao tentar criar '{path}': {erro}")
