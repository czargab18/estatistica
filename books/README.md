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

## Estrutura Recomendada do Repositório

Para organizar múltiplos livros online usando Quarto, sugiro a seguinte estrutura:

```plaintext
books/
  ├── automacao/            # Scripts e ferramentas de automação
  │   ├── dados/            # Dados auxiliares (ex.: JSON com metadados dos livros)
  │   ├── scripts/          # Scripts para geração e deploy
  │   └── logs/             # Logs de execução
  ├── docs/                 # Documentação geral do projeto
  │   └── guia.md           # Guia de uso e contribuição
  ├── assets/               # Recursos compartilhados (imagens, estilos, etc.)
  │   ├── imagens/
  │   ├── estilos/
  │   └── fontes/
  ├── livros/               # Código-fonte dos livros em Quarto
  │   ├── EST0033/          # Livro específico (ex.: EST0033)
  │   │   ├── index.qmd     # Arquivo principal do livro
  │   │   └── capítulos/    # Capítulos do livro
  │   ├── EST0064/          # Outro livro (ex.: EST0064)
  │   └── ...               # Outros livros
  ├── public/               # Arquivos HTML gerados (prontos para deploy)
  │   ├── EST0033/          # HTML do Livro EST0033
  │   ├── EST0064/          # HTML do Livro EST0064
  │   └── ...               # Outros livros
  ├── wss/                  # Recursos estáticos para o site (CSS, fontes, etc.)
  ├── index.html            # Página inicial com links para os livros
  ├── README.md             # Documentação principal do repositório
  ├── .github/              # Configurações e workflows do GitHub
  ├── .vscode/              # Configurações do Visual Studio Code
  ├── .gitignore            # Arquivos ignorados pelo Git
  └── .gitattributes        # Configurações de atributos do Git
```

## Detalhes da Estrutura

- **`automacao/`**: Scripts para automatizar tarefas como geração de livros, deploy e backups.
- **`docs/`**: Documentação geral do projeto, incluindo guias de contribuição e uso.
- **`assets/`**: Recursos reutilizáveis, como imagens e estilos, para manter consistência visual.
- **`livros/`**: Código-fonte dos livros organizados em subpastas, cada uma representando um livro.
- **`public/`**: Saída gerada pelo Quarto, pronta para ser publicada.
- **`wss/`**: Recursos estáticos compartilhados entre os livros, como fontes e CSS.
- **`index.html`**: Página inicial que lista e redireciona para os livros disponíveis.

Essa estrutura facilita a manutenção, escalabilidade e colaboração no projeto.

# Referências

- AKITA, F. **Motivação: O diário de Henry Jones**. Disponível em: <https://www.youtube.com/watch?v=ii5Q2fCl8C0&pp=ygURaGVucnkgam9uZXMgYWtpdGE%3D>. Acesso em: 15 fev. 2025.
