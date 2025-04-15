import os


def listar_caminhos_de_arquivos(caminho_pasta):
    """
    Lista os caminhos completos de todos os arquivos em uma pasta e suas subpastas.

    :param caminho_pasta: Caminho da pasta onde os arquivos serão listados.
    """
    if not os.path.exists(caminho_pasta):
        print(f"A pasta '{caminho_pasta}' não existe.")
        return

    print(
        f"Listando caminhos dos arquivos na pasta e subpastas: {caminho_pasta}\n")
    for raiz, subpastas, arquivos in os.walk(caminho_pasta):
        for arquivo in arquivos:
            caminho_completo = os.path.join(raiz, arquivo)
            print(caminho_completo)


# Exemplo de uso
caminho_da_pasta = r"ac/books"
listar_caminhos_de_arquivos(caminho_da_pasta)
