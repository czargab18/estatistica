# Argo: Quarto - escrever artigos com Quarto

Este projeto implementa um sistema de escrita e publicação de artigos utilizando **Quarto**. O objetivo é integrar o Quarto para a escrita de artigos no ``/newsroom/``, usar Python para extrair o conteúdo diretamente de arquivos `.qmd` do artigo e adicionar o conteúdo ao `modelo.html`. Além disso, os arquivos foram reorganizados para uma estrutura mais adequada.

## Estrutura do Diretório `/newsroom/`

```{bash}
newsroom/
# Repositório dos artigos
├── articles/
│   ├── index.html # Página inicial do repositório
│   ├── pt_BR/
│   │   ├── 2025/
│   │   │   ├── 03/
│   │   │   │   ├── xxxxxxxx/       # Diretório do artigo xxxxx
│   │   │   │   │   ├── index.html  # Página do artigo
│   │   │   │   │   ├── src/        # arquivos do artigo
│   │   │   │   │   │   ├── img.png
│   │   │   │   │   │   └── formulas.tex
# Arquivos Gerais  
├── assets/ 
│   ├── pt_BR/
│   │   ├── arquive/ 
│   │   ├── articles/
│   │   ├── newsroom/
│   │   ├── newsroom/
├── imagens/ # Imagens Gerais: logos, marcas, backgrounds-img, etc.
# Criação dos artigos 
├── newshub/ 
│   ├── build/
│   │   ├── conteudo/  # conteudo dos artigos
│   │   ├── modelo.html/  # modelo do artigo
# Página principal da newsroom
├── index.html/
├── NEWSROOM.md/ # documentação
```

  - obs: ``~/pt_BR/2025/03/*`` refere-se a lingua, ano e mês respectivamente.

## ``/newsroom/`` exclusivo aos arquivos do artigo.html

**LER** discussão [#43](https://github.com/cesargabrielphd/estatistica/discussions/43) de estatistica