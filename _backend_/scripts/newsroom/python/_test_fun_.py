import funs

# _____ TESTE DA FUNÇÃO _____#
# > > FUNCIONA CORRETAMENTE < < #

# print(funs.create_dir(diretorio="./teste"))
# print(funs.verificacao(pergunta="Você está bem?"))
# print(funs.import_content_file(
#     caminho="_backend_/scripts/newsroom/article/artigo.txt"))

DIR_ARTICLE_TXT = "_backend_/scripts/newsroom/article/"

print(funs.create_dir(diretorio=DIR_ARTICLE_TXT))
print(funs.import_content_file(
    caminho=f"{DIR_ARTICLE_TXT}artigo.txt"))



