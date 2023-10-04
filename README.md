# estatistica

[desenvolvimento]-Plataforma de ensino de estatística gratuitamente.

## Padrões de commits 📜

De acordo com a documentação do **[Conventional Commits](https://www.conventionalcommits.org/pt-br)**, commits semânticos são uma convenção simples para ser utilizada nas mensagens de commit. Essa convenção define um conjunto de regras para criar um histórico de commit explícito, o que facilita a criação de ferramentas automatizadas.

## Tipo e descrição e Padrões de emojis

O commit semântico possui os elementos estruturais abaixo (tipos), que informam a intenção do seu commit ao utilizador(a) de seu código.

- `feat`- indicam que seu trecho de código está incluindo um **novo recurso** (se relaciona com o MINOR do versionamento semântico).

  - :lipstick: [lipstick] Estilização de interface
  - :sparkles: [sparkles] Novo recurso

- `fix` - indicam que seu trecho de código commitado está **solucionando um problema** (bug fix), (se relaciona com o PATCH do versionamento semântico).

  - :bug: [bug] Bug
  - :boom: [boom] Revertendo mudanças
  - :goal_net: [goal_net] Tratamento de erros

- `docs` - indicam que houveram **mudanças na documentação**, como por exemplo no Readme do seu repositório. (Não inclui alterações em código).

  - :book: [books] Documentação
  - :memo: [memo] Qtualização da Documentação

- `build` - são utilizados quando são realizadas modificações em **arquivos de build e dependências**.

  - :wrench: [wrench] Alterações de configuração ou manutenção
  - :heavy_plus_sign: [heavy_plus_sign] Adicionando uma dependência
  - :heavy_minus_sign: [heavy_minus_sign] Revertendo uma dependência
  - :package: [package] Package.json em JS
  - :arrow_up: [arrow_up] atualização de dependências
  - :arrow_down: [arrow_down] Redução de dependências

- `style` - indicam que houveram alterações referentes a **formatações de código**, semicolons, trailing spaces, lint... (Não inclui alterações em código).

  - :ok_hand: [ok_hand] Alterações de revisão de código

- `refactor` -referem-se a mudanças devido a **refatorações que não alterem sua funcionalidade**, como por exemplo, uma alteração no formato como é processada determinada parte da tela, mas que manteve a mesma funcionalidade, ou melhorias de performance devido a um code review.
  - :recycle: [recycle] Refatoração

meus novos padrões

- `merge` - indica quando há merges entre branchs

  - :twisted_rightwards_arrows: [twisted_rightwards_arrows] Merges entre branchs

- `acervo` - indicam quando há mudanças no acervo (renomear pastas, mudanças de pastas que estejam dentro do ac)

- `page` criação de novas paginas ou alteração de nomes ou local de diretórios

  - :wheelchair: [wheelchair] Acessibilidade
  - :rocket: [rocket] Deploy
  - :construction: [construction] Em progresso
  - :truck: [truck] Mudanças de movimentação ou renomeação de arquivos
    - :fire: [fire] Remover
    - :truck: [truck] Mover
    - :repeat: [repeat] Renomear
  - :zap: [zap] Performance
  - :iphone: [iphone] Responsividade
  - :lock: [lock] Segurança
  - :mag: [mag] SEO
  - :bookmark: [bookmark] Tag de versão
  - :label: [label] Tipagem

- `outros` - indicam comentários ou identação de código
  - :tada: [tada] Commit inicial
  - :bulb: [bulb] Comentários
  - :art: [art] Identação
  - :truck: [truck] Mudanças de movimentação ou renomeação de arquivos (ou mais expecificos abaixo)
    - :fire: [fire] Remover
    - :truck: [truck] Mover
    - :repeat: [repeat] Renomear
  - :soon: [soon] Lista de ideias (tasks)
  - :pencil: [pencil] Texto
  - :fire: [fire] Removendo um arquivo

## 💻 Exemplos

<table>
  <thead>
    <tr>
      <th>Tipo do commit</th>
      <th>Emoji</th>
      <th>Palavra-chave</th>
      <th>exemplo</th>
    </tr>
  </thead>
<tbody>
  <tr>
    <td><code>commit inicial</code></td>
    <td>:tada:</td>
    <td>cell3_3</td>
    <td>cell3_3</td>
  </tr>
  <tr>
    <td><code>docs</code></td>
    <td>cell2_3</td>
    <td>cell3_3</td>
    <td>cell3_3</td>
  </tr>
  <tr>
    <td><code>build</code></td>
    <td>cell2_2</td>
    <td>cell3_2</td>
    <td>cell3_2</td>
  </tr>
    <tr>
    <td><code>style</code></td>
    <td>cell2_2</td>
    <td>cell3_2</td>
    <td>cell3_2</td>
  </tr>
    <tr>
    <td><code>merge</code></td>
    <td>cell2_2</td>
    <td>cell3_2</td>
    <td>cell3_2</td>
  </tr>
  <tr>
    <td><code>acervo</code></td>
    <td>cell2_2</td>
    <td>cell3_2</td>
    <td>cell3_2</td>
  </tr>
  <tr>
    <td><code>feat</code></td>
    <td>cell2_1</td>
    <td>cell3_1</td>
    <td>cell3_1</td>
  </tr>
  <tr>
    <td><code>fix</code></td>
    <td>cell2_2</td>
    <td>cell3_2</td>
    <td>cell3_2</td>
  </tr>
  <tr>
    <td><code>test</code></td>
    <td>cell2_2</td>
    <td>cell3_2</td>
    <td>cell3_2</td>
  </tr>
  <tr>
    <td><code>perf</code></td>
    <td>cell2_2</td>
    <td>cell3_2</td>
    <td>cell3_2</td>
  </tr>
  <tr>
    <td><code>refactor</code></td>
    <td>cell2_2</td>
    <td>cell3_2</td>
    <td>cell3_2</td>
  </tr>
  <tr>
    <td><code>chore</code></td>
    <td>cell2_2</td>
    <td>cell3_2</td>
    <td>cell3_2</td>
  </tr>
  <tr>
    <td><code>ci</code></td>
    <td>cell2_2</td>
    <td>cell3_2</td>
    <td>cell3_2</td>
  </tr>
  <tr>
    <td><code>raw</code></td>
    <td>cell2_2</td>
    <td>cell3_2</td>
    <td>cell3_2</td>
  </tr>
  </tdoby>
</table>
