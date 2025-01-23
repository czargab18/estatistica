## Padrões de commits usados neste Repositório

O commit semântico possui os elementos estruturais abaixo (tipos), que informam a intenção do seu commit ao utilizador(a) de seu código.

Isso indica algo
```{bash}
git commit -m 'padrao(acao): mensagem' -m 'descrição detalhada.'
```

- `docs` Commits do tipo docs indicam que houveram **mudanças na documentação**, como por exemplo no Readme do seu repositório. (Não inclui alterações em código).
  - Exemplo: `docs: atualiza documentação da API`
  - Exemplo: `docs: adiciona guia de contribuição`
  - Exemplo: `docs: corrige erros de digitação no README`
  - Exemplo: `docs: adiciona exemplos de uso na documentação`

- `fix` Commits do tipo fix indicam que seu trecho de código commitado está **solucionando um problema** (bug fix), (se relaciona com o PATCH do versionamento semântico).
  - Exemplo: `fix: corrige erro de validação no formulário de cadastro`
  - Exemplo: `fix: corrige problema de carregamento lento na página inicial`
  - Exemplo: `fix: resolve problema de compatibilidade com o navegador X`
  - Exemplo: `fix: corrige erro de cálculo no relatório financeiro`

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

- `ci` Commits do tipo ci indicam mudanças relacionadas a **integração contínua** (_continuous integration_).
  - Exemplo: `ci: configura pipeline de integração contínua`
  - Exemplo: `ci: adiciona testes automatizados ao pipeline`
  - Exemplo: `ci: corrige configuração do Jenkins`
  - Exemplo: `ci: adiciona verificação de qualidade de código`

- `cleanup` Commits do tipo cleanup são utilizados para remover código comentado, trechos desnecessários ou qualquer outra forma de limpeza do código-fonte, visando aprimorar sua legibilidade e manutenibilidade.
  - Exemplo: `cleanup: remove código comentado`
  - Exemplo: `cleanup: remove funções obsoletas`
  - Exemplo: `cleanup: apaga arquivos de log`
  - Exemplo: `cleanup: remove variáveis não utilizadas`

- `folders`: Usado para modificações de diretórios (exclusão, criação, mudança, renomeação).
  - Exemplo: `folders: cria estrutura de pastas para componentes`
  - Exemplo: `folders: reorganiza diretórios do projeto`
  - Exemplo: `folders: adiciona arquivos (imagens, fontes,...)`
  - Exemplo: `folders: apaga arquivos  (imagens, fontes,...)`
  - Exemplo: `folders: move arquivos para novo diretório`
  - Exemplo: `folders: adiciona novas fontes ao projeto`

- `files`: Usado para modificações de arquivos (exclusão, criação, mudança, renomeação).
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
