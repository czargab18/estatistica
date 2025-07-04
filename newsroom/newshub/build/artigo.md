---
# Referência: https://medium.com/@sydasif78/book-creation-with-pandoc-and-markdown-893c7d72cb35
title: "titulo exemplo"
description: "descrição do arqtigo"
canonical: "https://www.apple.com/newsroom/2025/06/titulo-do-artigo/"
lang: "pt-BR"
locale: "pt-BR"
author: ""
site_name: "nome do site"
type: "article"
date: "2025-07-04"
html_config:
  xmlns: "http://www.w3.org/1999/xhtml"
  xml_lang: "pt-BR"
  lang: "pt-BR"
  dir: "ltr"
  prefix: "og: http://ogp.me/ns#"
  classes: 
    - "globalheader-dark"
    - "js"
    - "no-touch" 
    - "svg"
    - "progressive-image"
    - "windows"
    - "no-edge"
includes:
  header_global: 
    file: "components/globalheader.html"
    position: "after_body_open"
    priority: 1
  footer_global: 
    file: "components/globalfooter.html"
    position: "before_body_close"
    priority: 1
  local_nav:
    file: "components/localnav.html" 
    position: "after_globalheader"
    priority: 2
  article_header:
    file: "components/article-header.html"
    position: "before_content"
    priority: 3
components:
  globalheader:
    enabled: true
    file: "components/globalheader.html"
    position: "after_body_open"
  globalmessage:
    enabled: true
    lang: "pt-BR"
    dir: "ltr"
  globalnav:
    enabled: true
    analytics_region: "global nav"
    store_api: "/[storefront]/shop/bag/status"
meta:
  viewport: "width=device-width, initial-scale=1, viewport-fit=cover"
  charset: "utf-8"
analytics:
  s_channel: "newsroom"
  s_bucket_0: "applestoreww"
  s_bucket_1: "applestoreww"
  s_bucket_2: "applestoreww"
  track: "Newsroom - titulo exemplo"
og:
  title: "titulo exemplo"
  description: "descrição do arqtigo"
  type: "article"
  site_name: "nome do site"
  locale: "pt_BR"
  url: "https://www.apple.com/newsroom/2025/06/titulo-do-artigo/"
  image: "https://www.apple.com/newsroom/images/2025/06/titulo-do-artigo/tile/imagem-exemplo.jpg.og.jpg?202507041300"
twitter:
  title: "titulo exemplo"
  description: "descrição do arqtigo"
  site: "@Apple"
  card: "summary_large_image"
  image: "https://www.apple.com/newsroom/images/2025/06/titulo-do-artigo/tile/imagem-exemplo.jpg.og.jpg?202507041300"
stylesheets:
  - "/ac/localnav/4/styles/ac-localnav.built.css"
  - "/ac/globalfooter/8/en_US/styles/ac-globalfooter.built.css"
  - "/www.apple.com/wss/fonts?families=SF+Pro,v3|SF+Pro+Icons,v3"
  - "/newsroom/styles/site.built.css"
  - "/newsroom/styles/articlev2.built.css"
scripts:
  - "/newsroom/scripts/newsroom-head.built.js"
---

# titulo exemplo

descrição do arqtigo

<!-- Conteúdo do artigo aqui -->