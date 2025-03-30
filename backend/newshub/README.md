# Newshub - Editor de Texto Headless

Este projeto implementa um **editor de texto headless**. O painel do editor será desenvolvido em HTML, CSS e JavaScript. O conteúdo dos arquivos e suas estilizações de texto serão salvos em um arquivo JSON, e um servidor em Python ou Node.js será responsável por gerar o arquivo `artigo.html` com base nesse conteúdo.

## Estrutura do Diretório `/newshub/`

```bash
newshub/
├── dados/
│   ├── template.html
│   └── artigos.js
├── editor/
│   ├── index.html
│   ├── styles/
│   │   └── style.css
│   └── scripts/
│       └── editor.js
├── python_server/
│   ├── app.py
│   ├── templates/
│   │   └── article_template.html
│   └── data/
│       └── articles.json
├── node_server/
│   ├── server.js
│   ├── templates/
│   │   └── article_template.html
│   └── data/
│       └── articles.json
└── README.md
```

## Descrição dos Arquivos e Diretórios

### `editor/`
Contém os arquivos do painel do editor.

- **`index.html`**: Arquivo HTML principal do editor.
- **`styles/`**: Diretório para os arquivos de estilo CSS.
  - **`style.css`**: Arquivo CSS para estilizar o editor.
- **`scripts/`**: Diretório para os arquivos JavaScript.
  - **`editor.js`**: Arquivo JavaScript que contém a lógica do editor.

### `python_server/`
Contém os arquivos do servidor em Python.

- **`app.py`**: Arquivo principal do servidor Flask que gerencia a criação do artigo HTML.
- **`templates/`**: Diretório para os arquivos de template HTML.
  - **`article_template.html`**: Template HTML usado para gerar o artigo final.
- **`data/`**: Diretório para os arquivos de dados.
  - **`articles.json`**: Arquivo JSON onde o conteúdo dos artigos e suas estilizações são salvos.

### `node_server/`
Contém os arquivos do servidor em Node.js.

- **`server.js`**: Arquivo principal do servidor Node.js que gerencia a criação do artigo HTML.
- **`templates/`**: Diretório para os arquivos de template HTML.
  - **`article_template.html`**: Template HTML usado para gerar o artigo final.
- **`data/`**: Diretório para os arquivos de dados.
  - **`articles.json`**: Arquivo JSON onde o conteúdo dos artigos e suas estilizações são salvos.

### `README.md`
Arquivo de documentação do projeto.