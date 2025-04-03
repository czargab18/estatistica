import os
import re
import json
from core import *

def corrigirSearchJson():
    """
    Corrige os caminhos duplicados no arquivo SEARCH.JSON
    """
    listabooks = listabooks()
    for book in listabooks:
        # path = f'./books/{book}/search.json'
        path = f'./automacao/restos/{book}/search.json'
        if os.path.exists(path):
            with open(path, 'r', encoding='utf-8') as file:
                data = json.load(file)
            padrao = re.compile(rf'(/books/{book}/)(books/{book}/)+')
            for item in data:
                for key in ['objectID', 'href']:
                    if key in item:
                        previous_value = None
                        while item[key] != previous_value:
                            previous_value = item[key]
                            item[key] = re.sub(padrao, r'\1', item[key])
                            item[key] = re.sub(r'//+', '/', item[key])
            with open(path, 'w', encoding='utf-8') as file:
                json.dump(data, file, indent=4, ensure_ascii=False)
        else:
            print(f"Arquivo não encontrado: {path}")


# Exemplo de uso
corrigirSearchJson()
