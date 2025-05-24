# Commit Message Instructions

- Use o formato convencional de mensagens de commit.
- A primeira linha (descrição curta) deve ter até 50 caracteres. Se ultrapassar esse limite, resuma a mensagem para que fique clara e objetiva, e transfira detalhes para a descrição longa.
- O formato da descrição curta é: `<type>(<scope>): <short description>`
  - `type`: O tipo de mudança (ex: feat, fix, docs, style, refactor, test, chore, etc). Veja a lista abaixo.
  - `scope`: O escopo da mudança (ex: nome do componente, arquivo, módulo, etc). Inclua se a mudança for específica de uma parte do código.
  - `short description`: Um resumo claro da mudança, com até 50 caracteres. Se necessário, resuma e transfira detalhes para o corpo do commit.
- Após a linha em branco, adicione uma descrição longa e detalhada, explicando o motivo da mudança, o que foi alterado e qualquer contexto relevante. Use este espaço para esclarecer pontos que não couberam na descrição curta.
- Se o commit corrige um problema, inclua `Fixes #<issue-number>` ou `Closes #<issue-number>` ao final da descrição longa.
- Se o commit introduz uma breaking change, inclua `BREAKING CHANGE: <descrição da breaking change>` ao final da descrição longa.

## Dicas para descrição curta
- Seja direto e específico.
- Use verbos no presente.
- Evite frases genéricas ou muito amplas.
- Se a mensagem exceder 50 caracteres, resuma para o essencial e explique o restante na descrição longa.

## Tipos comuns de commit
- feat: Nova funcionalidade
- fix: Correção de bug
- docs: Mudanças apenas na documentação
- style: Mudanças de formatação, sem alteração de código
- refactor: Refatoração de código, sem correção de bug ou nova feature
- test: Adição ou correção de testes
- chore: Mudanças em ferramentas, build ou dependências
- perf: Melhorias de performance
- ci: Mudanças em arquivos/scripts de CI
- build: Mudanças no sistema de build ou dependências externas
- revert: Reversão de commit anterior
- wip: Trabalho em andamento
- security: Mudanças relacionadas à segurança
- i18n: Internacionalização
- a11y: Acessibilidade
- ux: Experiência do usuário
- ui: Interface do usuário
- config: Arquivos de configuração
- deps: Atualização de dependências
- infra: Infraestrutura
- init: Commit inicial
- analytics: Código de análise/monitoramento
- seo: SEO
- legal: Licenciamento ou questões legais
- typo: Correção de erros de digitação
- comment: Comentários no código
- example: Exemplos
- mock: Mocks
- hotfix: Correção crítica
- merge: Mesclagem de branches
- cleanup: Limpeza de código
- deprecate: Depreciação
- move: Movimentação de arquivos
- rename: Renomeação
- split: Divisão de arquivos/funções
- combine: Combinação de arquivos/funções
- add: Adição de arquivos/funcionalidades
- remove: Remoção de arquivos/funcionalidades
- update: Atualização de arquivos/funcionalidades
- downgrade: Downgrade
- patch: Aplicação de patch
- optimize: Otimização

## Exemplo

### Exemplo de mensagem de commit
```
feat(auth): Adiciona autenticação de usuário

Implementa autenticação de usuário usando JWT, incluindo login, registro e verificação de token.

- Implementação da autenticação JWT
- Endpoints de login e registro
- Middleware para verificação de token

Fixes #123
```

### Exemplo de breaking change
```
refactor(api): Atualiza endpoints da API

Refatora os endpoints da API para seguir convenções RESTful. Essa mudança afeta todas as chamadas existentes.

- URLs dos endpoints atualizadas
- Formatos de request e response modificados

BREAKING CHANGE: Todas as chamadas de API precisam ser atualizadas para os novos endpoints.
```