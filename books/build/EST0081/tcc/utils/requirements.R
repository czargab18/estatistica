if (!requireNamespace("pacman", quietly = TRUE)) {
    install.packages("pacman")
}

packages <- c("tinytex")
pacman::p_load(char = packages)

# Instalar uma lista de pacotes.
tinytex::tlmgr_install(c(
  # Pacotes básicos
  "amsmath", # Fórmulas matemáticas
  "amssymb", # Símbolos matemáticos adicionais
  "babel-portuges", # Suporte ao português (hifenização e tradução)
  "inputenc", # Codificação de caracteres (utf8)
  "fontenc", # Codificação de fontes
  "lmodern", # Fonte Latin Modern (melhor para PDF)

  # Pacotes avançados
  "xparse", # Criação de comandos personalizados
  "pgf", # Criação de gráficos vetoriais diretamente em LaTeX
  "tikz", # Ferramenta avançada para diagramas e gráficos
  "float", # Controle avançado de posicionamento de figuras e tabelas
  "setspace", # Controle de espaçamento entre linhas
  "parskip", # Controle de espaçamento entre parágrafos
  "enumitem", # Personalização de listas numeradas e com marcadores
  "microtype", # Ajustes tipográficos automáticos (melhora a aparência do texto)
  "textpos", # Posicionamento absoluto de elementos na página
  "titlesec", # Personalização avançada de títulos de seções
  "adjustbox", # Ajuste de tamanho e alinhamento de caixas de conteúdo
  "background", # Adicionar marcas d'água ou fundos personalizados
  "fancyvrb", # Formatação avançada para códigos e verbatim
  "xurl", # Quebra de URLs longas em hiperlinks
  "pdfpages", # Inclusão de páginas PDF no documento
  "ifthen", # Condições em comandos
  "etoolbox", # Utilitários para manipulação de comandos

  # Pacotes para tabelas e figuras
  "tabularx", # Criação de tabelas ajustáveis
  "longtable", # Tabelas que ocupam várias páginas
  "xcolor", # Suporte para cores em tabelas e textos
  "array", # Controle avançado de formatação de tabelas
  "multicol", # Layouts de múltiplas colunas
  "tcolorbox", # Criação de caixas de texto personalizadas
  "booktabs", # Tabelas estilizadas
  "graphicx", # Inserção de gráficos e imagens
  "grffile", # Suporte para arquivos de imagem com nomes complexos
  "subcaption", # Subfiguras e sublegendas
  "subfigure", # Subfiguras

  # Pacotes para interatividade e formulários
  "hyperref", # Criação de hiperlinks e campos de formulário clicáveis

  # Pacotes para bibliografia
  "biblatex", # Gerenciamento de bibliografia moderna
  "natbib", # Sistema de citações autor-ano

  # Pacotes utilitários
  "caption", # Personalização de legendas
  "fancyhdr", # Personalização de cabeçalhos e rodapés
  "geometry", # Ajuste de margens
  "indentfirst", # Indentar o primeiro parágrafo
  "lipsum", # Texto de exemplo
  "tocbibind", # Inclusão de bibliografia e apêndices no índice
  "pdflscape", # Páginas em modo paisagem
  "nextpage", # Forçar quebra de página
  "bm", # Negrito em fórmulas matemáticas

  # Dependências de alguns pacotes
  "everypage",
  "pgf",
  "hyphen-portuguese",
  "abntex2cite",
  "breakurl",
  "abntex2",
  "memoir",
  "xpatch",
  "textcase",
  "csvsimple",
  "anyfontsize"
))