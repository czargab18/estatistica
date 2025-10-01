# Convenções de Estilo de Código

## 🐍 Python

### Formatação
- **Seguir PEP 8 rigorosamente**
- **Indentação:** 4 espaços
- **Linha máxima:** 88 caracteres (Black style)
- **Encoding:** UTF-8 explícito em todos os arquivos

### Type Hints
```python
from pathlib import Path
from typing import Optional, List, Dict

def processar_arquivo(
    caminho: Path, 
    modo: str = "r"
) -> Optional[str]:
    """Sempre use type hints em funções públicas."""
    pass

def buscar_arquivos(diretorio: Path) -> List[Path]:
    """Use tipos genéricos para collections."""
    return list(diretorio.glob("*.html"))
```

### Docstrings (Google Style)
```python
def calcular_media(numeros: List[float]) -> float:
    """
    Calcula a média aritmética de uma lista de números.
    
    Args:
        numeros: Lista de números para calcular a média
        
    Returns:
        Média aritmética dos números
        
    Raises:
        ValueError: Se a lista estiver vazia
        
    Example:
        >>> calcular_media([1, 2, 3, 4, 5])
        3.0
    """
    if not numeros:
        raise ValueError("Lista não pode estar vazia")
    return sum(numeros) / len(numeros)
```

### Boas Práticas Python

✅ **FAZER:**
```python
from pathlib import Path

# Usar pathlib ao invés de os.path
caminho = Path("backend/actions/run")
arquivo = caminho / "site_html_manager.py"

# F-strings para formatação
mensagem = f"Processando {arquivo.name}"

# Context managers
with open(arquivo, "r", encoding="utf-8") as f:
    conteudo = f.read()

# Tratamento específico de exceções
try:
    resultado = processar(arquivo)
except FileNotFoundError:
    print(f"❌ Arquivo não encontrado: {arquivo}")
except PermissionError:
    print(f"❌ Sem permissão para acessar: {arquivo}")
```

❌ **NÃO FAZER:**
```python
import os

# Não usar os.path
caminho = os.path.join("backend", "actions", "run")

# Não usar % ou .format()
mensagem = "Processando %s" % arquivo

# Não usar open sem context manager
f = open(arquivo)
conteudo = f.read()
f.close()

# Não usar except genérico
try:
    resultado = processar(arquivo)
except Exception:
    pass  # Nunca silencie erros assim
```

### Nomenclatura Python
- **Funções/variáveis:** `snake_case`
- **Classes:** `PascalCase`
- **Constantes:** `UPPER_SNAKE_CASE`
- **Privado:** `_leading_underscore`

```python
# Correto
class GerenciadorHead:
    MAX_DEPENDENCIAS = 100
    
    def __init__(self):
        self._cache = {}
    
    def atualizar_head(self, caminho_html: str) -> bool:
        return True
```

---

## 🌐 JavaScript/TypeScript

### Formatação
- **Indentação:** 2 espaços
- **Linha máxima:** 120 caracteres
- **Ponto e vírgula:** Sempre usar

### ES6+ Features
```javascript
// ✅ Usar const/let, nunca var
const API_URL = 'https://api.example.com';
let contador = 0;

// ✅ Arrow functions
const calcular = (a, b) => a + b;

// ✅ Template literals
const mensagem = `Resultado: ${calcular(2, 3)}`;

// ✅ Destructuring
const { nome, idade } = pessoa;
const [primeiro, segundo] = array;

// ✅ Async/await ao invés de .then()
async function buscarDados() {
  try {
    const response = await fetch(API_URL);
    const data = await response.json();
    return data;
  } catch (error) {
    console.error('Erro ao buscar dados:', error);
  }
}

// ✅ Spread operator
const novoArray = [...arrayAntigo, novoItem];
const novoObjeto = { ...objetoAntigo, novaCor: 'azul' };
```

### Nomenclatura JavaScript
- **Funções/variáveis:** `camelCase`
- **Classes:** `PascalCase`
- **Constantes:** `UPPER_SNAKE_CASE`
- **Privado:** `#privateField` (ES2022)

```javascript
// Correto
class GerenciadorDados {
  #cache = new Map();
  
  constructor() {
    this.MAX_ITEMS = 100;
  }
  
  buscarItem(id) {
    return this.#cache.get(id);
  }
}
```

---

## 🎨 HTML/CSS

### HTML
```html
<!-- ✅ HTML5 semântico -->
<article>
  <header>
    <h1>Título do Artigo</h1>
    <time datetime="2025-10-01">1 de outubro de 2025</time>
  </header>
  
  <section>
    <p>Conteúdo do artigo...</p>
  </section>
  
  <footer>
    <p>Autor: Nome</p>
  </footer>
</article>

<!-- ✅ Acessibilidade -->
<button aria-label="Fechar menu">
  <span aria-hidden="true">×</span>
</button>

<img src="imagem.jpg" alt="Descrição clara da imagem">
```

### CSS
```css
/* ✅ Custom properties para temas */
:root {
  --cor-primaria: #007bff;
  --espacamento: 1rem;
  --fonte-principal: 'SF Pro', sans-serif;
}

/* ✅ BEM ou nomenclatura consistente */
.card {
  padding: var(--espacamento);
}

.card__titulo {
  color: var(--cor-primaria);
}

.card__titulo--destaque {
  font-weight: bold;
}

/* ✅ Mobile-first */
.container {
  width: 100%;
}

@media (min-width: 768px) {
  .container {
    max-width: 720px;
  }
}

/* ✅ Flexbox/Grid modernos */
.layout {
  display: grid;
  grid-template-columns: repeat(auto-fit, minmax(300px, 1fr));
  gap: 1rem;
}
```

### Nomenclatura CSS
- **Classes:** `kebab-case`
- **IDs:** `kebab-case` (usar com moderação)
- **Custom properties:** `--kebab-case`

---

## 📝 Nomenclatura de Arquivos

```
✅ CORRETO:
- site_html_manager.py        (Python: snake_case)
- test_head_manager.py         (Testes: test_*.py)
- index.html                   (HTML: lowercase)
- global-header.css            (CSS: kebab-case)
- navbar-component.js          (JS: kebab-case)
- DynamicHeadManager.tsx       (React: PascalCase)

❌ INCORRETO:
- siteHTMLManager.py           (não use camelCase em Python)
- TestHeadManager.py           (não use PascalCase para módulos)
- Index.HTML                   (não use uppercase)
- global_header.css            (não use snake_case em CSS)
```

---

## 🎯 Comentários

### Python
```python
# Comentários explicam o PORQUÊ, não o QUÊ
def otimizar_busca(dados: List[Dict]) -> List[Dict]:
    # Usar set para O(1) lookup ao invés de O(n)
    ids_vistos = set()
    resultado = []
    
    for item in dados:
        if item['id'] not in ids_vistos:
            ids_vistos.add(item['id'])
            resultado.append(item)
    
    return resultado
```

### JavaScript
```javascript
/**
 * Busca dados da API com retry automático.
 * 
 * @param {string} url - URL da API
 * @param {number} tentativas - Número de tentativas (padrão: 3)
 * @returns {Promise<Object>} Dados da API
 */
async function buscarComRetry(url, tentativas = 3) {
  // Implementação...
}
```

---

**Última atualização:** 1 de outubro de 2025
