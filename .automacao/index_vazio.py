import os
""" Função que adiciona conteúdo padrão a páginas html vazias. """

def buscar_index_vazios(diretorio):
    arquivos_vazios = []
    for subdir, _, files in os.walk(diretorio):
        for file in files:
            if file == "index.html":
                file_path = os.path.join(subdir, file)
                if os.path.getsize(file_path) == 0:
                    arquivos_vazios.append(file_path)
    return arquivos_vazios

def adicionar_conteudo_arquivo(arquivo, conteudo):
    with open(arquivo, 'w') as f:
        f.write(conteudo)

diretorio_repositorio = "./" 
index_vazios = buscar_index_vazios(diretorio_repositorio)
novo_conteudo = """
<!DOCTYPE html>
<html lang="en">
  <head>
    <title>Estatística</title>
    <meta charset="utf-8" />
    <meta content="Estatística" name="estatistica" />
    <meta content="index,follow" name="robots" />
    <meta content="width=device-width, initial-scale=1.0" name="viewport" />
    <meta
      content="img-src 'self' https://www.estatistica.pro/; script-src 'self' https://www.estatistica.pro/ac/ https://www.estatistica.pro/sd/"
      http-equiv="Content-Security-Policy"
    />
    <link
      href="/sd/images/favicons/estatistica.svg"
      rel="shortcut icon"
      type="image/x-icon"
    />
    <link
      href="/ac/globalpattern/1/pt_BR/styles/globalpattern.css"
      rel="stylesheet"
    />
    <link
      href="/ac/globalaside/1/pt_BR/styles/globalaside.css"
      rel="stylesheet"
    />
    <link
      href="/ac/globalnavbar/1/pt_BR/styles/globalnavbar.css"
      rel="stylesheet"
    />
    <link
      href="/ac/globalribbon/1/pt_BR/styles/globalribbon.css"
      rel="stylesheet"
    />
    <link
      href="/ac/globaltipografia/1/pt_BR/style/globaltipografia.css"
      rel="stylesheet"
    />
    <link
      href="/ac/globalothers/1/pt_BR/espaco/styles/espaco.build.css"
      rel="stylesheet"
    />
    <link
      href="/ac/globalfooter/1/pt_BR/styles/globalfooter.css"
      rel="stylesheet"
    />
    <link
      href="/wss/fonts.css?families=SF+Pro,v3|SF+Pro+Icons,v3"
      media="all"
      rel="stylesheet"
      type="text/css"
    />
    <script
      defer=""
      src="/ac/globalfooter/1/pt_BR/scripts/globalfooter.js"
    ></script>
  </head>
<body>
    <main>
      <h1>Em desenvolvimento</h1>
    </main>
</body>
</html>
"""

print("Arquivos index.html vazios encontrados:")
for arquivo in index_vazios:
    print(arquivo)
    adicionar_conteudo_arquivo(arquivo, novo_conteudo)

