# Estatística

Projeto iniciado 26 de Março de 2023, veja o commit inicial [aqui](https://github.com/czargab18/estatistica/commit/567feace1153d96d9bb24393abb1294ae7ae1bc1). Começou como um repositório simples para aprendizado sobre Desenvolvimento Web e depois como um site a ser entregue para o [Departamento de Estatística](https://est.unb.br) da Universidade de Brasília. Hoje o projeto não tem sentido bem definido, apenas continua como uma forma de aprimorar o meu racicionio lógico e habilidades de programação. 

Hoje Há funcionalidades que estão sendo desenvolvidadas, como os [livros](https://github.com/czargab18/books) e [artigos](https://github.com/czargab18/newshub), não disponivel, feitos em Quarto Markdown pelo software [Quarto](https://quarto.org).

Sobre os livros, são uma forma que encontrei para organizar e disponibilizar materiais sobre Estatistica focado no meu proprio aprendizado. Atualmente estou com problemas para escrever de forma rápida o conteúdo, desenvolvidos primordialmente com minhas notas de aula e exercícios resolvidos. Assim como no vídeo intitulado ["O Diário de Henry Jones"](https://www.youtube.com/watch?v=ii5Q2fCl8C0&t=1s), buscarei o mesmo mas para a área de Estatística. A ideia de possuir algo que contenha tudo o que estudei ou estudarei me parece essencial para meu progresso na área, além de um bom ponto de partida para referências bibliográficas futuras.

Os artigos são uma forma de deixar noticias e comunicados importantes para a comunidade.
Também há outras funcionalidades, veja o diretório [apps](/apps/) para mais detalhes.

## 📁 Estrutura do Projeto

```
estatistica/
├── ac/              # Assets and Components (componentes globais)
│   ├── globalfooter/
│   ├── globalheader/
│   ├── globalmain/
│   ├── globalnewsroom/
│   ├── globalnoticias/
│   ├── globalothers/
│   └── globalpattern/
├── apps/            # Aplicações
│   └── ira/         # Calculadora de IRA
├── backend/         # submodule
├── boasvindas/      # Página de boas-vindas para calouros
├── erros/              # 
│   ├── 404/index.html     # 
├── books/           # submodule
├── book/            # Livros digitais em Quarto
│   ├── TAS0000/     # Projeto de Books
│   ├── CIC0007/     # Fundamentos de Programação
│   ├── EST0033/     # Estatística Básica
│   └── MAT0075/     # Matemática para Estatística
├── newshub/         # submodule
├── newsroom/        # 📰 Sistema de renderização Apple Newsroom (submódulo)
├── pages/           # Páginas do site
│   ├── docente/     # Páginas docentes
│   ├── newsroom/    # Sistema de artigos
│   └── boasvindas/  # Página de boas-vindas
├── sd/              # Structure data (dados estruturados)
├── sitemap/         # Mapa do site
└── wss/             # WebSocket Server (não implementado)
```

## Contribuindo

Contribuições são bem-vindas! Sinta-se à vontade para abrir issues ou pull requests. Para grandes mudanças, por favor, abra uma issue primeiro para discutir o que você gostaria de mudar.

Por favor, evite usar as branch `main`, `stag`, `dev0`, `dev1`, `dev2`, `news`, `book` para desenvolvimento direto. Crie uma nova branch a partir de `stag` para suas alterações usando como nome o sufixo `devX`, onde X é o próximo número de devs disponível. Branches de test devem ser enviadas como `devX-test`, ou faça o merge e envia o push em `devX`.

## Referências
- akita
- GitHub Copilot e seus modelos