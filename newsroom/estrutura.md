# Estrutura da Pasta de redação
```
├─── newsroom/
│   └─── index.html
│   ├─── articles/
│   │   ├─── pt_BR/
│   │   │   ├─── 20xx/                 # Ano 20xx 
│   │   │   │   ├─── 1/                # Mês de Janeiro
│   │   │   │   │   └─── nome-do-artigo
│   │   │   │   │   │    └─── index..html
│   │   │   │   ├─── 10/              # Mês de Outubro
│   │   │   │   │   └─── nome-do-artigo
│   │   │   │   │   │    └─── index..html
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
│   ├─── images/                    # Destinado a Armagenas imagens dos artigos
│   │   ├─── pt_BR/
│   │   │   ├─── Banners/
│   │   │   │   ├─── 2025/ # 
│   │   │   │   │   ├─── 1/                # Mês de Janeiro
│   │   │   │   │   │    └─── nome-artigo-nome-imge.png
│   │   │   │   │   │    └─── nome-artigo-nome-imge.png
│   │   │   │   │   ├─── 10/                # Mês de Outubro
│   │   │   │   │   │    └─── nome-artigo-nome-imge.png
│   │   │   │   │   │    └─── nome-artigo-nome-imge.png
```


## Pasta **posts**
Destinado a criar scripts python para tornar mais fácil o processo de criação das postagens. 

### Exemplo
Suponha que tenhamos um template de um artigo.html bem configurado.

Possibilidade:
1. Posso escrever o conteúdo do meu artigo em um **``bloco de notas``** e usar o Python para ler esse arquivo e automatizar o processo de escrita de código html do artigo.

2. Posso salvar os conteúdos dos meus arquivos dentro de uma pasta bem estruturada para automatizar processos.
    ```{}
      artigo/
      │  └───nome-do-artigo.txt # com o conteúdo
      │  |─── imagens-formulas/ # 
      │  │ └─── nome-imagem-1.png
      │  │ └─── formula-img-2.png
      │  │ └─── formula-img-3.png
      │  │ └─── nome-imagem-4.png 
      │  │ └─── nome-imagem-5.png
      │  │ └─── todas_as_formula_em_LaTeX.tex
    ```

    onde `nome-do-artigo.txt` deve ser utilizado. Os blocos devem ser separados por `<p>` e `</p>` para indicar o início e o fim de um parágrafo.

    Utilize `<img src="nome-da-imagem">` para inserir imagens, especificando o local e o texto alternativo.

    Adicione essa pasta de um artigo específico no diretório para que o Python possa ler e automatizar o processo. Após a conclusão do processo, a pasta será apagada automaticamente.

    Poderia salvar as disciplinas em um **`.json`** contento a estrutura de "recentes" e "antigos". Se eu publicar novos artigos e a quantidade de artigos em recentes for maior que um valor X, o conteudo mais antigo será transferido e adiciona no topo do "antigo", e o novo artigo e adicionado ao topo de "recentes".

3. Consiste no passo [2.]() mas usando uma API criada mas com senha para ser usada.

### Estrutura da pasta `post` 

```
posts/
├── lista-artigos.json
├── article/
│   └── ...arquivos...
└── python/
  ├── funcoes.py        # funções auxiliares
  └── automacao.py      # Script que faz a automacao funcionar
```

## Pesquisa por artigos

Usar a estrutura de **`lista-artigos.json`** para pesquisar