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


def ler(path: str = None):
    """
    Lê o conteúdo de um arquivo no caminho especificado.

    Parâmetros:
    ----------
    path : str
        O caminho completo para o arquivo que será lido.
    tipefile : list, opcional
        Uma lista de tipos de arquivos suportados (não utilizado atualmente na lógica).

    Retorna:
    -------
    str
        O conteúdo do arquivo como uma string, caso seja um arquivo de texto.

    Exceções:
    --------
    FileNotFoundError
        Se o arquivo especificado no caminho não for encontrado.
    UnicodeDecodeError
        Se o arquivo não puder ser decodificado como UTF-8.

    Exemplo:
    --------
    >>> content = ler("caminho/para/arquivo.txt")
    >>> print(content)
    """
    with open(path, "r", encoding="utf-8") as file:
        return file.read()


def escrever(path, conteudo):
    """
    Escreve conteúdo em um arquivo.

    Parâmetros:
    ----------
    path : str
        O caminho completo para o arquivo onde o conteúdo será escrito.
    conteudo : str
        O conteúdo que será escrito no arquivo.

    Retorna:
    -------
    None
    """
    with open(path, "w", encoding="utf-8") as file:
        file.write(conteudo)
        return True
