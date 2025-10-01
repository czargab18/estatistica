# Regras de Edição de Arquivos

## 🎯 Princípio Fundamental

**SEMPRE edite arquivos existentes in-place. NUNCA crie novos arquivos para substituir existentes.**

---

## ✅ Quando EDITAR (Modificar In-Place)

### 1. Correções e Melhorias
```python
# ✅ BOM: Editar arquivo existente
# Arquivo: backend/actions/run/htmltools/head.py

# ANTES:
def funcao_antiga():
    return "valor"

# DEPOIS (via replace_string_in_file):
def funcao_melhorada():
    """Docstring adicionada."""
    return "valor_otimizado"
```

### 2. Refatorações
```python
# ✅ BOM: Remover código obsoleto
# Arquivo: backend/actions/run/site_html_manager.py

# ANTES:
class UpdateHead:  # Classe antiga
    pass

class DynamicHeadManager:  # Classe nova
    pass

# DEPOIS:
# (classe UpdateHead removida via replace_string_in_file)

class DynamicHeadManager:  # Classe nova
    pass
```

### 3. Adicionar Funcionalidades
```python
# ✅ BOM: Adicionar método em classe existente
# Arquivo: backend/actions/run/htmltools/head.py

class DynamicHeadManager:
    # ...métodos existentes...
    
    # NOVO MÉTODO (via insert_edit_into_file):
    def _adicionar_links_seo(self, soup, links):
        """Adiciona links SEO ao head."""
        pass
```

---

## ❌ Quando NÃO Criar Novo Arquivo

### Caso 1: Renomear/Mover Arquivo
```bash
# ❌ ERRADO:
# - create_file("novo_nome.py")
# - copiar conteúdo de "nome_antigo.py"

# ✅ CERTO:
# Use terminal para mover/renomear
mv nome_antigo.py novo_nome.py
git mv nome_antigo.py novo_nome.py  # Se estiver no git
```

### Caso 2: Atualizar Estrutura
```python
# ❌ ERRADO:
# - create_file("head.py") com todo o conteúdo novo

# ✅ CERTO:
# - replace_string_in_file() para cada mudança
# - insert_edit_into_file() para adicionar novo código
```

---

## 🆕 Quando CRIAR Novo Arquivo

### 1. Arquivo Realmente Novo
```python
# ✅ Criar testes para código existente
create_file(
    "backend/actions/run/test_head_manager.py",
    conteudo_dos_testes
)

# ✅ Adicionar novo módulo
create_file(
    "backend/actions/run/htmltools/seo.py",
    novo_modulo_seo
)
```

### 2. Documentação Nova
```markdown
# ✅ Criar documentação que não existia
create_file(
    ".github/copilot/instructions.md",
    instrucoes
)
```

### 3. Configuração Nova
```json
// ✅ Criar arquivo de config novo
create_file(
    ".editorconfig",
    config_formatacao
)
```

---

## 🔧 Ferramentas de Edição

### 1. `replace_string_in_file`
**Use para:** Substituir código existente

```python
replace_string_in_file(
    filePath="c:/path/to/file.py",
    oldString="""
    def funcao_antiga():
        return "antigo"
    """,
    newString="""
    def funcao_nova():
        return "novo"
    """
)
```

**Características:**
- Precisa de contexto (3+ linhas antes/depois)
- Substitui exatamente uma ocorrência
- Falha se o texto não for encontrado exatamente

### 2. `insert_edit_into_file`
**Use para:** Adicionar código novo ou edições complexas

```python
insert_edit_into_file(
    filePath="c:/path/to/file.py",
    explanation="Adiciona método de SEO",
    code="""
class DynamicHeadManager:
    # ...existing code...
    
    def _adicionar_links_seo(self, soup, links):
        '''Adiciona links prev/next ao head.'''
        head = soup.find('head')
        # código novo...
    """
)
```

**Características:**
- Mais inteligente, entende contexto
- Pode usar comentários `# ...existing code...`
- Melhor para adicionar métodos/funções

### 3. `run_in_terminal` (para mover/renomear)
**Use para:** Operações de arquivo (mv, rm, cp)

```bash
# Renomear
run_in_terminal(
    command="mv old_name.py new_name.py",
    explanation="Renomeia arquivo"
)

# Mover para outro diretório
run_in_terminal(
    command="mv file.py ../new_dir/file.py",
    explanation="Move arquivo para novo diretório"
)
```

---

## 🚫 Anti-Padrões Comuns

### Anti-Padrão 1: Recriar Arquivo
```python
# ❌ NUNCA FAÇA ISSO:
# 1. Ler arquivo existente
content = read_file("file.py")

# 2. Modificar em memória
new_content = content.replace("old", "new")

# 3. Criar arquivo novo (ERRADO!)
create_file("file.py", new_content)

# ✅ FAÇA ISSO:
replace_string_in_file(
    filePath="file.py",
    oldString="old",
    newString="new"
)
```

