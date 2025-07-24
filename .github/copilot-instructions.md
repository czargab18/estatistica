# Instruções para Agentes de IA — Projeto Estatística

Este documento orienta agentes de IA (Copilot, Claude, Cursor, etc.) para máxima produtividade neste repositório. Foque em padrões reais, workflows e decisões arquiteturais já adotadas.

## Visão Geral
- O projeto é um hub de conteúdos educacionais, automações e aplicações web, com foco em Estatística, Matemática e Computação.
- Estrutura modular: cada pasta representa um domínio (books, newsroom, apps, ac/components, sd/assets).
- Grande parte do código e conteúdo é gerado ou assistido por IA, com marcação explícita nos arquivos.

## Arquitetura & Fluxos
- **books/**: Livros digitais criados com Quarto, R, Python, LaTeX. Cada disciplina tem subpasta própria. Scripts de build e automação em `books/build/` e `books/run/`.
- **newshub/** e **newsroom/**: Sistema de renderização de artigos Markdown para HTML, com templates dinâmicos e processamento de imagens. Use scripts Python (`newshub/run/artigo.py`) para converter `.qmd` em `index.html`.
- **apps/ira/**: Aplicação web para cálculo de IRA, com exportação/importação CSV, auto-save via LocalStorage, e validação robusta. Veja exemplos e padrões em `apps/ira/README.md`.
- **ac/components/**: Componentes HTML reutilizáveis (navbar, footer, ribbon). Automatize a inclusão usando scripts Python que substituem marcadores HTML (`<!-- #GLOBALNAVBAR# -->`) pelo conteúdo dos componentes.
- **sd/**: Diretório de dados estruturados (imagens, vídeos, JSONs). Siga a estrutura exemplificada em `sd/README.md`.

## Convenções e Padrões
- Scripts de automação e build geralmente em Python, Bash ou PowerShell. Priorize Python moderno e scripts utilitários.
- Componentização: Sempre que possível, reutilize componentes de `ac/components/` e siga os marcadores HTML para inclusão automática.
- Estrutura de dados e assets segue padrões de subpastas por tipo e contexto (ex: `sd/images/br/banners/`).
- Exportação/importação de dados em CSV para apps, com formato padronizado e validação de menções (SS, MS, MM, MI, II, SR, TR, SF).
- Documentação e exemplos de uso estão nos diversos `README.md` espalhados pelo projeto — consulte antes de criar novos fluxos.

## Workflows de Desenvolvimento
- Para build de livros: use Quarto, scripts Python e R. Veja `books/build/` e `books/run/`.
- Para renderização de artigos: execute scripts em `newshub/run/` ou `newsroom/run/` para converter Markdown/Quarto em HTML.
- Para apps: mantenha compatibilidade com CSV e LocalStorage, e siga os exemplos de validação e feedback do usuário.
- Para inclusão de componentes: automatize via Python, conforme exemplo em `ac/components/README.md`.

## Integrações e Dependências
- Quarto, R, Python, LaTeX, Jupyter Notebooks, HTML/CSS.
- Scripts multi-linguagem (Python, Bash, PowerShell) para automação e build.
- Uso explícito de metadados YAML (frontmatter) em artigos e livros.

## Exemplos de Padrões
- Inclusão de navbar: insira `<!-- #GLOBALNAVBAR# -->` e substitua via script Python.
- Exportação de dados: gere CSV com cabeçalhos padronizados e menções válidas.
- Renderização de artigo: execute `python newshub/run/artigo.py artigo.qmd` para gerar `index.html`.

## Referências
- Consulte os `README.md` em cada pasta para padrões específicos.
- Estruturas e exemplos de automação estão nos diretórios `build/`, `run/` e `components/`.

---

> Atualize este documento conforme novos padrões forem adotados. Mantenha instruções concisas e focadas em práticas reais do projeto.
