# Padrões de Testes

## 🧪 Framework e Estrutura

### Usar pytest
```bash
# Instalar pytest
pip install pytest pytest-cov

# Executar testes
pytest

# Com cobertura
pytest --cov=backend/actions/run --cov-report=html
```

---

## 📁 Organização de Arquivos

```
backend/actions/run/
├── htmltools/
│   ├── __init__.py
│   ├── head.py                 # Código fonte
│   └── test_head.py           # Testes do head.py
├── site_html_manager.py       # Código fonte
├── test_site_html_manager.py  # Testes do CLI
└── README.md
```

### Convenção de Nomenclatura
- Arquivo de teste: `test_<nome_do_modulo>.py`
- Classe de teste: `Test<NomeDaClasse>`
- Função de teste: `test_<comportamento_esperado>`

---

## ✅ Estrutura de Teste (AAA Pattern)

```python
import pytest
from pathlib import Path
from htmltools import DynamicHeadManager

def test_update_html_head_adiciona_links_seo():
    """
    Testa se links SEO (prev/next) são adicionados em páginas de livro.
    """
    # ARRANGE (Preparar)
    manager = DynamicHeadManager()
    html_path = Path("tests/fixtures/book_page.html")
    
    # ACT (Agir)
    sucesso, status = manager.update_html_head(
        str(html_path),
        adicionar_seo_links=True
    )
    
    # ASSERT (Verificar)
    assert sucesso is True
    assert "links SEO" in status
    
    with open(html_path, 'r', encoding='utf-8') as f:
        content = f.read()
        assert 'rel="prev"' in content
        assert 'rel="next"' in content
```

---

## 🎯 Tipos de Testes

### 1. Testes Unitários
Testam funções/métodos isoladamente.

```python
def test_is_book_page_detecta_livro():
    """Testa detecção de página de livro."""
    manager = DynamicHeadManager()
    
    # Testa caso positivo
    assert manager._is_book_page("/book/EST0033/textuais/cap1.html") is True
    
    # Testa caso negativo
    assert manager._is_book_page("/index.html") is False
```

### 2. Testes de Integração
Testam componentes trabalhando juntos.

```python
def test_update_html_head_fluxo_completo():
    """Testa fluxo completo de atualização do head."""
    manager = DynamicHeadManager()
    html_file = Path("tests/fixtures/sample.html")
    
    # Cria arquivo HTML de teste
    html_file.write_text("""
        <!DOCTYPE html>
        <html>
        <head><title>Test</title></head>
        <body>Content</body>
        </html>
    """, encoding='utf-8')
    
    # Atualiza o head
    sucesso, status = manager.update_html_head(str(html_file))
    
    # Verifica resultado
    assert sucesso is True
    content = html_file.read_text(encoding='utf-8')
    assert '<meta name="viewport"' in content
```

### 3. Testes Parametrizados
Testam múltiplos casos com mesma lógica.

```python
@pytest.mark.parametrize("caminho,esperado", [
    ("/book/EST0033/index.html", True),
    ("/book/MAT0075/textuais/cap1.html", True),
    ("/index.html", False),
    ("/pages/docente/index.html", False),
])
def test_is_book_page_casos_multiplos(caminho, esperado):
    """Testa detecção de livro com múltiplos casos."""
    manager = DynamicHeadManager()
    assert manager._is_book_page(caminho) is esperado
```

---

## 🔧 Fixtures e Setup

### Fixtures Simples
```python
@pytest.fixture
def manager():
    """Retorna instância de DynamicHeadManager."""
    return DynamicHeadManager()

@pytest.fixture
def html_vazio():
    """Retorna HTML vazio básico."""
    return """
        <!DOCTYPE html>
        <html>
        <head><title>Test</title></head>
        <body></body>
        </html>
    """

def test_exemplo_com_fixture(manager, html_vazio):
    """Teste usando fixtures."""
    assert manager is not None
    assert "<html>" in html_vazio
```

### Fixtures com Arquivos Temporários
```python
import tempfile
from pathlib import Path

@pytest.fixture
def temp_html_file():
    """Cria arquivo HTML temporário."""
    with tempfile.NamedTemporaryFile(
        mode='w',
        suffix='.html',
        encoding='utf-8',
        delete=False
    ) as f:
        f.write("<!DOCTYPE html><html><head></head><body></body></html>")
        temp_path = Path(f.name)
    
    yield temp_path  # Fornece o arquivo
    
    temp_path.unlink()  # Cleanup após teste

def test_com_arquivo_temporario(temp_html_file):
    """Teste usando arquivo temporário."""
    assert temp_html_file.exists()
    content = temp_html_file.read_text(encoding='utf-8')
    assert "<!DOCTYPE html>" in content
```

---

## 📊 Cobertura de Código

### Meta de Cobertura
- **Mínimo:** 80%
- **Ideal:** 90%+
- **Crítico (core logic):** 100%