### Anti-Padrão 2: Múltiplas Versões
```python
# ❌ NUNCA FAÇA ISSO:
create_file("head.py", conteudo_v1)
create_file("head_v2.py", conteudo_v2)
create_file("head_final.py", conteudo_final)

# ✅ FAÇA ISSO:
# Edite head.py diretamente
replace_string_in_file("head.py", old, new)
```

### Anti-Padrão 3: Backup Manual
```python
# ❌ NUNCA FAÇA ISSO:
create_file("head.py.bak", conteudo_original)
replace_string_in_file("head.py", old, new)

# ✅ Git já faz backup:
# Use `git diff` para ver mudanças
# Use `git checkout file.py` para reverter
```

---

## 📊 Fluxo de Decisão

```
Preciso modificar arquivo?
    ├─ SIM
    │   └─ Arquivo existe?
    │       ├─ SIM → Use replace_string_in_file ou insert_edit_into_file
    │       └─ NÃO → Use create_file
    │
    └─ Preciso mover/renomear?
        └─ Use run_in_terminal com mv/git mv
```

---

## 🎯 Exemplos Práticos

### Exemplo 1: Remover Função Obsoleta
```python
# Arquivo: backend/actions/run/htmltools/head.py

# PASSO 1: Identificar código a remover
read_file("backend/actions/run/htmltools/head.py", 1, 100)

# PASSO 2: Remover via replace_string_in_file
replace_string_in_file(
    filePath="c:/Users/cesar.oliveira/github/estatistica/backend/actions/run/htmltools/head.py",
    oldString="""
class UpdateHead:
    '''Classe obsoleta.'''
    def __init__(self):
        pass
    
    def update(self):
        return "old"
""",
    newString=""  # String vazia = remoção
)
```

### Exemplo 2: Adicionar Nova Função
```python
# Arquivo: backend/actions/run/htmltools/head.py

insert_edit_into_file(
    filePath="c:/Users/cesar.oliveira/github/estatistica/backend/actions/run/htmltools/head.py",
    explanation="Adiciona função de validação de SEO",
    code="""
class DynamicHeadManager:
    # ...existing code...
    
    def validar_links_seo(self, soup) -> bool:
        '''
        Valida se links SEO estão corretos.
        
        Returns:
            True se links são válidos, False caso contrário
        '''
        prev_link = soup.find('link', {'rel': 'prev'})
        next_link = soup.find('link', {'rel': 'next'})
        return prev_link is not None or next_link is not None
"""
)
```

### Exemplo 3: Atualizar Import
```python
# Arquivo: backend/actions/run/htmltools/__init__.py

replace_string_in_file(
    filePath="c:/Users/cesar.oliveira/github/estatistica/backend/actions/run/htmltools/__init__.py",
    oldString="""
from .head import UpdateHead, DynamicHeadManager

__all__ = ['UpdateHead', 'DynamicHeadManager']
""",
    newString="""
from .head import DynamicHeadManager

__all__ = ['DynamicHeadManager']
"""
)
```

---

## 🔍 Verificação Pós-Edição

Após editar arquivo, sempre:

1. **Verificar erros:**
```python
get_errors(filePaths=["path/to/edited/file.py"])
```

2. **Executar testes:**
```bash
pytest path/to/test_file.py
```

3. **Ver diff (se necessário):**
```bash
run_in_terminal(
    command="git diff path/to/file.py",
    explanation="Verifica mudanças no arquivo"
)
```

---

## ✅ Checklist de Edição

Antes de editar arquivo:

- [ ] Confirmar que arquivo existe (use `read_file` ou `file_search`)
- [ ] Ler contexto suficiente ao redor do código a modificar
- [ ] Usar `replace_string_in_file` com contexto (3+ linhas antes/depois)
- [ ] Se replace falhar, usar `insert_edit_into_file`
- [ ] Verificar erros após edição (`get_errors`)
- [ ] Executar testes se houver (`pytest`)

Antes de criar arquivo:

- [ ] Confirmar que arquivo NÃO existe
- [ ] Verificar se não deveria estar editando arquivo existente
- [ ] Usar `create_file` apenas para arquivos realmente novos

---

## 🚨 Avisos Importantes

1. **NUNCA use create_file em arquivo existente:**
   - VS Code vai sobrescrever
   - Perde histórico do git
   - Pode causar conflitos

2. **NUNCA crie arquivo "_v2", "_final", "_backup":**
   - Use git para versionamento
   - Edite arquivo original

3. **SEMPRE leia antes de editar:**
   - Use `read_file` para ver conteúdo atual
   - Use contexto suficiente no `oldString`

4. **SEMPRE verifique após editar:**
   - Use `get_errors` para validar
   - Execute testes se houver

---

**Última atualização:** 1 de outubro de 2025
