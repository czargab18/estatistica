import backend


if __name__ == "__main__":
    backend.includeinbody(
        pathbooks="./books",
        tipoarquivo=".html",
        substituirtag=True,
        globalheader=True,
        globalheadertagsid=["globalnavbar", "globalaside", "globalribbon"],
        include_file={
            "head": "./ac/components/1/pt_BR/books/head.html",
            "globalnavbar": "./ac/components/1/pt_BR/navbar.html",
            "globalfooter": "./ac/components/1/pt_BR/footer.html",
        },
    )
    print("FIM da execução de: includeinbody()")

    # Chama a função para corrigir os arquivos HTML na pasta ./books
    backend.corrigirlinksinhead(
        path="./books",
        corlink=backend.CORRECOESLINK,
        rmhead="delete/site_libs",
        patternfolders=backend.CAMINHOS["pattern_book"],
        tipoarquivo=".html")
    print("FIM da execução de: corrigirlinksinhead()")
