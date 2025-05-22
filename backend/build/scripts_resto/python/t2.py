import os
import csv
import json
import pandas as pd
from PyPDF2 import PdfReader


def read_file_content(file_path):
    if not os.path.exists(file_path):
        return f"Erro: Arquivo '{file_path}' não encontrado."

    _, file_extension = os.path.splitext(file_path)

    if file_extension == '.txt':
        with open(file_path, 'r', encoding='utf-8') as file:
            return file.read()
    elif file_extension == '.csv':
        with open(file_path, 'r', encoding='utf-8') as file:
            reader = csv.reader(file)
            return [row for row in reader]
    elif file_extension in ['.xls', '.xlsx']:
        return pd.read_excel(file_path).to_dict(orient='records')
    elif file_extension == '.pdf':
        pdf_reader = PdfReader(file_path)
        return '\n'.join([page.extract_text() for page in pdf_reader.pages])
    elif file_extension == '.json':
        with open(file_path, 'r', encoding='utf-8') as file:
            return json.load(file)
    else:
        return f"Formato de arquivo '{file_extension}' não suportado."


# # Exemplo de uso:
# caminhos = [
#     "backend/data/books/books.json",       # Arquivo JSON
#     "backend/data/books/fluxograma.pdf",  # Arquivo PDF
#     "backend/data/sample.csv",            # Arquivo CSV
#     "backend/data/sample.xlsx"            # Arquivo Excel
# ]

# for caminho in caminhos:
#     path = os.path.join(caminho)
#     print(read_file_content(path))
