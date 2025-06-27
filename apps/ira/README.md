# Calculadora de IRA - Funcionalidades

## 📋 Funcionalidades Implementadas (Issue #19)

### ✅ 1. Exportação e Importação de Dados
- **Botão "Baixar CSV"**: Exporta os dados em formato CSV estruturado (periodo;disciplina;creditos;mencao;status)
- **Botão "Importar CSV"**: Permite carregar dados de arquivo CSV com validação completa
- **Formato padrão**: Foco exclusivo em CSV para máxima compatibilidade com planilhas

### ✅ 2. Sistema de Cookies/LocalStorage
- **Auto-save**: Dados são salvos automaticamente a cada 30 segundos
- **Carregamento automático**: Dados anteriores são carregados ao abrir a página
- **Backup automático**: Sistema cria backup em CSV no localStorage
- **Indicador visual**: Mostra quando há dados não salvos

### ✅ 3. Importação de dados CSV
- **Validação robusta**: Verifica formato, campos obrigatórios e valores válidos
- **Feedback detalhado**: Notificações específicas sobre erros de importação
- **Exemplo incluído**: Arquivo exemplo_ira_dados.csv para referência

### ✅ 4. Aviso ao sair da página
- **Detecção de saída**: Monitora quando o usuário tenta sair da página
- **Salvamento automático**: Salva dados antes de sair
- **Aviso personalizado**: Informa sobre dados não salvos

### ✅ 5. Formato CSV estruturado
- **Padrão único**: periodo;disciplina;creditos;mencao;status
- **Compatibilidade**: Funciona com Excel, Google Sheets e outros editores
- **Validação**: Menções válidas (SS, MS, MM, MI, II, SR, TR, SF)

### ✅ 6. Reescrita da lógica JavaScript
- **Código modular**: Funções organizadas e reutilizáveis
- **Melhor performance**: Otimizações na manipulação do DOM
- **Sistema de notificações**: Feedback visual para o usuário
- **Validação de dados**: Verificação de consistência e formato CSV
- **Foco em CSV**: Lógica simplificada para trabalhar exclusivamente com CSV

### ✅ 7. Responsividade aprimorada
- **Mobile-first**: Design otimizado para dispositivos móveis
- **Tablets**: Layout adaptado para telas médias
- **Desktop**: Interface completa para telas grandes
- **Acessibilidade**: Foco visível e navegação por teclado

## 🎯 Funcionalidades Adicionais

### 📊 Sistema de Estatísticas
- **Botão "Estatísticas"**: Mostra/oculta painel de estatísticas
- Métricas incluídas:
  - Total de períodos
  - Total de disciplinas
  - Disciplinas aprovadas/reprovadas
  - Créditos totais/aprovados

### ⌨️ Atalhos de Teclado
- **Ctrl+S**: Salvar dados manualmente
- **Ctrl+N**: Adicionar novo período
- **Ctrl+E**: Exportar CSV
- **Ctrl+I**: Importar CSV
- **ESC**: Fechar modal

### 🔄 Sistema de Backup
- **Backup automático**: Criado a cada cálculo
- **Restauração**: Possibilidade de restaurar dados perdidos
- **Múltiplas versões**: Mantém backup da sessão anterior

### 🎨 Interface Melhorada
- **Tooltips**: Dicas ao passar o mouse sobre botões
- **Modal de confirmação**: Confirmações elegantes para ações importantes
- **Notificações**: Sistema de alertas visuais
- **Indicadores visuais**: Status de modificação dos dados

## 📱 Responsividade

### Desktop (1024px+)
- Layout completo com todos os botões visíveis
- Formulário em linha para melhor aproveitamento do espaço
- Tooltips com informações detalhadas

### Tablet (769px - 1023px)
- Layout adaptado com quebras de linha inteligentes
- Botões redimensionados para touch
- Formulário adaptativo

### Mobile (480px - 768px)
- Layout vertical otimizado
- Botões empilhados para fácil acesso
- Texto redimensionado para melhor legibilidade

### Mobile Pequeno (< 480px)
- Interface simplificada
- Botões em largura total
- Formulário verticalizado

## 🚀 Como Usar

1. **Adicionar Período**: Clique em "Novo Período" ou use Ctrl+N
2. **Preencher Dados**: Complete código, créditos e menção das disciplinas
3. **Salvar**: Os dados são salvos automaticamente (ou use Ctrl+S)
4. **Exportar CSV**: Use "Baixar CSV" para exportar seus dados (Ctrl+E)
5. **Importar CSV**: Use "Importar CSV" para carregar dados anteriores (Ctrl+I)
6. **Estatísticas**: Clique em "Estatísticas" para ver métricas detalhadas

## 🔧 Funcionalidades Técnicas

### Validação de Dados
- Verificação de campos obrigatórios CSV
- Validação de formato de código de disciplina
- Consistência entre créditos e menções
- Validação de estrutura e separadores CSV

### Performance
- Debounce em eventos de entrada
- Lazy loading de estatísticas
- Otimização de re-renderização

### Segurança
- Validação de arquivos CSV importados
- Sanitização de dados CSV
- Tratamento de erros robusto
- Verificação de formato e estrutura

## 📄 Formato CSV Estruturado

O sistema trabalha exclusivamente com arquivos CSV no formato estruturado:

### Estrutura do Arquivo
```
periodo;disciplina;creditos;mencao;status
1;MAT0025;4;MS;Aprovado
1;EST0033;4;SS;Aprovado
2;MAT0026;4;SS;Aprovado
2;EST0171;4;MS;Aprovado
```

### Campos Obrigatórios
- **periodo**: Número do período (1, 2, 3, ...)
- **disciplina**: Código da disciplina (ex: MAT0025, EST0033)
- **creditos**: Número de créditos (2, 3, 4, 6, 8, 10, 12, 16, 22, 40, 52, 64)
- **mencao**: Menção obtida (SR, II, MI, MM, MS, SS)
- **status**: Calculado automaticamente (Aprovado/Reprovado)

### Regras de Validação
- **Separador**: Ponto e vírgula (;)
- **Cabeçalho**: Obrigatório na primeira linha
- **Menções válidas**: SR, II, MI, MM, MS, SS
- **Períodos**: Números inteiros positivos
- **Créditos**: Valores numéricos válidos

## 🐛 Resolução de Problemas

### Dados não carregam
1. Verifique se o localStorage está habilitado
2. Limpe o cache do navegador
3. Use "Importar Dados" para restaurar backup

### Exportação não funciona
1. Verifique se o navegador permite downloads
2. Desative bloqueadores de popup
3. Tente com dados completos

### Interface não responsiva
1. Atualize a página
2. Verifique a resolução da tela
3. Desative extensões que modificam CSS

## 🔄 Atualizações Futuras
- Integração com sistema SIGAA
- Gráficos de evolução do IRA
- Comparação com médias do curso
- Sincronização em nuvem
