# Convenções de Commits

## 📝 Formato Padrão

```
tipo(escopo): descrição breve

[corpo opcional]

[rodapé opcional]
```

---

## 🏷️ Tipos de Commit

| Tipo | Descrição | Exemplo |
|------|-----------|---------|
| `feat` | Nova funcionalidade | `feat(head): adiciona links SEO automáticos` |
| `fix` | Correção de bug | `fix(header): corrige erro de encoding` |
| `docs` | Alteração na documentação | `docs(readme): atualiza exemplos de uso` |
| `style` | Formatação, ponto e vírgula, etc | `style(head): formata código com black` |
| `refactor` | Refatoração sem mudar comportamento | `refactor(head): simplifica lógica de detecção` |
| `test` | Adição ou correção de testes | `test(head): adiciona testes para extração SEO` |
| `chore` | Tarefas de manutenção | `chore: atualiza dependências` |
| `perf` | Melhoria de performance | `perf(head): otimiza leitura de JSON` |
| `build` | Mudanças no build ou deps | `build: adiciona script de deploy` |
| `ci` | Mudanças na CI/CD | `ci: configura GitHub Actions` |

---

## 📦 Escopos Comuns

- `head` - Sistema de gerenciamento de head
- `header` - Componente de cabeçalho
- `footer` - Componente de rodapé
- `breadcrumbs` - Sistema de navegação
- `book` - Sistema de livros
- `newsroom` - Sistema de notícias
- `config` - Configurações
- `deps` - Dependências

---

## ✅ Exemplos CORRETOS

### Feat (Nova Funcionalidade)
```
feat(head): adiciona links SEO automáticos para livros

- Implementa _extrair_links_next_prev()
- Implementa _adicionar_links_seo()
- Adiciona testes para extração de links
- Atualiza README com documentação

Closes #42
```

### Fix (Correção)
```
fix(header): corrige caracteres especiais em títulos

O encoding UTF-8 não estava sendo aplicado corretamente
ao processar títulos com acentuação.

Fixes #38
```

### Refactor
```
refactor(head): remove classe UpdateHead obsoleta

- Remove código duplicado
- Mantém apenas DynamicHeadManager
- Simplifica CLI (remove 5 argumentos)
- Atualiza testes
```

### Docs
```
docs(readme): consolida documentação em arquivo único

- Remove CHANGELOG.md, GUIDE.md, EXAMPLES.md
- Adiciona todas as seções no README.md
- Melhora estrutura com emojis
- Adiciona histórico de versões no final
```

### Test
```
test(head): adiciona cobertura completa para SEO

- test_extrair_links_next_prev()
- test_adicionar_links_seo()
- test_is_book_page()
- Cobertura: 95%
```

### Chore
```
chore: atualiza configurações do Copilot

- Divide instruções em arquivos modulares
- Adiciona code-style.md
- Adiciona commit-conventions.md
- Melhora organização
```

---

## ❌ Exemplos INCORRETOS

```
❌ "atualiza código"
   (muito vago, sem tipo, sem escopo)

❌ "Fix bug"
   (em inglês, sem descrição clara)

❌ "feat: adiciona nova feature que faz várias coisas diferentes"
   (muito longo, deve ser dividido em múltiplos commits)

❌ "corrige header e footer e breadcrumbs"
   (deve ser 3 commits separados)
```

---

## 📋 Regras da Descrição

### Título (primeira linha)
- ✅ **Máximo 72 caracteres**
- ✅ **Imperativo** ("adiciona" não "adicionado")
- ✅ **Minúscula** após o tipo
- ✅ **Sem ponto final**
- ✅ **Em português**

```
✅ feat(head): adiciona suporte a OpenGraph
❌ feat(head): Adicionado suporte a OpenGraph.
```

### Corpo (opcional)
- Separar do título com linha em branco
- Explicar **O QUÊ** e **POR QUÊ** (não o COMO)
- Linha máxima de 72 caracteres
- Usar lista com hífen para múltiplos itens

### Rodapé (opcional)
- Referências a issues: `Closes #123`, `Fixes #456`
- Breaking changes: `BREAKING CHANGE: descrição`

---

## 🔗 Referências a Issues

```
Closes #42          # Fecha a issue
Fixes #38           # Corrige a issue
Refs #15            # Referencia sem fechar
Related to #20      # Relacionado
```

---

## 💥 Breaking Changes

```
feat(api): muda estrutura de retorno da API

BREAKING CHANGE: O endpoint /api/books agora retorna
um objeto { data: [], total: 0 } ao invés de array direto.

Migração:
- Antes: response
- Depois: response.data
```

---

## 🎯 Boas Práticas

### ✅ FAZER

1. **Commits atômicos** - um commit = uma mudança lógica
2. **Mensagens descritivas** - explique o contexto
3. **Commitar frequentemente** - pequenos commits são melhores
4. **Testar antes de commitar** - garanta que o código funciona
5. **Referenciar issues** - use Closes #, Fixes #

### ❌ NÃO FAZER

1. **Commits gigantes** - "atualiza tudo"
2. **Mensagens vagas** - "fix", "update"
3. **Misturar mudanças** - corrigir 3 bugs em 1 commit
4. **Commitar código quebrado** - sempre teste antes
5. **Esquecer escopo** - sempre adicione escopo quando relevante

---

## 📚 Exemplos Completos

### Commit Simples
```
fix(breadcrumbs): corrige link quebrado na home

O link estava usando caminho relativo ao invés de absoluto.
```

### Commit com Corpo
```
feat(book): adiciona suporte a múltiplos idiomas

Implementa sistema de i18n para livros:
- Detecta idioma pelo caminho (pt-BR, en-US)
- Carrega traduções do arquivo JSON
- Atualiza interface automaticamente

Closes #89
```

### Commit com Breaking Change
```
refactor(head)!: remove sistema estático de head

BREAKING CHANGE: Remove classe UpdateHead e argumentos
--books-head, --process-books da CLI.

Migração:
- Remover: --books-head --dynamic-head
- Usar: (sistema dinâmico é padrão agora)

Closes #102
```

---

## 🔍 Verificar Antes de Commitar

```bash
# Ver mudanças
git diff

# Ver arquivos modificados
git status

# Adicionar arquivos específicos
git add ./backend/src/scripts/htmltools/head.py

# Commitar
git commit -m "feat(head): adiciona cache para dependências"

# Verificar histórico
git log --oneline -5
```

---

**Última atualização:** 1 de outubro de 2025
