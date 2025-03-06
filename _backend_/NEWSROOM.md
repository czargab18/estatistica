# Documentação da pasta **\_backend\_/NEWSROOM** 

Esta pasta destinace a automatização relacionadas a publicação de artigos para a pasta na raiz do projeto ``estatistica/newsroom``.

## Estrutura de arquivos
```{plaintext}
./_backend_/NEWSROOM/
├── scripts
│   ├── /newsroom/
│   │   ├── /posts/
│   │   │   ├── /python/
│   │   │   │   ├── funcoes.py
│   │   │   |   └── script_automacao.py
│   │   │   ├── /article/
│   │   │   │   ├── /src/
│   │   │   │   │   ├── image.png
│   │   │   │   │   ├── formulas.tex
│   │   │   │   ├── article.txt
├── data
│   ├── avisos.json
│   ├── disciplinas.json
│   ├── eventos.json
│   └── articles.json
└── NEWSROOM.md
```

## Estrutua do artigo.txt
```{plaintext}
Titulo: Titulo exemplo ;
Subtitulo: Subtitulo exemplo ;
data: dia-da-publicação
autor: autor do artigo
tags: tag1, tag2, tag3, tag3
categoria: categoria do artigo
resumo: resumo do artigo
imagem: [
  /src/nome-imagem-1.png;
  /src/nome-imagem-2.png;
  /src/formulas-artigo.tex;
]

--- inicio Introdução ---
<p> Conteúdo do paragrafo 1;
<p> Conteúdo do paragrafo 2;
<p> Conteúdo do paragrafo 3;
<p> Conteúdo do paragrafo 4;
--- fim Introdução ---

--- inicio Desenvolvimento ---
<p> Conteúdo do paragrafo 1;
<a href="/src/formula-1.png">;
<p> Conteúdo do paragrafo 2;
<a href="/src/formula-2.png">;
<p> Conteúdo do paragrafo 3;
<a href="/src/formula-3.png">;
<p> Conteúdo do paragrafo 4;
--- fim Desenvolvimento ---

--- inicio Conclusão ---
<p> Conteúdo do paragrafo 1;
<p> Conteúdo do paragrafo 2;
<p> Conteúdo do paragrafo 3;
<p> Conteúdo do paragrafo 4;
--- fim Conclusão ---

--- inicio Rodapé ---
<p> Conteúdo do paragrafo 1;
<p> Conteúdo do paragrafo 2;
<a href="/src/nome-imagem.tex" download>
--- fim Rodapé ---
```