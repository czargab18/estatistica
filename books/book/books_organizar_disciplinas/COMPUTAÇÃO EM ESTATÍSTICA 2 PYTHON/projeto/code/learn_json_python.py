"""Aprendendo a manipular arquivos JSON com Python"""
json_data = {
  "chave1": {
      "valor1",
      "valor2",
    },
  "chave2": {
      "valor1",
      "valor2",
    }
  }

for chave in json_data:
  print(f'Exibindo a chave:{chave}')


data = {
    "EST0033": {
        "EST0033": [
            "/books/EST0033/index.html",
            "/books/EST0033/search.json"
        ],
        "01": [
            "/books/EST0033/conteudo/01/introducao.html"
        ],
        "02": [
            "/books/EST0033/conteudo/02/conclusao.html",
            "/books/EST0033/conteudo/02/metodologia.html"
        ],
        "03": [
            "/books/EST0033/conteudo/03/apendice.html",
            "/books/EST0033/conteudo/03/references.html"
        ]
    },
    "EST0064": {
        "EST0064": [
            "/books/EST0064/index.html",
            "/books/EST0064/search.json"
        ],
        "01": [
            "/books/EST0064/conteudo/01/introducao.html"
        ],
        "02": [
            "/books/EST0064/conteudo/02/conclusao.html",
            "/books/EST0064/conteudo/02/metodologia.html"
        ],
        "03": [
            "/books/EST0064/conteudo/03/apendice.html",
            "/books/EST0064/conteudo/03/references.html"
        ]
    }
}

print(type(data))
print(data["EST0033"]["EST0033"][0])
print(data["EST0033"]["EST0033"][1])
