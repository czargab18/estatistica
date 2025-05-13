import os


def create_project_structure():
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
create_project_structure()
