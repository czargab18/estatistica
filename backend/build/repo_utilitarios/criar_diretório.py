"""
Este script cria a estrutura do diretório
"""

import os

def create_project_structure():
    # Diretórios a serem criados
    directories = ["data", "docs", "scripts/R", "scripts/python", "tests"]
    # Arquivos a serem criados
    files = [
        "data/base_completa.xlsx",
        "docs/README.md",
        "docs/resultados.html",
        "docs/resultados.Rmd",
        "scripts/R/scripts.R",
        "scripts/python/scripts.py",
        "tests/scripts.R",
        "tests/scripts.py",
        "tests/teste_funcao.Rmd",
        ".Rhistory",
    ]
    # Criar diretórios
    for directory in directories:
        os.makedirs(directory, exist_ok=True)
    # Criar arquivos
    for file in files:
        with open(file, "w") as f:
            pass
    print("Estrutura do projeto criada com sucesso!")

# Executar a função
create_project_structure()
