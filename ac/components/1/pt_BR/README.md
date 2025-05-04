# Components

Esta pasta contém os componentes reutilizáveis do projeto. Cada arquivo aqui representa uma parte independente e modular que pode ser incluída em diferentes páginas ou seções da aplicação.

## Estrutura dos Componentes

- **`globalheader.html`**  
  Contém o código relacionado ao cabeçalho global do site. Inclui elementos como logotipo, barra de navegação principal e links importantes.

- **`globalnavbar.html`**  
  Contém o código da barra de navegação global, com menus e links que facilitam a navegação entre diferentes seções do site.

- **`globalsection_ribbon.html`**  
  Contém o código para a faixa (ribbon) global usada em seções específicas do site para destacar informações importantes.

- **`globalfooter.html`**  
  Contém o código relacionado ao rodapé global do site. Inclui informações de copyright, links úteis, e redes sociais.

## Como Usar

1. **Incluir Componentes em Outras Páginas:**  
   Utilize a tecnologia ou framework do projeto (como PHP, React, Vue, ou mesmo JavaScript puro) para incluir esses componentes nas páginas onde forem necessários. Por exemplo:
   - Em PHP: `<?php include 'components/globalheader.html'; ?>`
   - Em JavaScript: Carregue o conteúdo dinamicamente via AJAX ou Fetch.

2. **Manutenção Centralizada:**  
   Atualize qualquer componente diretamente nesta pasta para que as mudanças sejam refletidas em todas as páginas que utilizam esse componente.

## Boas Práticas

- **Componentes Modulares:**  
  Certifique-se de que cada componente seja independente e focado em uma funcionalidade específica. Evite adicionar código que dependa de outro componente diretamente.

- **Nomes Significativos:**  
  Nomeie os arquivos de forma clara e descritiva, como já demonstrado neste projeto.

- **Testar Alterações:**  
  Sempre teste as alterações feitas em um componente para garantir que ele funcione corretamente em todas as páginas onde está incluído.

## Sobre

Essa pasta foi criada para facilitar a manutenção e reutilização de blocos de código usados em diferentes partes do site. Caso tenha dúvidas ou sugestões, entre em contato com o responsável pelo projeto.