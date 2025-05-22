import os

def findel(origem, deletar):
    """
    Localiza arquivos ou pastas para exclusão.

    :param origem: Caminho base para iniciar a busca.
    :param deletar: Lista de nomes de arquivos ou pastas a serem localizados.
    :return: Lista de caminhos completos dos itens encontrados.
    """
    found_items = []
    for root, dirs, files in os.walk(origem):
        for item in deletar:
            if item in files or item in dirs:
                found_items.append(os.path.join(root, item))
    return found_items

if __name__ == "__main__":
    origem = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
    deletar = ['search.json', 'example_folder'] 
    found_items = findel(origem, deletar)
    if found_items:
        print("Itens encontrados para exclusão:")
        for item in found_items:
            print(item)
    else:
        print("Nenhum item encontrado para exclusão.")
