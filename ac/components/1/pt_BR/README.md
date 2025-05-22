# Components

Esta pasta reúne os componentes reutilizáveis do projeto. Cada arquivo representa uma parte modular e independente, podendo ser incluído em diferentes páginas ou seções do site para garantir consistência visual e facilitar a manutenção.

## Estrutura dos Componentes

- **`globalheader.html`**  
  Cabeçalho global do site, incluindo logotipo, barra superior e links principais.

- **`globalnavbar.html`**  
  Barra de navegação global, com menus e links para as principais seções do site.

- **`globalsection_ribbon.html`**  
  Faixa (ribbon) de destaque, utilizada para chamar atenção para informações importantes em determinadas seções do site.

- **`globalfooter.html`**  
  Rodapé global do site, com informações institucionais, copyright, links úteis e redes sociais.

## Como Utilizar

1. **Inclusão dos Componentes em HTML Puro**

   Para reutilizar componentes em várias páginas HTML, automatize a inclusão usando scripts Python. Por exemplo, você pode criar um script para inserir o conteúdo dos componentes nas páginas desejadas antes do deploy.

   Exemplo básico em Python:
   ```python
   # Exemplo: inserir globalnavbar.html em várias páginas
   with open('components/globalnavbar.html', 'r') as nav:
       navbar = nav.read()

   with open('pagina.html', 'r') as f:
       conteudo = f.read()

   conteudo = conteudo.replace('<!-- #GLOBALNAVBAR# -->', navbar)

   with open('pagina.html', 'w') as f:
       f.write(conteudo)
   ```
   Basta definir marcadores HTML como `<!-- #GLOBALNAVBAR# -->` onde quiser inserir os componentes.

2. **Automação e Atualização**

   Atualize os componentes nesta pasta. Em seguida, rode seu script Python para atualizar todas as páginas HTML automaticamente, garantindo que as mudanças estejam presentes em todo o site.

## Sobre

Esta pasta foi criada para facilitar a manutenção e a reutilização de blocos de código em diferentes partes do site.  
Em caso de dúvidas ou sugestões, entre em contato com o responsável pelo projeto.