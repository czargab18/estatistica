# Exemplo de dicionário
import os
import re
dic = {
  "pastaPai": ["path-arquivo1", "path-arquivo2"],
  "pastaPai2": ["path-arquivo1", "path-arquivo2"]
  }

# Loop para iterar sobre os itens do dicionário
# for pasta, caminhos in dic.items():
#     print(f"Book: {pasta}")
#     print(f"Caminhos: {caminhos}")
#     for caminho in caminhos:
#         print(f"  Caminho: {caminho}")

# Acessando elementos específicos
# print(dic["pastaPai"])
# print(dic["pastaPai"][1])


# Expressões regulares

# Exemplo de conteúdo HTML com caminhos duplicados em href
conteudo_html = '''
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Document</title>
    <link href="/books/EST0033//books/EST0033//books/EST0033/conteudo/01/introducao.html" rel="next">
    <link href="/books/EST0033//books/EST0033/conteudo/02/conclusao.html" rel="prev">
</head>
<body>
    <a href="/books/EST0033//books/EST0033//books/EST0033/conteudo/01/introducao.html">Introdução</a>
    <a href="/books/EST0033//books/EST0033/conteudo/02/conclusao.html">Conclusão</a>
</body>
</html>
'''

# Expressão regular para corrigir caminhos duplicados em href
padrao_antigo = r'href="[^"]*//+'
padrao_novo = 'href="/'

# Aplica a substituição
conteudo_corrigido = re.sub(padrao_antigo, padrao_novo, conteudo_html)

# Exibe o conteúdo corrigido
# print("Conteúdo corrigido:")
# print(conteudo_corrigido)

# ## regex
# path = "/books/ABC1234/books/ABC1234/books/ABC1234/"
# print(path)

# nome_livro = re.search(r'/books/([A-Z]{3}\d{4})/', path).group(1)

# padrao = re.compile(rf'(/books/{nome_livro}/)(books/{nome_livro}/)+')
# match = padrao.search(path)

# print(nome_livro)  # Saída: ABC1234
# print(match.group())  # Saída: /books/ABC1234/books/ABC1234/books/ABC1234/


# import json

# with open("./.automacao/books.json", "r", encoding="utf-8") as book:
#     books = json.load(book)
#     print(books)

import os 
for raiz, dirs, files in os.walk("./EST0064/"):
    print(raiz, dirs, files)