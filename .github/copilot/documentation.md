# Padrões de Documentação

## 📚 Onde Documentar

### ✅ **Sempre no README.md**
- Visão geral do projeto
- Início rápido (Quick Start)
- Exemplos de uso
- API/CLI reference
- Solução de problemas
- Histórico de versões (no final)

### ❌ **Nunca Criar Múltiplos Arquivos**
- ❌ CHANGELOG.md (incluir no README)
- ❌ GUIDE.md (incluir no README)
- ❌ EXAMPLES.md (incluir no README)
- ❌ API.md (incluir no README)
- ❌ FAQ.md (incluir no README)

**Exceção:** CONTRIBUTING.md e LICENSE são aceitáveis

---

## 📝 Estrutura do README.md

```markdown
# Nome do Projeto - Descrição Breve

Parágrafo introdutório explicando o projeto.

**Versão:** X.Y.Z
**Data:** DD de mês de YYYY
**Status:** ✅ Estável / 🚧 Em desenvolvimento

---

## 🚀 Início Rápido

Comandos essenciais...

---

## 📋 Funcionalidades

Lista de features...

---

## 🛠️ Instalação

Passos de instalação...

---

## 💻 Uso

### Via CLI
Exemplos de linha de comando...

### Via Python/API
Exemplos de código...

---

## 📖 Documentação Completa

### Configuração
### API Reference
### Exemplos Avançados

---

## 🐛 Solução de Problemas

### Problema 1
**Causa:** ...
**Solução:** ...

---

## 📊 Estatísticas (opcional)

Tabelas com métricas...

---

## 📝 Histórico de Versões

### v2.0.0 (DD/MM/YYYY)
**Adicionado:**
- Feature A
- Feature B

**Modificado:**
- Mudança X
- Mudança Y

**Removido:**
- Feature Z

---

**Desenvolvido por:** Nome/Organização
```

---

## 🎨 Formatação

### Use Emojis para Seções
```markdown
## 🚀 Início Rápido
## 📋 Funcionalidades
## 🛠️ Instalação
## 💻 Uso
## 📖 Documentação
## 🐛 Solução de Problemas
## 🧪 Testes
## 📊 Estatísticas
## 🎯 Roadmap
## 📝 Histórico
```

### Blocos de Código com Linguagem
````markdown
```python
def exemplo():
    return "Python"
```

```javascript
const exemplo = () => "JavaScript";
```

```bash
# Comandos shell
python script.py --arg valor
```
````

### Tabelas para Comparações
```markdown
| Antes | Depois | Benefício |
|-------|--------|-----------|
| X     | Y      | Melhoria  |
```

### Alertas/Avisos
```markdown
**⚠️ Aviso:** Texto importante

**✅ Dica:** Informação útil

**❌ Erro Comum:** Problema frequente
```

---

## 📄 Docstrings Python (Google Style)

```python
def funcao_exemplo(
    parametro1: str,
    parametro2: int,
    parametro3: Optional[List[str]] = None
) -> Dict[str, Any]:
    """
    Breve descrição da função em uma linha.
    
    Descrição mais detalhada explicando o comportamento,
    considerações especiais, algoritmos usados, etc.
    Pode ter múltiplos parágrafos.
    
    Args:
        parametro1: Descrição do parâmetro 1
        parametro2: Descrição do parâmetro 2. Se precisar de mais
            de uma linha, indente assim.
        parametro3: Descrição do parâmetro 3 (opcional)
            
    Returns:
        Descrição do valor de retorno. Se for complexo,
        explique a estrutura:
        {
            'chave1': 'descrição',
            'chave2': 'descrição'
        }
        
    Raises:
        ValueError: Quando parametro2 é negativo
        FileNotFoundError: Quando arquivo não existe
        
    Example:
        >>> resultado = funcao_exemplo("teste", 42)
        >>> print(resultado['chave1'])
        'valor'
        
    Note:
        Considerações especiais ou limitações conhecidas.
        
    Warning:
        Avisos sobre uso incorreto ou comportamento inesperado.
    """
    # Implementação...
    return {'chave1': 'valor'}
```

