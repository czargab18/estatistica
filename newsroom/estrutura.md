# Estrutura da Pasta de redação
```
├─── newsroom/
│   └─── index.html
│   ├─── articles/
│   │   ├─── pt_BR/
│   │   │   ├─── 20xx/                 # Ano 20xx 
│   │   │   │   ├─── 1/                # Mês de Janeiro
│   │   │   │   │    └─── nome-do-artigo.html
│   │   │   │   ├─── 10/              # Mês de Outubro
│   │   │   │   │   └─── nome-do-artigo.html
│   │   │   │   │   └─── nome-do-artigo.html
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
Suponha que tenhamos um template de um artigo bem configurado.

Possibilidade:
1. Psso escrever o conteúdo do meu artigo em um **``documento google``** fazer o script.py ler esse arquivo e criar uma versão do template adicionando os textos desse documento.

2. Posso salvar os conteúdos dos meus arquivos dentro de uma pasta bem estruturada para automatizar processos.
    ```{}
      artigo/
      │  │   └───nome-do-artigo.txt # ou .doc com o conteudo
      │  └─── imagens/ # 
      │  │ └─── nome-imagem-1.png/ # 
      │  │ └─── nome-imagem-2.png/ # 
      │  │ └─── nome-imagem-3.png/ #
      │  └─── formulas/ # 
      │  │ └─── formula-latex-1.png #  Imagem
      │  │ └─── formula-latex-1.tex #  Código Latex
      │  │ └─── formula-latex-2.png #  Imagem 2
      │  │ └─── formula-latex-2.tex #  Código 2 Latex
    ```

    onde `nome-do-artigo.txt` Onde os blocos devem ser separados por `<p>` e `</p>` para inicio e fim do blogo de paragrafo.
    
    Por `<img src="nome-da-imagem">` o local e o nome da imagem

    Por `<caption>` ....

    Adicionar essa pasta de um artigo especifi e jogar no diretório para o Python ler e Automatizar o processo. Depois de terminar o processo a pasta é apagada automaticamente

3. Consiste no passo [2.]() mas usando uma API criada mas com senha para ser usada.

### Estrutura da pasta `post` 

```
posts/
```