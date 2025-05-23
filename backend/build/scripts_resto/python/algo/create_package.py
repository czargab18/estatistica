import re
import os


def adicionar_init_py(diretorio):
    for root, dirs, files in os.walk(diretorio):
        # Ignora subpastas chamadas "data"
        dirs[:] = [d for d in dirs if d != 'data']

        # Adiciona __init__.py em cada diretório
        init_path = os.path.join(root, '__init__.py')
        if not os.path.exists(init_path):
            with open(init_path, 'w') as f:
                pass
            print(f"Adicionado: {init_path}")


# # Caminho para a pasta 'python'
# diretorio_python = './python'

# # Executa a função para adicionar __init__.py
# adicionar_init_py(diretorio_python)


def buscar_dependencias(diretorio):
    dependencias = set()
    pattern = re.compile(r'^\s*import\s+(\S+)|^\s*from\s+(\S+)\s+import\s+')

    for root, _, files in os.walk(diretorio):
        for file in files:
            if file.endswith('.py'):
                with open(os.path.join(root, file), 'r', encoding='utf-8') as f:
                    for line in f:
                        match = pattern.match(line)
                        if match:
                            module = match.group(1) or match.group(2)
                            if module:
                                dependencias.add(module.split('.')[0])

    return dependencias


# Caminho para a pasta 'utilitarios'
diretorio_utilitarios = './utilitarios'

# Busca as dependências
dependencias = buscar_dependencias(diretorio_utilitarios)

# Lista de dependências que precisam ser instaladas via pip
pip_dependencias = [
    "bs4",
    "requests",
    "google-api-python-client",
    "google-auth-oauthlib",
    "google-auth-httplib2",
    "yt-dlp",
    "reportlab",
    "PyMuPDF",
    "Pillow",
    "PyPDF2",
    "python-dateutil"
]

# Filtra as dependências que não são da biblioteca padrão
dependencias_instalaveis = [
    dep for dep in dependencias if dep in pip_dependencias]

print("Dependências encontradas:")
for dep in dependencias_instalaveis:
    print(dep)
