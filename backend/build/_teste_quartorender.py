import os
import core

# TESTANDO A FUNÇÃO DE LER E ESCREVER DE backend.core.quartorender.py

if __name__ == "__main__":
    CAMINHOS = {
        "lista_books": os.path.normpath("./data/books/books.json"),
        "dir_base": os.path.abspath(os.path.join(os.path.dirname(__file__), "./../")).replace("\\", "/"),
        "dir_include": os.path.normpath("./books/build/include/include-in-head.html"),
    }
    for key, value in CAMINHOS.items():
        value = os.path.join("./", value.replace("\\", "/"))
        if key == "lista_books":
            conteudo = conteudo = core.ler(path=value)
            resp = core.escrever(path=value, conteudo=conteudo)
            if resp is True:
                print(f"Arquivo {value} escrito com sucesso!")
        else:
           #==> Esperasse o erro: PermissionError por não ser link para um arquivo.
            conteudo = core.ler(path=value)
            print(core.escrever(path=value, conteudo=conteudo))    
    print("Fim da execução do script!")