### Classes
```python
class ExemploClasse:
    """
    Breve descrição da classe.
    
    Descrição detalhada sobre o propósito da classe,
    quando usar, padrões de design aplicados, etc.
    
    Attributes:
        atributo1: Descrição do atributo público
        atributo2: Descrição de outro atributo
        
    Example:
        >>> obj = ExemploClasse()
        >>> obj.metodo()
        'resultado'
    """
    
    def __init__(self, parametro: str):
        """
        Inicializa a classe.
        
        Args:
            parametro: Descrição do parâmetro
        """
        self.atributo1 = parametro
```

---

## 📝 Comentários no Código

### Python
```python
# ✅ BOM: Explica o PORQUÊ
def otimizar_busca(dados: List[Dict]) -> List[Dict]:
    # Usar set para O(1) lookup ao invés de O(n)
    # Reduz complexidade de O(n²) para O(n)
    ids_vistos = set()
    return [item for item in dados if item['id'] not in ids_vistos]

# ❌ RUIM: Explica o óbvio
def somar(a, b):
    # Soma a e b
    return a + b
```

### Comentários de Seção
```python
# ====================================
# CONFIGURAÇÃO INICIAL
# ====================================

config = load_config()

# ====================================
# PROCESSAMENTO PRINCIPAL
# ====================================

for item in items:
    process(item)
```

### TODOs
```python
# TODO(usuario): Adicionar validação de email
# FIXME(usuario): Corrigir bug de encoding em títulos
# HACK(usuario): Solução temporária até refatoração
# NOTE(usuario): Este código depende da biblioteca X versão 2.0+
```

---

## 🌐 Documentação de API/CLI

### CLI
```markdown
## 🛠️ Uso via CLI

### Comandos Disponíveis

#### Atualizar Head
```bash
python site_html_manager.py --only-head --path ./book/
```

**Argumentos:**
- `--only-head` - Atualizar apenas o head
- `--path <dir>` - Diretório para processar

**Exemplo:**
```bash
python site_html_manager.py --only-head --path ./book/EST0033/
```

**Saída:**
```
📄 Tipo detectado: 'book' para index.html
  ✅ Head substituído com 42 dependências
```
```
```

### API Python
```markdown
## 🐍 Uso via Python

### Classe Principal

```python
from htmltools import DynamicHeadManager

manager = DynamicHeadManager()
sucesso, status = manager.update_html_head("path/to/file.html")
```

### Métodos

#### `update_html_head(caminho_html, adicionar_seo_links=True)`
Atualiza o head de um arquivo HTML.

**Parâmetros:**
- `caminho_html` (str): Caminho para o arquivo
- `adicionar_seo_links` (bool): Adicionar links SEO (padrão: True)

**Retorna:**
- `tuple[bool, str]`: (sucesso, status)

**Exemplo:**
```python
sucesso, status = manager.update_html_head("./book/index.html")
if sucesso:
    print(f"✅ Atualizado: {status}")
```
```
```

---

## 🎯 Changelog no README

```markdown
## 📝 Histórico de Versões

### v2.0.0 (1 de outubro de 2025) - Atual

**✨ Adicionado:**
- Links SEO automáticos (rel="prev"/"next") para livros
- Detecção automática de páginas de livros
- Testes completos (100% de cobertura)

**🔧 Modificado:**
- Sistema de head agora é totalmente dinâmico (JSON)
- CLI simplificada (6 argumentos ao invés de 10+)
- Documentação consolidada no README

**🗑️ Removido:**
- Classe `UpdateHead` (sistema estático)
- Argumentos `--books-head`, `--dynamic-head`

**🐛 Corrigido:**
- Encoding UTF-8 em caracteres especiais
- Performance de leitura de JSON

---

### v1.5.0 (15 de setembro de 2025)

**✨ Adicionado:**
- Sistema dinâmico de head via JSON
- ...
```

---

## 📊 Tabelas de Referência

```markdown
## 📋 Tipos de Página Suportados

| Tipo | Caminho | Dependências |
|------|---------|--------------|
| `home` | `/index.html` | 28 |
| `book` | `/book/**` | 42 |
| `404` | `/errors/404/` | 15 |
```

---

## ✅ Checklist de Documentação

Antes de commitar:

- [ ] README atualizado com novas funcionalidades
- [ ] Docstrings adicionadas em funções públicas
- [ ] Exemplos de uso incluídos
- [ ] Histórico de versões atualizado (se release)
- [ ] Comentários explicam o PORQUÊ, não o QUÊ
- [ ] Sem arquivos de documentação separados

---

**Última atualização:** 1 de outubro de 2025
