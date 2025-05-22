# ac/globalnewsroom

Este diretório contém os arquivos de scripts e estilos relacionados aos componentes de notícias e artigos do projeto, organizados para uso modular em diferentes seções do site.

## Estrutura

- **archive/**  
  Scripts e estilos para funcionalidades de arquivo/histórico de notícias.
  - `archive/scripts/archive.js`
  - `archive/styles/archive.css`

- **articles/**  
  Scripts e estilos para páginas de artigos e sua apresentação.
  - `articles/scripts/articles.js`
  - `articles/styles/articles.css`

- **home/**  
  Scripts e estilos para o componente principal da Newsroom na página inicial.
  - `home/scripts/newsroom.js`
  - `home/styles/newsroom.css`

```{}
structure = [
    "ac/globalnewsroom/1/pt_BR/archive/scripts/",
    "ac/globalnewsroom/1/pt_BR/archive/styles/",
    "ac/globalnewsroom/1/pt_BR/articles/scripts/",
    "ac/globalnewsroom/1/pt_BR/articles/styles/",
    "ac/globalnewsroom/1/pt_BR/home/scripts/",
    "ac/globalnewsroom/1/pt_BR/home/styles/",
    "ac/globalnewsroom/1/pt_BR/archive/scripts/archive.js",
    "ac/globalnewsroom/1/pt_BR/archive/styles/archive.css",
    "ac/globalnewsroom/1/pt_BR/articles/scripts/articles.js",
    "ac/globalnewsroom/1/pt_BR/articles/styles/articles.css",
    "ac/globalnewsroom/1/pt_BR/home/scripts/newsroom.js",
    "ac/globalnewsroom/1/pt_BR/home/styles/newsroom.css",
]
# Função para criar a estrutura da pasta
createdir(structure=structure)
```


## Organização

Os arquivos estão separados por função e tipo (script ou style), facilitando manutenção e reutilização dos componentes de interface para notícias, artigos e arquivos históricos.

---

> **Nota:**  
> Mantenha este padrão de organização ao adicionar novos componentes.  
> Cada subpasta deve conter apenas arquivos diretamente relacionados à sua respectiva funcionalidade.

