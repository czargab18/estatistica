# estatistica
[desenvolvimento]-Plataforma de ensino de estatística gratuitamente.

## Nomenclatura - Apple 
Estruturas para usar futuramente.

### main 
padrões main e seus conteudos usados pela apple.com em sua estrutura de website
- ``class="main"`` 
- ``role="main"`` O atributo é usado para indicar que um elemento contém o conteúdo principal de um documento.

#### section - in - main
- ``class="homepage-section collection-module"``: repete em case todas as sections dentro main. Entretando, a section de slide
  sobre tv-plus tem a ``class="homepage-section standalone-module"``.
- ``data-module-template="valor"`` A apple usa este atributo como "id" para as section. Os valores:
  - ribbon : indica que a seção funcionará como uma especie de fita, ou seja, a largura e altura teráo aparencia de fita.
  - heroes : contem as seções grandes que indicam produtos de destaque.
  - promos : contem as seções pequenas indicando outros produtos.
  - tv-plus-gallery : a seção é referente ao slide de conteudos do tv-plus.

Em `data-module-template="valor"` há 3 div dos 3 produtos em destaque. Cada div tem o seguinte atributo `data-unit-id="macbook-air-15"`,
onde `macbook-air-15` indica o conteudo da div.

 - div data-unit-id="macbook-air-15" 
   - div class="module-content"
      -  div class="unit-wrapper unit-wrapper-reset", onde *unit-wrapper* indica a *unidade de capa* e  * unit-wrapper-reset* é a *redefiniçã/repor unidade de capa*.
      - Abaixo dessa classe, temos :
         - a class="unit-link"
         - div class="unit-copy-wrapper" : textos da seção, como titulo, subtitulos e call-to-action (CTA)
            - h2 class="headline"
            - h3 class="subhead"
            - div cta-links
               - a class="icon icon-after icon-chevronright" e text: Saiba main
               - a class="icon icon-after icon-chevronright" e texto: compar
          - div class="unit-image-wrapper"
              - figure class="unit-image unit-image-macbook-air-15-hero-macbook-air-15-midnight"

    Para as outras seções como as como *data-module-template="promo*, pequenas seções, a estutura é a mesma.
