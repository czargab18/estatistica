## Tipo e descrição 🦄

O commit semântico possui os elementos estruturais abaixo (tipos), que informam a intenção do seu commit ao utilizador(a) de seu código.

- `feat` Commits do tipo feat indicam que seu trecho de código está incluindo um **novo recurso** (se relaciona com o MINOR do versionamento semântico).
  - Exemplo: `feat: adiciona funcionalidade de login`
  - Exemplo: `feat: adiciona suporte a múltiplos idiomas`
  - Exemplo: `feat: implementa novo layout para a página inicial`
  - Exemplo: `feat: adiciona filtro de pesquisa avançada`

- `fix` Commits do tipo fix indicam que seu trecho de código commitado está **solucionando um problema** (bug fix), (se relaciona com o PATCH do versionamento semântico).
  - Exemplo: `fix: corrige erro de validação no formulário de cadastro`
  - Exemplo: `fix: corrige problema de carregamento lento na página inicial`
  - Exemplo: `fix: resolve problema de compatibilidade com o navegador X`
  - Exemplo: `fix: corrige erro de cálculo no relatório financeiro`

- `docs` Commits do tipo docs indicam que houveram **mudanças na documentação**, como por exemplo no Readme do seu repositório. (Não inclui alterações em código).
  - Exemplo: `docs: atualiza documentação da API`
  - Exemplo: `docs: adiciona guia de contribuição`
  - Exemplo: `docs: corrige erros de digitação no README`
  - Exemplo: `docs: adiciona exemplos de uso na documentação`

- `test` Commits do tipo test são utilizados quando são realizadas **alterações em testes**, seja criando, alterando ou excluindo testes unitários. (Não inclui alterações em código)
  - Exemplo: `test: cria testes unitários para o componente de login`
  - Exemplo: `test: adiciona testes de integração para o módulo de pagamento`
  - Exemplo: `test: corrige testes quebrados no módulo de autenticação`
  - Exemplo: `test: remove testes obsoletos do componente de perfil`

- `build` Commits do tipo build são utilizados quando são realizadas modificações em **arquivos de build e dependências**.
  - Exemplo: `build: cria dependências do projeto`
  - Exemplo: `build: atualiza configuração do Webpack`
  - Exemplo: `build: adiciona script de build para produção`
  - Exemplo: `build: atualiza dependências do npm`

- `perf` Commits do tipo perf servem para identificar quaisquer alterações de código que estejam relacionadas a **performance**.
  - Exemplo: `perf: melhora performance da busca de usuários`
  - Exemplo: `perf: otimiza carregamento de imagens`
  - Exemplo: `perf: reduz tempo de resposta da API`
  - Exemplo: `perf: melhora eficiência do algoritmo de ordenação`

- `style` Commits do tipo style indicam que houveram alterações referentes a **formatações de código**, semicolons, trailing spaces, lint... (Não inclui alterações em código).
  - Exemplo: `style: corrige formatação do código`
  - Exemplo: `style: aplica linting ao código`
  - Exemplo: `style: ajusta indentação em arquivos CSS`
  - Exemplo: `style: remove espaços em branco desnecessários`

- `refactor` Commits do tipo refactor referem-se a mudanças devido a **refatorações que não alterem sua funcionalidade**, como por exemplo, uma alteração no formato como é processada determinada parte da tela, mas que manteve a mesma funcionalidade, ou melhorias de performance devido a um code review.
  - Exemplo: `refactor: refatora função de cálculo de impostos`
  - Exemplo: `refactor: melhora estrutura do código do componente de login`
  - Exemplo: `refactor: simplifica lógica de autenticação`
  - Exemplo: `refactor: separa funções utilitárias em módulos`

- `chore` Commits do tipo chore indicam **atualizações de tarefas** de build, configurações de administrador, pacotes... como por exemplo adicionar um pacote no gitignore. (Não inclui alterações em código)
  - Exemplo: `chore: adiciona nova regra ao .gitignore`
  - Exemplo: `chore: atualiza dependências do projeto`
  - Exemplo: `chore: configura ambiente de desenvolvimento`
  - Exemplo: `chore: limpa arquivos temporários`

- `ci` Commits do tipo ci indicam mudanças relacionadas a **integração contínua** (_continuous integration_).
  - Exemplo: `ci: configura pipeline de integração contínua`
  - Exemplo: `ci: adiciona testes automatizados ao pipeline`
  - Exemplo: `ci: corrige configuração do Jenkins`
  - Exemplo: `ci: adiciona verificação de qualidade de código`

- `raw` Commits do tipo raw indicam mudanças relacionadas a arquivos de configurações, dados, features, parâmetros.
  - Exemplo: `raw: atualiza arquivo de configuração de ambiente`
  - Exemplo: `raw: adiciona novos parâmetros de configuração`
  - Exemplo: `raw: modifica arquivo de configuração do servidor`
  - Exemplo: `raw: atualiza dados de teste`

- `cleanup` Commits do tipo cleanup são utilizados para remover código comentado, trechos desnecessários ou qualquer outra forma de limpeza do código-fonte, visando aprimorar sua legibilidade e manutenibilidade.
  - Exemplo: `cleanup: remove código comentado`
  - Exemplo: `cleanup: remove funções obsoletas`
  - Exemplo: `cleanup: apaga arquivos de log`
  - Exemplo: `cleanup: remove variáveis não utilizadas`

- `remove` Commits do tipo remove indicam a exclusão de arquivos, diretórios ou funcionalidades obsoletas ou não utilizadas, reduzindo o tamanho e a complexidade do projeto e mantendo-o mais organizado.
  - Exemplo: `remove: exclui arquivos de configuração antigos`
  - Exemplo: `remove: remove dependências não utilizadas`
  - Exemplo: `remove: apaga diretório de testes antigos`
  - Exemplo: `remove: remove funcionalidades descontinuadas`

- `files`: criação e organização de pastas dentro do repositório.
  - Exemplo: `files: cria estrutura de pastas para componentes`
  - Exemplo: `files: reorganiza diretórios do projeto`
  - Exemplo: `files: adiciona arquivos (imagens, fontes,...)`
  - Exemplo: `files: apaga arquivos  (imagens, fontes,...)`
  - Exemplo: `files: move arquivos para novo diretório`
  - Exemplo: `files: adiciona novas fontes ao projeto`

- `feature` Commits do tipo feature indicam a **adição de uma nova funcionalidade** ao código.
  - Exemplo: `feature: adiciona funcionalidade de exportação de dados`
  - Exemplo: `feature: adiciona suporte a notificações push`
  - Exemplo: `feature: implementa sistema de comentários`
  - Exemplo: `feature: adiciona integração com API externa`
