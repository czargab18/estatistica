import os
import re

"""Renomear pastas do repositório"""

DIRETORIO = ["./", "./ac/"]
PADRAO = [r"global"]

# Função para achar, listar e encontrar as pastas com o padrão desejado
def renomear(sedir:bool = True, padrao:list = PADRAO, diretorio:list = DIRETORIO):
    if sedir is True:
        for diretorios in diretorio:
            for root, dirs, files in os.walk(diretorios):
                for dir_name in dirs:
                    if any(re.search(p, dir_name) for p in padrao):
                        novo_nome = f"novo_{dir_name}"
                        os.rename(
                            os.path.join(root, dir_name), os.path.join(root, novo_nome)
                        )
                        print(f"Renomeado: {dir_name} para {novo_nome}")
    else:
      for diretorios in diretorio:
          for root, dirs, files in os.walk(diretorios):
              for dir_name in dirs:
                  if any(re.search(p, dir_name) for p in padrao):
                      novo_nome = f"novo_{dir_name}"
                      os.rename(
                          os.path.join(root, dir_name), os.path.join(
                              root, novo_nome)
                      )
                      print(f"Renomeado: {dir_name} para {novo_nome}")
      return ..., sedir, padrao, diretorio

# Exemplo de uso
if __name__ == "__main__":
    renomear()
