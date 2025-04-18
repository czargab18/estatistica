from core import *
import os
import shutil
import time


def test_createdir():
    struc = ["test/dir/1/file1.txt",
             "test/dir/3dir4/file3.txt", "test/dir/47/file.txt", "test/dir/47/"]
    createdir(structure=struc)

    # Verificar se os arquivos foram criados
    for path in struc:
        if not os.path.exists(path):
            print(f"Erro: {path} não foi criado.")
            return
    print("Todos os arquivos e diretórios foram criados com sucesso.")

    # Excluir os diretórios criados
    shutil.rmtree("test/dir/")
    print("Os diretórios criados foram excluídos com sucesso.")


if __name__ == "__main__":
    test_createdir()
