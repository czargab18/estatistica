########## CONTEXTO

# Script desenvolvido para testar o processo e facilitar no deselvilvimento
# da automação do GitHub Actions, para renderizar os livros do projeto que
# forem criados ou modificados.

# Processo de renderização:
#   1. O livro criado na pasta `books/build/XXX0000`
#   2. O livro é renderizado com o quarto e os arquivos HTML são salvos na pasta `books/XXX0000/`
# Processo da atomação:
#   1. corrigir links das tags <head> em cada arquivo HTML do book
#     1.1 corrigir de links dos atributos dos links que sejam sobre rel="next" e rel="prev"
#     1.2 corrigir problemas com *pontos* nos links adicionados pelo quarto.
#     1.3 corrigir scripts com `defer=""` para `defer`.
#     1.4 remover quebras de linhas `\n` quando remover linhas desnecessárias do <head>
#   2. adicionar os links do books, da pasta `/ac/` no <head> de cada arquivo HTML do book
#   2. incluir trechos de código HTML, de `/ac/component/` dentro do body de cada arquivo HTML do book
#     2.1 Adicionar os trechos referentes ao globalaside, globalnavbar, e globalribbon abaixo do <body>
#     2.2 Adicionar o trechos referente ao globalfooter no fim da tag </body>
#  3. Adicionar os books gerados no indice de books em `/books/index.html`

########## CONFIGURAÇÃO
# descrição ...
# execução ...

########## ALGUMA COISA
# descrição ...
# execução ...


# import backend

# bk.includeinbody(
#     pathbooks="./books",
#     tipoarquivo=".html",
#     substituirtag=True,
#     globalheader=True,
#     globalheadertagsid=["globalnavbar", "globalaside", "globalribbon"],
#     include_file={
#         "head": "./ac/components/1/pt_BR/books/head.html",
#         "globalnavbar": "./ac/components/1/pt_BR/navbar.html",
#         "globalfooter": "./ac/components/1/pt_BR/footer.html",
#     },
# )
# print("FIM da execução de: includeinbody()")

# # Chama a função para corrigir os arquivos HTML na pasta ./books
# bk.corrigirlinksinhead(
#     path="./books",
#     corlink=bk.CORRECOESLINK,
#     rmhead="delete/site_libs",
#     patternfolders=bk.CAMINHOS["pattern_book"],
#     tipoarquivo=".html")
# print("FIM da execução de: corrigirlinksinhead()")


print("FIM da execução de: renderbook.py")