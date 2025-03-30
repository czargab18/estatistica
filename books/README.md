# Livro: Estatística

Este projeto é uma forma de diversão para momentos vagos e desafiadores da graduação. O objetivo principal é desenvolver uma habilidade fundamental: a escrita. A escrita proporciona clareza de pensamento, algo que considero essencial neste momento.

A ideia inicial é construir algo semelhante ao que Fábio Akita chama de "O Diário de Henry Jones" (AKITA, 2025).

Assim como ele, o conteúdo aqui presente terá foco total no meu desenvolvimento pessoal. Tenho facilidade em aprender, mas também em esquecer! Este projeto é como andar no escuro em busca de uma tomada. Não sei se resolverá meus problemas, mas, se ajudar, já será de grande valia.

Ter algo para consulta é essencial, como mencionado por (AKITA, 2025). Se for fácil de encontrar, será rápido de consumir! Sempre que possível, buscarei melhorar a escrita dos tópicos, mesmo que isso signifique refazer grande parte do conteúdo.

## Processo de Desenvolvimento

O processo seguirá os seguintes passos:

1. Disponibilizar o conteúdo existente, mesmo que inicialmente não tenha clareza.
2. Melhorar o conteúdo, mesmo que isso exija mudanças significativas.
3. Adicionar exemplos e exercícios.
4. Repetir os passos anteriores, não para alcançar uma Magnum Opus, mas algo aceitável para consulta.
5. Finalizar e "entregar" o projeto assim que possível.

## Futuro do Projeto

O futuro é incerto, composto por eventos presentes que moldam nossas vidas.

Para alguns, a ansiedade é um ponto fraco — o meu caso! Talvez eu me empolgue com este projeto ou o abandone no vazio do esquecimento.

### Algumas Citações

- "Andando no escuro para achar uma tomada" por [Cesar Gabriel](https://github.com/cesargabrielphd)
- "Se é fácil para encontrar é rápido para consumir" por [Cesar Gabriel](https://github.com/cesargabrielphd)

## Estrutura do Repositório

As subpastas `./NameBook/**` são geradas por `./book/NameBook/` e armazenadas na raiz do projeto como arquivos HTML.

```plaintext
book/
  ├── automacao/            # Scripts de automação
  │   ├── dados/
  │   │   └── books.json    # Arquivo JSON com os caminhos dos livros
  │   ├── package/
  │   └── restos/
  ├── docs/                 # Documentação e arquivos gerados
  │   └── prettier.md
  ├── ac/                   # Assets comuns (imagens, estilos, etc.)
  │   ├── image/
  │   │   └── logo/
  │   ├── r4ds.scss
  │   └── site_libs/
  │       ├── bootstrap/
  │       ├── clipboard/
  │       ├── quarto-html/
  │       ├── quarto-nav/
  │       └── quarto-search/
  ├── book/                 # Código Quarto que gera os livros
  │   ├── EST0033/          # Livro Quarto EST0033
  │   └── EST0064/          # Livro Quarto EST0064
  ├── EST0033/              # HTML do Livro Quarto EST0033
  ├── EST0064/              # HTML do Livro Quarto EST0064
  ├── wss/                  # Web Static Site (fonts, css, etc.)
  │   ├── fonts/
  │   └── fonts.css
  ├── index.html            # Página de redirecionamento para os livros
  ├── README.md
  ├── .github/              # Configurações do GitHub
  ├── .vscode/              # Configurações do Visual Studio Code
  ├── .gitignore
  └── .gitattributes
```

# Referências

- AKITA, F. **Motivação: O diário de Henry Jones**. Disponível em: <https://www.youtube.com/watch?v=ii5Q2fCl8C0&pp=ygURaGVucnkgam9uZXMgYWtpdGE%3D>. Acesso em: 15 fev. 2025.
