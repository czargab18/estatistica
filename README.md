# Estatística

**Plataforma educacional de estatística** - Uma plataforma web completa para ensino e aprendizado de estatística, hospedada em [www.estatistica.pro](https://www.estatistica.pro).

## Sobre o Projeto

Este projeto implementa uma plataforma educacional abrangente que combina:
- **Livros e cursos interativos** gerados com Quarto
- **Sistema de componentes reutilizáveis** para desenvolvimento web
- **Plataforma de notícias e artigos** (Newsroom/NewsHub)
- **Aplicações interativas** para cálculos estatísticos
- **Sistema de backend** para processamento de dados

## Estrutura do Projeto

### 📚 **Conteúdo Educacional**
- **`book/`** - Cursos e livros de estatística
  - `CIC0007/` - Curso de Introdução à Ciência da Computação
  - `EST0033/` - Curso de Estatística
  - `MAT0075/` - Curso de Matemática
  - `TAS0000/` - Curso de Técnicas de Amostragem
- **`books/`** - Recursos adicionais de livros

### 🛠️ **Componentes e Assets**
- **`ac/`** - Assets and Components (Sistema de componentes reutilizáveis)
  - Componentes globais (header, navbar, footer, etc.)
  - Scripts e estilos organizados por funcionalidade
  - [📖 Documentação detalhada](ac/README.md)

### 📰 **Sistema de Notícias**
- **`newsroom/`** - Sistema Argo para criação de artigos com Quarto
  - [📖 Documentação do Newsroom](newsroom/README.md)
- **`newshub/`** - Hub de distribuição de notícias

### 💻 **Aplicações**
- **`apps/`** - Aplicações interativas
  - `ira/` - Calculadora de Índice de Rendimento Acadêmico
  - [📖 Documentação das Apps](apps/ira/README.md)

### 🔧 **Infraestrutura**
- **`backend/`** - Sistema backend em Python
- **`pages/`** - Páginas estáticas do site
- **`sd/`** - Static data (favicons, recursos estáticos)
- **`wss/`** - Web Style Sheets
- **`errors/`** - Páginas de erro
- **`sitemap/`** - Mapeamento do site

## Tecnologias Utilizadas

- **Frontend**: HTML5, CSS3, JavaScript
- **Geração de Conteúdo**: [Quarto](https://quarto.org/) para livros e artigos
- **Backend**: Python
- **Arquitetura**: Sistema de componentes modulares
- **Deploy**: GitHub Pages

## Como Começar

### Pré-requisitos
- Quarto instalado (para geração de conteúdo)
- Python 3.x (para scripts backend)
- Navegador web moderno

### Estrutura de Desenvolvimento

1. **Para trabalhar com componentes**: Consulte [`ac/README.md`](ac/README.md)
2. **Para criar artigos**: Consulte [`newsroom/README.md`](newsroom/README.md)  
3. **Para desenvolver apps**: Consulte [`apps/ira/README.md`](apps/ira/README.md)

### Desenvolvimento Local

```bash
# Clone o repositório
git clone https://github.com/czargab18/estatistica.git
cd estatistica

# Para servir localmente (recomendado usar um servidor HTTP local)
python -m http.server 8000
# ou
npx serve .
```

## Arquitetura dos Componentes

O projeto utiliza um sistema de componentes modulares localizado em `ac/`. Cada componente pode ser reutilizado em diferentes páginas através de scripts Python que substituem marcadores HTML.

**Exemplo de uso:**
```html
<!-- Marcador no HTML -->
<!-- #GLOBALNAVBAR# -->

<!-- Será substituído pelo conteúdo de ac/components/globalnavbar.html -->
```

## Sistema de Notícias (Argo)

O sistema Argo permite criar artigos usando Quarto (.qmd) e publicá-los automaticamente como HTML. Os artigos são organizados por:
- **Idioma** (pt_BR)
- **Ano e mês** de publicação
- **Código único** do artigo

## Contribuindo

1. **Fork** o projeto
2. **Crie** uma branch para sua feature (`git checkout -b feature/nova-feature`)
3. **Commit** suas mudanças (`git commit -am 'Adiciona nova feature'`)
4. **Push** para a branch (`git push origin feature/nova-feature`)
5. **Abra** um Pull Request

### Padrões de Código
- Mantenha a estrutura de componentes modulares
- Documente novos componentes no README correspondente
- Use comentários em código quando necessário
- Siga a estrutura de pastas existente

## Documentação Adicional

- [Componentes Reutilizáveis](ac/README.md)
- [Sistema Newsroom](newsroom/README.md)
- [Aplicação IRA](apps/ira/README.md)
- [Global News Components](ac/globalnewsroom/README.md)

## Suporte e Contato

Para dúvidas, sugestões ou contribuições:
- **Issues**: [GitHub Issues](https://github.com/czargab18/estatistica/issues)
- **Discussões**: [GitHub Discussions](https://github.com/czargab18/estatistica/discussions)
- **Website**: [www.estatistica.pro](https://www.estatistica.pro)

## Licença

Este projeto é desenvolvido para fins educacionais. Para mais informações sobre uso e distribuição, consulte os mantenedores do projeto.

---

**Estatística** - Plataforma educacional para ensino de estatística e ciências relacionadas.