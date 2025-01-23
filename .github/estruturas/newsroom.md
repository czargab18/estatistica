## **Posts**

Destinado a criar `automação falça`com Python para facilitar o processo de criação de artigos em html. Não desejo precisar criar API's ou paineis para redatóres, que seriam mais difíceis.

O objetivo é evitar páginas dinâmicas.

### Estrutura da pasta `post`

```{sh}
posts/
  ├── lista-artigos.json
  ├── article/
  │  │   └── ...arquivos...
  └── python/
    ├── funcoes.py        # funções auxiliares
    └── automacao.py      # Script que faz a automacao funcionar
```

## Bom, ele funcionará da seguinte maneira

1. O conteúdo do artigo e seus complementos (imagens, códigos LaTeX, etc.) ficaram em uma subpasta chamada `posts/article/` usada como pasta `teporaria` para a automação falça.
   ```{}
     artigo/
     │  └───identificador.txt
     │  |─── /src/
     │  │  │  │  └─── hero-imag-1.png
     │  │  │  │  └─── hero-imag-2.png
     │  │  │  │  └─── formula-1.png
     │  │  │  │  └─── formula-2.png
     │  │  │  │  └─── códigos-artigo.tex
   ```

- _Obs1_: destinado ao conteúdo do artigo explicado em [2.](#segundo-item-2)

- _Obs2_: As imagens **hero-imag-\*.png** são imagens de destaque (Hero Image). As imagens **formula-\*.png** são imagens de alguma fórmula LaTeX usada no artigo. Já o **códigos-artigo.tex** destina-se a ser um arquivo .tex contendo todo os códigos de cada fórmula usada no site, que poderá ser baixado.

2. Escrevo o conteúdo em um txt bem esctruturado, chamado **identificador
.txt** com a seguinte estrutura de conteúdo:

2. Escrevo ovo ovo o  conteúdsrc e
   - Titulo: Titulo do artigo
   - Subttulo: subtitulo do artigo
   - Imagem: Imagem de Destaque (Hero Image)
   - Conteudo do artigo:
     - Introdução
     - Desenvolvimento
     - Conclusão ou Resumo
     - Referências: Links e Recursos Complementares
   - Rodapé: textos explicativos sobre determinado conteúdo.

   Obs: Os conteúdos devem ser separados por tags html, exemplo: `<h1>Titulo</h1>`, `<h2>Subtitulo</h2>`,... `<p introd>texto</p introd>`,...

3. Posso escrever o conteúdo do meu artigo em um **`bloco de notas`**, ou outro editor. Usar o Python para ler essa pasta `article`, contendo os arquivo, que seram usados automatizar o processo de escrita de código html do artigo. O HTML5 do artigo gerado deve ser salvo dentro da pasta `/newsroom/articles/pt_BR/`. Veja o exmplo:

   ```{sh}
    /newsroom/articles/pt_BR/20xx/Z/identificador/index.html
   ```

   - Onde `20xx` se refere ao ano que o artigo foi escrito
   - Onde `z` se refere ao mês, onde $z = {1,2,3,...,12}$ e e cada indice representa um mês sendo Janeiro o número 1 e Dezembro o 12.

4. Os títulos e links para esses arquivos devem ser salvos em um arquivo chamado `articles.json`, contendo a seguinte estrutura:

    ```{sh}
        {
          "d5cb61509": {
            "identificador": "d5cb61509",
            "titulo": "titulo do artigo 1",
            "código": "CODE-disciplina",
            "disciplina": "NOME-disciplinas",
            "descrição": "conteúdo do subtitulo",
            "data": "data do artigo 1",
            "path": "/newsroom/articles/pt_BR/20xx/z/identificador/index.html",
            "tags": [
              "tag1",
              "tag2",
              "tag3"
            ]
          },
        }
    ```

5. Haverá uma automação que atualiza a `articles.json`. O novo artigo é adicionado como primeiro elemento nesse arquivo.

6. Após o processo encerrar, esses conteúdos serão excluídos(exceto a pasta `templates`).

## Pesquisa por artigos

Consistirá em usar o arquivo `articles.json` para fazer as pesquisas.

## Estrutura da Pasta de redação

```
  ├─── newsroom/
  │   └─── index.html
  │   ├─── articles/
  │   │   ├─── pt_BR/
  │   │   │   ├─── 20xx/                 # Ano 20xx
  │   │   │   │   ├─── 1/                # Mês de Janeiro
  │   │   │   │   │   └── identificador
  │   │   │   │   │   │   ├─── src/ 
  │   │   │   │   │   │   │   └─── hero-image-1.png
  │   │   │   │   │   │   │   └─── hero-image-2.png
  │   │   │   │   │   │   │   └─── formula-1.png
  │   │   │   │   │   │   │   └─── formula-2.png
  │   │   │   │   │   │   └─── index.html
  │   │   │   └─── strutura.txt
  │   ├─── assets/                    # CSS e JS dos artigos postados
  │   │   ├─── pt_BR/
  │   │   │   ├─── archive/
  │   │   │   │   ├─── scripts/
  │   │   │   │   │    └─── archive.js
  │   │   │   │   ├─── styles/
  │   │   │   │   │   └─── archive.css
  │   │   │   ├─── home/
  │   │   │   │   ├─── scripts/
  │   │   │   │   │    └─── home.js
  │   │   │   │   ├─── styles/
  │   │   │   │   │   └─── home.css
  │   │   │   ├─── articles/
  │   │   │   │   ├─── scripts/
  │   │   │   │   │    └─── articles.js
  │   │   │   │   ├─── styles/
  │   │   │   │   │   └─── articles.css
```
