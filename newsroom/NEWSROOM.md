explicação:
Newsroom e NewsHub são termos relacionados ao jornalismo, mas têm significados diferentes:

Newsroom
É o espaço físico ou virtual onde uma equipe de jornalistas, editores e produtores trabalha para produzir notícias. Pode ser de um jornal, revista, TV, rádio ou site de notícias.

Função: Reuniões de pauta, apuração, redação, edição e produção de conteúdo.

Exemplo: A sala onde repórteres e editores do The New York Times ou da GloboNews trabalham.

NewsHub
Geralmente se refere a um centro de distribuição ou agregação de notícias, que pode ser uma plataforma digital, um serviço de conteúdo compartilhado ou um sistema de integração de notícias de várias fontes.

Função: Agregar, distribuir ou gerenciar notícias de diferentes veículos ou regiões.

Exemplo: O Reuters News Hub é um sistema que fornece notícias para outros meios de comunicação.

Diferença Principal
Newsroom → Local de produção das notícias.

NewsHub → Sistema de distribuição ou agregação de notícias.

Algumas empresas usam "NewsHub" como marca (ex.: NewsHub na Nova Zelândia, um site de notícias), mas o conceito geral é de centralização de conteúdo.


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