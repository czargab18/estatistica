# IRA - Arquivos Consolidados

## Visão Geral

Este diretório contém os arquivos CSS e JavaScript consolidados do projeto IRA (Índice de Rendimento Acadêmico). A consolidação foi implementada para otimizar o carregamento da página e simplificar a manutenção do código.

## Estrutura de Arquivos

### Arquivos Consolidados (ATIVOS)
- **`styles/ira.styles.css`** - CSS consolidado contendo todos os estilos
- **`scripts/ira.scripts.js`** - JavaScript consolidado contendo todas as funcionalidades

### Arquivos Originais (MANTIDOS PARA REFERÊNCIA)
- `styles/ira.build.css` - Estilos principais e variáveis Apple
- `styles/main.css` - Cabeçalho simples e estilos gerais
- `styles/modal.css` - Modal de disclaimer
- `styles/aviso.css` - Seção de aviso fixa
- `scripts/ira.build.js` - Funcionalidades principais da aplicação
- `scripts/main.js` - Funcionalidades básicas
- `scripts/controle-aviso.js` - Controle da seção de aviso

## Detalhes da Consolidação

### CSS Consolidado (`ira.styles.css`)
O arquivo contém, em ordem:
1. **Variáveis CSS** - Sistema de design Apple
2. **Estilos da aplicação principal** - Layout, formulários, cards
3. **Cabeçalho simples** - Estilos do header
4. **Seção de aviso** - Aviso legal com animações
5. **Modal de disclaimer** - Modal responsivo
6. **Responsividade** - Media queries para diferentes dispositivos

### JavaScript Consolidado (`ira.scripts.js`)
O arquivo contém, em ordem:
1. **Controle da Seção de Aviso** - Gerenciamento do aviso legal
2. **Aplicação Principal do IRA** - Calculadora e simulador
3. **Funcionalidades Complementares** - Modais, atalhos, etc.
4. **Funções de Debug e Utilitários** - Ferramentas de desenvolvimento

## Referências no HTML

O arquivo `apps/ira/index.html` foi atualizado para usar apenas os arquivos consolidados:

```html
<!-- CSS Principal -->
<link
  rel="stylesheet"
  href="/ac/globalothers/ira/1/pt_BR/styles/ira.styles.css"
/>

<!-- Script consolidado -->
<script
  defer
  src="/ac/globalothers/ira/1/pt_BR/scripts/ira.scripts.js"
  type="text/javascript"
></script>
```

## Funcionalidades Mantidas

Todas as funcionalidades originais foram preservadas:
- ✅ Calculadora de IRA
- ✅ Simulador de IRA
- ✅ Modal de disclaimer
- ✅ Seção de aviso legal com persistência
- ✅ Responsividade
- ✅ Acessibilidade
- ✅ Atalhos de teclado
- ✅ Animações e transições

## Benefícios da Consolidação

1. **Performance**: Redução de requisições HTTP
2. **Manutenção**: Código organizado em arquivos únicos
3. **Cache**: Melhor aproveitamento do cache do browser
4. **Deploy**: Menos arquivos para gerenciar

## Manutenção Futura

Para modificações futuras:
1. Edite diretamente os arquivos consolidados (`ira.styles.css` e `ira.scripts.js`)
2. OU edite os arquivos originais e reconsolide manualmente
3. Mantenha a documentação atualizada
4. Teste todas as funcionalidades após modificações

## Testes Recomendados

Após qualquer modificação, teste:
- [ ] Carregamento da página
- [ ] Calculadora de IRA
- [ ] Simulador de IRA
- [ ] Modal de disclaimer
- [ ] Seção de aviso legal
- [ ] Responsividade (mobile/tablet/desktop)
- [ ] Funcionalidades de teclado
- [ ] Performance de carregamento
