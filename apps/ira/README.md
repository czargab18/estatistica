# Calculadora de IRA - Funcionalidades

## 📋 Funcionalidades Implementadas (Issue #19)

### ✅ 1. Botão para baixar os dados preenchidos
- **Botão "Baixar CSV"**: Exporta os dados em formato CSV para análise em planilhas
- **Botão "Baixar JSON"**: Exporta os dados em formato JSON para backup completo
- **Botão "Relatório"**: Gera relatório completo com estatísticas e metadados

### ✅ 2. Sistema de Cookies/LocalStorage
- **Auto-save**: Dados são salvos automaticamente a cada 30 segundos
- **Carregamento automático**: Dados anteriores são carregados ao abrir a página
- **Backup automático**: Sistema cria backup a cada cálculo do IRA
- **Indicador visual**: Mostra quando há dados não salvos

### ✅ 3. Importação de dados
- **Botão "Importar Dados"**: Permite carregar dados de arquivo JSON
- **Validação**: Verifica se o arquivo é válido antes de importar
- **Feedback visual**: Notificações de sucesso/erro

### ✅ 4. Aviso ao sair da página
- **Detecção de saída**: Monitora quando o usuário tenta sair da página
- **Salvamento automático**: Salva dados antes de sair
- **Aviso personalizado**: Informa sobre dados não salvos

### ✅ 5. Opção de formato de exportação
- **CSV**: Ideal para análise em Excel/Google Sheets
- **JSON**: Backup completo com todos os dados
- **Relatório**: Formato completo com estatísticas

### ✅ 6. Reescrita da lógica JavaScript
- **Código modular**: Funções organizadas e reutilizáveis
- **Melhor performance**: Otimizações na manipulação do DOM
- **Sistema de notificações**: Feedback visual para o usuário
- **Validação de dados**: Verificação de consistência

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
- **Ctrl+I**: Importar dados
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
4. **Exportar**: Use os botões de download para exportar seus dados
5. **Estatísticas**: Clique em "Estatísticas" para ver métricas detalhadas
6. **Importar**: Use "Importar Dados" para carregar dados anteriores

## 🔧 Funcionalidades Técnicas

### Validação de Dados
- Verificação de campos obrigatórios
- Validação de formato de código de disciplina
- Consistência entre créditos e menções

### Performance
- Debounce em eventos de entrada
- Lazy loading de estatísticas
- Otimização de re-renderização

### Segurança
- Validação de arquivos importados
- Sanitização de dados
- Tratamento de erros robusto

## 📄 Formatos de Exportação

### CSV
```
Periodo,Codigo,Creditos,Mencao,Status,Pontos
1,"EST0033",4,"SS","Aprovado",20
```

### JSON
```json
{
  "periodos": [...],
  "dataUltimaModificacao": "2025-06-27T...",
  "metadata": {
    "versao": "1.0",
    "totalPeriodos": 2,
    "totalDisciplinas": 8
  }
}
```

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
