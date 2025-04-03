import os


def createdir():
    # Diretórios a serem criados
    directories = ["eventos/sem", "eventos/data", "eventos/com"]

    # Arquivos a serem criados
    files = [
        "eventos/sem/index.html",
        "eventos/data/eventos.json",
        "eventos/com/index.html",
    ]

    # Criar diretórios
    for indice in directories:
        os.makedirs(indice, exist_ok=True)

    # Criar arquivos
    for indice in files:
        with open(indice, "w") as f:
            pass

    print("Estrutura do projeto criada com sucesso!")

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


# Exemplo de uso:
if __name__ == "__main__":
    caminho = "./"  # Caminho do diretório a ser listado
    output_file_path = "core/dir/directory_structure.txt"  # Arquivo de saída (opcional)
    listdir(caminho, output_file_path)
