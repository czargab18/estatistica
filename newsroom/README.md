# Diferença entre Newsroom e NewsHub (e relação com `/newsroom/`)

Este documento explica como a página de notícias em `/newsroom/` é diferente de `ac/globalnoticias` (que utiliza um slide infinito em `/index.html`) e esclarece os conceitos de **Newsroom** e **NewsHub**.

## Conceitos

### Newsroom
**Newsroom** é o espaço — físico ou virtual — onde jornalistas, editores e produtores trabalham na produção de notícias. Pode ser parte de jornais, revistas, emissoras de TV/rádio ou portais de notícias online.

- **Funções:** Reuniões de pauta, investigação, redação, edição e produção de conteúdo.
- **Exemplo:** A redação do The New York Times ou da GloboNews, onde repórteres e editores atuam diariamente.

### NewsHub
**NewsHub** refere-se, em geral, a um centro de distribuição ou agregação de notícias: uma plataforma digital, serviço de conteúdo compartilhado ou sistema que integra notícias de várias fontes.

- **Funções:** Agregar, distribuir e gerenciar notícias vindas de diferentes veículos ou regiões.
- **Exemplo:** O Reuters News Hub, que fornece conteúdo noticioso para outros meios de comunicação.

**Diferença principal:**

- **Newsroom:** Foco na produção da notícia (origem do conteúdo).
- **NewsHub:** Foco na distribuição e centralização de notícias (agregação de conteúdo).

> **Nota:** Algumas empresas usam "NewsHub" como nome próprio (ex.: NewsHub.nz na Nova Zelândia), mas o conceito geral é o de centralizador ou integrador de conteúdo.

---

# Argo: Sistema para Escrita de Artigos com Quarto

Este projeto implementa um sistema de produção e publicação de artigos usando **Quarto**. O objetivo é usar o Quarto para criar artigos no diretório `/newsroom/`, extrair o conteúdo dos arquivos `.qmd` via Python e incorporar esse conteúdo ao `modelo.html`. Além disso, os arquivos do projeto foram reorganizados para uma estrutura mais intuitiva.

## Estrutura do Diretório `/newsroom/`

```
newsroom/
├── archive/
│   └── pt_BR/
│   │   └── 2025/
│   │   │   └── 03/
│   │   │   │   ├── xxxxxxxx/      # (código) Diretório do artigo
│   │   │   │   │   ├── index.html
│   │   │   │   │   └── src/
│   │   │   │   │   │   ├── img.png
├── assets/                       # Recursos estáticos (CSS, JS)
│   └── pt_BR/
│   │   └── 1/
│   │   │   ├── archive/
│   │   │   └── newsroom/         # articles ( /newsroom/index.html )
│   │   │   └── imagens/          # Imagens gerais: logos, marcas, backgrounds etc.
├── newshub/
│   └── build/                    # Construir artigos
│   │   ├── articles/             # Conteúdo dos artigos
│   │   └── modelo.html/          # Modelo-base dos artigos
├── index.html                    # Página principal da newsroom
└── README.md                     # Documentação
```

- **Observação:** O caminho `pt_BR/2025/03/*` indica a língua, ano e mês, respectivamente.

## Organização

- O diretório `/newsroom/` é **exclusivo para arquivos de artigos em HTML**.
- Para mais informações e discussões, consulte a [Discussão #43](https://github.com/cesargabrielphd/estatistica/discussions/43) do repositório **estatistica**.

