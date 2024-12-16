## Tipo e descrição 🦄

O commit semântico possui os elementos estruturais abaixo (tipos), que informam a intenção do seu commit ao utilizador(a) de seu código.

- `feat` Commits do tipo feat indicam que seu trecho de código está incluindo um **novo recurso** (se relaciona com o MINOR do versionamento semântico).
  - Exemplo: `feat: adiciona funcionalidade de login`
  - Exemplo: `feat: adiciona suporte a múltiplos idiomas`

- `fix` Commits do tipo fix indicam que seu trecho de código commitado está **solucionando um problema** (bug fix), (se relaciona com o PATCH do versionamento semântico).
  - Exemplo: `fix: corrige erro de validação no formulário de cadastro`
  - Exemplo: `fix: corrige problema de carregamento lento na página inicial`

- `docs` Commits do tipo docs indicam que houveram **mudanças na documentação**, como por exemplo no Readme do seu repositório. (Não inclui alterações em código).
  - Exemplo: `docs: atualiza documentação da API`
  - Exemplo: `docs: adiciona guia de contribuição`

- `test` Commits do tipo test são utilizados quando são realizadas **alterações em testes**, seja criando, alterando ou excluindo testes unitários. (Não inclui alterações em código)
  - Exemplo: `test: cria testes unitários para o componente de login`
  - Exemplo: `test: adiciona testes de integração para o módulo de pagamento`

- `build` Commits do tipo build são utilizados quando são realizadas modificações em **arquivos de build e dependências**.
  - Exemplo: `build: cria dependências do projeto`
  - Exemplo: `build: atualiza configuração do Webpack`

- `perf` Commits do tipo perf servem para identificar quaisquer alterações de código que estejam relacionadas a **performance**.
  - Exemplo: `perf: melhora performance da busca de usuários`
  - Exemplo: `perf: otimiza carregamento de imagens`

- `style` Commits do tipo style indicam que houveram alterações referentes a **formatações de código**, semicolons, trailing spaces, lint... (Não inclui alterações em código).
  - Exemplo: `style: corrige formatação do código`
  - Exemplo: `style: aplica linting ao código`

- `refactor` Commits do tipo refactor referem-se a mudanças devido a **refatorações que não alterem sua funcionalidade**, como por exemplo, uma alteração no formato como é processada determinada parte da tela, mas que manteve a mesma funcionalidade, ou melhorias de performance devido a um code review.
  - Exemplo: `refactor: refatora função de cálculo de impostos`
  - Exemplo: `refactor: melhora estrutura do código do componente de login`

- `chore` Commits do tipo chore indicam **atualizações de tarefas** de build, configurações de administrador, pacotes... como por exemplo adicionar um pacote no gitignore. (Não inclui alterações em código)
  - Exemplo: `chore: adiciona nova regra ao .gitignore`
  - Exemplo: `chore: atualiza dependências do projeto`

- `ci` Commits do tipo ci indicam mudanças relacionadas a **integração contínua** (_continuous integration_).
  - Exemplo: `ci: configura pipeline de integração contínua`
  - Exemplo: `ci: adiciona testes automatizados ao pipeline`

- `raw` Commits do tipo raw indicam mudanças relacionadas a arquivos de configurações, dados, features, parâmetros.
  - Exemplo: `raw: atualiza arquivo de configuração de ambiente`
  - Exemplo: `raw: adiciona novos parâmetros de configuração`

- `cleanup` Commits do tipo cleanup são utilizados para remover código comentado, trechos desnecessários ou qualquer outra forma de limpeza do código-fonte, visando aprimorar sua legibilidade e manutenibilidade.
  - Exemplo: `cleanup: remove código comentado`
  - Exemplo: `cleanup: remove funções obsoletas`

- `remove` Commits do tipo remove indicam a exclusão de arquivos, diretórios ou funcionalidades obsoletas ou não utilizadas, reduzindo o tamanho e a complexidade do projeto e mantendo-o mais organizado.
  - Exemplo: `remove: exclui arquivos de configuração antigos`
  - Exemplo: `remove: remove dependências não utilizadas`

- `files`: criação e organização de pastas dentro do repositório.
  - Exemplo: `files: cria estrutura de pastas para componentes`
  - Exemplo: `files: reorganiza diretórios do projeto`

- `feature` Commits do tipo feature indicam a **adição de uma nova funcionalidade** ao código.
  - Exemplo: `feature: adiciona funcionalidade de exportação de dados`
  - Exemplo: `feature: adiciona suporte a notificações push`
