# Instruções Gerais do Projeto Estatística

## 🎯 Estrutura do Projeto

```
estatistica/
├── backend/          # Python backend (scripts e automações)
├── book/             # Conteúdo dos livros (HTML gerado)
├── books/            # Fonte dos livros (Quarto/markdown)
├── ac/               # Assets compartilhados (CSS, JS)
├── sd/               # Static data (imagens, favicons)
├── newshub/          # Sistema de notícias
└── pages/            # Páginas institucionais
```

---

## 🎯 Objetivo do Projeto

Plataforma web educacional para ensino de Estatística com:
- Livros didáticos interativos (Quarto)
- Sistema de notícias (NewsHub)
- Aplicações práticas (IRA Calculator, etc)
- Conteúdo institucional

---

## 🛠️ Tecnologias Principais

### Backend
- **Python 3.10+** - Scripts e automações
- **BeautifulSoup4** - Manipulação HTML
- **Pathlib** - Gerenciamento de arquivos

### Frontend
- **HTML5** - Estrutura semântica
- **CSS3** - Estilização (custom properties, flexbox, grid)
- **Vanilla JavaScript** - Interatividade (sem frameworks pesados)

### Geração de Conteúdo
- **Quarto** - Livros e documentação técnica
- **Markdown** - Conteúdo textual

---

## 📊 Dependências Importantes

### Python
- `beautifulsoup4` - Parser HTML
- `pathlib` - Manipulação de caminhos (stdlib)
- `typing` - Type hints (stdlib)
- `json` - Manipulação JSON (stdlib)

### CSS/JS
- Sem frameworks pesados
- Preferir soluções nativas
- Custom properties para temas

---

## 🔍 Arquivos de Configuração

- `ac_head_dependencies.json` - Dependências de head por tipo de página
- `.editorconfig` - Formatação consistente
- `.vscode/settings.json` - Configurações do VS Code
- `.github/copilot/` - Instruções modulares do Copilot

---

## 💡 Comandos Úteis do Projeto

```bash
# Atualizar head de livros
python ./backend/src/scripts/site_html_manager.py --only-head --path ./book/

# Executar testes
python ./backend/src/scripts/test_head_manager.py

# Validar HTML (dry-run)
python ./backend/src/scripts/site_html_manager.py --only-head --dry-run --path ./

# Atualizar todos os componentes
python ./backend/src/scripts/site_html_manager.py --update-all --path ./
```

---

## 🌍 Idioma

- **Código:** Variável em inglês, funções em português quando faz sentido
- **Comentários:** Português (pt-BR)
- **Documentação:** Português (pt-BR)
- **Commits:** Português (pt-BR)
- **README:** Português (pt-BR)

---

## 📚 Referências Úteis

- [PEP 8](https://pep8.org/) - Python Style Guide
- [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)
- [Quarto Documentation](https://quarto.org/)
- [HTML5 Semantic Elements](https://www.w3schools.com/html/html5_semantic_elements.asp)

---

**Última atualização:** 1 de outubro de 2025
