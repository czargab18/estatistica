import os

def listar_arquivos_com_barras(diretorio_base):
    """
    Vasculha todos os arquivos em subpastas de um diretório e imprime seus caminhos com barras "/".

    Args:
        diretorio_base (str): Caminho da pasta base.
    """
    for root, _, arquivos in os.walk(diretorio_base):
        for arquivo in arquivos:
            # Converte o caminho para usar barras "/"
            caminho_completo = os.path.join(root, arquivo).replace("\\", "/")
            print(caminho_completo)

# Exemplo de uso
diretorio = "./ac/books/"
listar_arquivos_com_barras(diretorio)