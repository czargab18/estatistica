import os
import shutil

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

def listdir(folder: str = None, save: str = None, ignore: list = None, ignoretype: list = None):
    """
    Lista todos os diretórios e arquivos na pasta especificada, retornando caminhos completos.

    :param folder: Caminho do diretório a ser listado.
    :param save: Caminho do arquivo de saída para salvar a estrutura do diretório.
    :ignore: Lista de arquivos ou diretórios a serem ignorados.
    :ignoretype: Lista de tipos de arquivos a serem ignorados.
    :return: Lista com a estrutura do diretório no formato completo.
    """
    if not folder:
        raise ValueError("O parâmetro 'folder' precisa ser especificado.")

    if not os.path.exists(folder):
        raise FileNotFoundError(
            f"O diretório especificado '{folder}' não existe.")

    structure = []
    for root, dirs, files in os.walk(folder):
        # Filtrar diretórios ignorados
        filtered_dirs = []
        for d in dirs:
            dir_path = os.path.join(root, d).replace("\\", "/")
            if not ignore or dir_path not in ignore:
                filtered_dirs.append(d)
        dirs[:] = filtered_dirs

        for file in files:
            filepath = os.path.join(root, file).replace("\\", "/")
            verificacao = (ignore and filepath in ignore) or (
                ignoretype and any(filepath.endswith(ext) for ext in ignoretype))
            if verificacao:
                continue
            structure.append(filepath)

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

def append(path, conteudo):
    """
    Adiciona conteúdo a um arquivo existente.

    Parâmetros:
    ----------
    path : str
        O caminho completo para o arquivo onde o conteúdo será adicionado.
    conteudo : str
        O conteúdo que será adicionado ao arquivo.

    Retorna:
    -------
    None
    """
    with open(path, "a", encoding="utf-8") as file:
        file.write(conteudo)
        return True

def delete(path):
    """
    Deleta um arquivo ou diretório.

    Parâmetros:
    ----------
    path : str
        O caminho completo para o arquivo ou diretório a ser deletado.

    Retorna:
    -------
    None

    Exceções:
    --------
    FileNotFoundError
        Se o arquivo ou diretório especificado no caminho não for encontrado.
    PermissionError
        Se não houver permissão para deletar o arquivo ou diretório.
    """
    if os.path.isfile(path):
        os.remove(path)
    elif os.path.isdir(path):
        os.rmdir(path)

    else:
        raise FileNotFoundError(f"O caminho '{path}' não existe ou não é um arquivo ou diretório válido.")

def rename(path, newname):
    """
    Renomeia um arquivo ou diretório.

    Parâmetros:
    ----------
    path : str
        O caminho completo para o arquivo ou diretório a ser renomeado.
    newname : str
        O novo nome para o arquivo ou diretório.

    Retorna:
    -------
    None

    Exceções:
    --------
    FileNotFoundError
        Se o arquivo ou diretório especificado no caminho não for encontrado.
    PermissionError
        Se não houver permissão para renomear o arquivo ou diretório.
    """
    os.rename(path, newname)

def copy(path, newpath):
    """
    Copia um arquivo ou diretório para um novo local.

    Parâmetros:
    ----------
    path : str
        O caminho completo para o arquivo ou diretório a ser copiado.
    newpath : str
        O novo caminho onde o arquivo ou diretório será copiado.

    Retorna:
    -------
    None

    Exceções:
    --------
    FileNotFoundError
        Se o arquivo ou diretório especificado no caminho não for encontrado.
    PermissionError
        Se não houver permissão para copiar o arquivo ou diretório.
    """
    if os.path.isfile(path):
        shutil.copy2(path, newpath)
    elif os.path.isdir(path):
        shutil.copytree(path, newpath)
    else:
        raise FileNotFoundError(f"O caminho '{path}' não existe ou não é um arquivo ou diretório válido.")
    return True

def move(path, newpath):
    """
    Move um arquivo ou diretório para um novo local.

    Parâmetros:
    ----------
    path : str
        O caminho completo para o arquivo ou diretório a ser movido.
    newpath : str
        O novo caminho onde o arquivo ou diretório será movido.

    Retorna:
    -------
    None

    Exceções:
    --------
    FileNotFoundError
        Se o arquivo ou diretório especificado no caminho não for encontrado.
    PermissionError
        Se não houver permissão para mover o arquivo ou diretório.
    """
    shutil.move(path, newpath)

def exists(path):
    """
    Verifica se um arquivo ou diretório existe.

    Parâmetros:
    ----------
    path : str
        O caminho completo para o arquivo ou diretório a ser verificado.

    Retorna:
    -------
    bool
        True se o arquivo ou diretório existir, False caso contrário.
    """
    return os.path.exists(path)