### Executar com Relatório
```bash
# HTML report
pytest --cov=backend/actions/run --cov-report=html

# Terminal report
pytest --cov=backend/actions/run --cov-report=term-missing
```

### O que Testar
✅ **Sempre testar:**
- Funções públicas (API)
- Lógica de negócio
- Condições de erro
- Casos extremos (edge cases)

❌ **Não precisa testar:**
- Getters/setters simples
- Imports
- Constantes

---

## 🐛 Testes de Erro

```python
def test_update_html_head_arquivo_inexistente():
    """Testa erro ao processar arquivo inexistente."""
    manager = DynamicHeadManager()
    
    sucesso, status = manager.update_html_head("/caminho/invalido.html")
    
    assert sucesso is False
    assert "erro" in status.lower() or "não encontrado" in status.lower()

def test_validar_dependencias_json_invalido():
    """Testa erro ao validar JSON inválido."""
    manager = DynamicHeadManager()
    
    # JSON com estrutura incorreta
    deps_invalidas = {"chave_errada": []}
    
    sucesso, erro = manager._validar_estrutura_dependencias(deps_invalidas)
    
    assert sucesso is False
    assert erro is not None
```

---

## 🎯 Boas Práticas

### 1. Um Conceito por Teste
```python
# ✅ BOM: Testa apenas detecção de página
def test_is_book_page_caminho_valido():
    manager = DynamicHeadManager()
    assert manager._is_book_page("/book/EST0033/index.html") is True

# ❌ RUIM: Testa múltiplos conceitos
def test_todo_o_sistema():
    manager = DynamicHeadManager()
    assert manager._is_book_page("/book/EST0033/index.html") is True
    sucesso, _ = manager.update_html_head("file.html")
    assert sucesso is True
    # ... mais 10 asserts ...
```

### 2. Nomes Descritivos
```python
# ✅ BOM: Nome explica o que está testando
def test_extrair_links_seo_quando_breadcrumb_ausente_retorna_none():
    pass

# ❌ RUIM: Nome genérico
def test_extrair_links():
    pass
```

### 3. Arrange-Act-Assert Visível
```python
def test_adicionar_links_seo():
    # ARRANGE
    soup = BeautifulSoup("<html><head></head></html>", 'html.parser')
    links = {"prev": "/cap1.html", "next": "/cap3.html"}
    
    # ACT
    manager = DynamicHeadManager()
    manager._adicionar_links_seo(soup, links)
    
    # ASSERT
    link_prev = soup.find('link', {'rel': 'prev'})
    assert link_prev is not None
    assert link_prev['href'] == "/cap1.html"
```

### 4. Use Asserts Específicos
```python
# ✅ BOM: Assert específico
def test_retorna_dicionario_com_chaves_corretas():
    resultado = funcao()
    assert isinstance(resultado, dict)
    assert "prev" in resultado
    assert "next" in resultado

# ❌ RUIM: Assert genérico
def test_retorna_algo():
    resultado = funcao()
    assert resultado  # Pode passar com qualquer truthy value
```

---

## 🔍 Testes de Regressão

Quando corrigir um bug:

```python
def test_bug_123_encoding_utf8():
    """
    Testa correção do bug #123: Caracteres UTF-8 eram corrompidos.
    
    Antes: "São Paulo" virava "S�o Paulo"
    Depois: Mantém encoding correto
    """
    manager = DynamicHeadManager()
    html_com_acento = """
        <html>
        <head><title>São Paulo</title></head>
        </html>
    """
    
    # Processar HTML
    soup = BeautifulSoup(html_com_acento, 'html.parser')
    resultado = str(soup)
    
    # Verificar que acentos foram preservados
    assert "São Paulo" in resultado
    assert "�" not in resultado
```

---

## 📝 Executar Testes

```bash
# Todos os testes
pytest

# Teste específico
pytest tests/test_head.py

# Teste específico por nome
pytest -k "test_is_book_page"

# Verbose (mostra cada teste)
pytest -v

# Com print() visível
pytest -s

# Parar no primeiro erro
pytest -x

# Modo watch (reexecutar ao modificar)
pip install pytest-watch
ptw
```

---

## 🎭 Mock e Patch (quando necessário)

```python
from unittest.mock import patch, MagicMock

def test_funcao_que_depende_de_arquivo():
    """Testa função que lê arquivo sem criar arquivo real."""
    with patch('pathlib.Path.read_text') as mock_read:
        mock_read.return_value = "<html>Mock Content</html>"
        
        manager = DynamicHeadManager()
        resultado = manager.processar_html("fake_path.html")
        
        assert resultado is not None
        mock_read.assert_called_once()
```

---

## ✅ Checklist de Testes

Antes de commitar:

- [ ] Todos os testes passam (`pytest`)
- [ ] Cobertura >= 80% (`pytest --cov`)
- [ ] Testes seguem padrão AAA
- [ ] Nomes descritivos
- [ ] Fixtures usadas quando apropriado
- [ ] Casos de erro testados
- [ ] Edge cases cobertos

---

**Última atualização:** 1 de outubro de 2025
