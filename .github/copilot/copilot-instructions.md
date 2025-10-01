# GitHub Copilot - Instruções do Projeto Estatística

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

## 📝 Convenções de Código

### Python
- ✅ Seguir **PEP 8** rigorosamente
- ✅ Usar **type hints** em todas as funções públicas
- ✅ Docstrings em formato **Google Style**
- ✅ Preferir `pathlib.Path` ao invés de `os.path`
- ✅ Usar f-strings para formatação de strings
- ✅ Encoding UTF-8 explícito em arquivos
- ✅ Tratamento de exceções específico (não usar `except Exception` genérico)

**Exemplo:**
```python
from pathlib import Path
from typing import Optional

def processar_arquivo(caminho: Path, modo: str = "r") -> Optional[str]:
    """
    Processa um arquivo e retorna seu conteúdo.
    
    Args:
        caminho: Caminho para o arquivo
        modo: Modo de abertura (padrão: "r")
        
    Returns:
        Conteúdo do arquivo ou None se falhar
        
    Raises:
        FileNotFoundError: Se o arquivo não existir
    """
    try:
        with open(caminho, modo, encoding="utf-8") as f:
            return f.read()
    except FileNotFoundError:
        print(f"❌ Arquivo não encontrado: {caminho}")
        return None
```

### JavaScript/TypeScript
- ✅ Usar **ES6+** features
- ✅ Preferir `const`/`let`, **nunca `var`**
- ✅ Usar arrow functions quando apropriado
- ✅ async/await ao invés de `.then()`
- ✅ Template literals ao invés de concatenação

### HTML/CSS
- ✅ HTML5 semântico
- ✅ Classes descritivas (BEM ou similar)
- ✅ Mobile-first responsivo
- ✅ Acessibilidade (ARIA labels quando necessário)
- ✅ Comentários para seções principais

### Commits Git
- ✅ Mensagens em **português (pt-BR)**
- ✅ Formato: `tipo(escopo): descrição`
- ✅ Tipos válidos: `feat`, `fix`, `docs`, `style`, `refactor`, `test`, `chore`
- ✅ Descrição clara e concisa (max 72 caracteres no título)

**Exemplos:**
```
feat(head): adiciona links SEO automáticos para livros
fix(header): corrige erro de encoding em caracteres especiais
docs(readme): atualiza exemplos de uso da CLI
refactor(head): simplifica lógica de detecção de páginas
test(head): adiciona testes para extração de links SEO
```

---

## 🚫 Padrões de Edição

### ✅ SEMPRE FAZER

1. **Modificar arquivos existentes diretamente**
   - ❌ Não deletar e recriar arquivos para atualizar
   - ✅ Usar `replace_string_in_file` ou editar in-place

2. **Consolidar documentação**
   - ✅ Tudo no README.md principal
   - ❌ Não criar múltiplos .md (CHANGELOG.md, GUIDE.md, EXAMPLES.md)
   - ✅ Usar seções bem estruturadas com emojis
   - ✅ Histórico de versões no final do README

3. **Mostrar apenas mudanças relevantes**
   - ✅ Usar `...existing code...` para código inalterado
   - ✅ Mostrar apenas as seções modificadas
   - ✅ Incluir 3-5 linhas de contexto antes/depois

4. **Explicar o PORQUÊ, não apenas o QUÊ**
   - ✅ "Mudei X para Y porque Z estava causando erro de encoding"
   - ❌ "Mudei X para Y"

5. **Adicionar testes para funcionalidades críticas**
   - ✅ Testes unitários para funções de negócio
   - ✅ Testes de integração quando necessário
   - ✅ Coverage mínimo de 80% para código novo

### ❌ NUNCA FAZER

1. Deletar e recriar arquivos apenas para atualizar conteúdo
2. Criar múltiplos arquivos markdown para documentação
3. Usar práticas obsoletas (Python 2 syntax, `var` em JS, etc)
4. Ignorar tratamento de erros
5. Sugerir mudanças sem explicar o motivo
6. Usar `except Exception` genérico sem relancar
7. Hardcodar caminhos (usar pathlib e configurações)

---

## 🧪 Testes

### Estrutura
```python
# Arquivo: test_nome_modulo.py

def test_funcao_caso_sucesso():
    """Testa caso de sucesso da função"""
    resultado = funcao(input_valido)
    assert resultado == esperado

def test_funcao_caso_erro():
    """Testa tratamento de erro"""
    with pytest.raises(ValueError):
        funcao(input_invalido)
```

### Executar
```bash
# Teste específico
python test_head_manager.py

# Todos os testes
pytest backend/actions/run/

# Com coverage
pytest --cov=backend backend/actions/run/
```

---

## 📊 Dependências Importantes

### Python
- `beautifulsoup4` - Parser HTML
- `pathlib` - Manipulação de caminhos (stdlib)
- `typing` - Type hints (stdlib)
- `json` - Manipulação JSON (stdlib)

### JavaScript
- Vanilla JS (sem frameworks pesados)
- Evitar dependências externas quando possível

### CSS
- Custom properties (`--var-name`)
- Flexbox e Grid para layout
- Mobile-first media queries

---

## 🔍 SEO e Performance

- ✅ Meta tags completas em todas as páginas
- ✅ Links `rel="prev"/"next"` para paginação/navegação sequencial
- ✅ Títulos descritivos e únicos
- ✅ Otimizar imagens antes do commit (webp quando possível)
- ✅ Minificar CSS/JS em produção
- ✅ Lazy loading para imagens below the fold

---

## 🎨 Estilo de Código

### Formatação
- **Python**: 4 espaços, max 88 caracteres por linha (Black style)
- **JavaScript**: 2 espaços, max 120 caracteres
- **HTML/CSS**: 2 espaços
- **JSON**: 2 espaços

### Nomenclatura
- **Python**: `snake_case` para funções/variáveis, `PascalCase` para classes
- **JavaScript**: `camelCase` para funções/variáveis, `PascalCase` para classes
- **CSS**: `kebab-case` para classes e IDs
- **Arquivos**: `snake_case.py`, `kebab-case.html`, `PascalCase.tsx`

---

## 💡 Comandos Úteis do Projeto

```bash
# Atualizar head de livros
python backend/actions/run/site_html_manager.py --only-head --path ./book/

# Executar testes
python backend/actions/run/test_head_manager.py

# Validar HTML (dry-run)
python backend/actions/run/site_html_manager.py --only-head --dry-run --path ./

# Atualizar todos os componentes
python backend/actions/run/site_html_manager.py --update-all --path ./
```

---

## 🔧 Arquivos de Configuração

- `ac_head_dependencies.json` - Dependências de head por tipo de página
- `.editorconfig` - Formatação consistente entre editores
- `.vscode/settings.json` - Configurações do VS Code
- `.github/copilot-instructions.md` - Este arquivo

---

## 📚 Referências

- [PEP 8 - Python Style Guide](https://pep8.org/)
- [Google Python Style Guide](https://google.github.io/styleguide/pyguide.html)
- [Airbnb JavaScript Style Guide](https://github.com/airbnb/javascript)
- [HTML5 Semantic Elements](https://www.w3schools.com/html/html5_semantic_elements.asp)

---

**Última atualização:** 1 de outubro de 2025  
**Versão:** 1.0.0
