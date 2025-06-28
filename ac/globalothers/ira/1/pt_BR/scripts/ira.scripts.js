/**
 * IRA - Scripts Consolidados
 * 
 * Este arquivo consolida todos os scripts JavaScript do projeto IRA:
 * - ira.build.js (funcionalidades principais da aplicação)
 * - controle-aviso.js (controle da seção de aviso)
 * - main.js (funcionalidades básicas)
 * 
 * Estrutura:
 * 1. Controle da Seção de Aviso
 * 2. Aplicação Principal do IRA
 * 3. Funcionalidades Complementares
 * 4. Funções de Debug e Utilitários
 */

/* =====================================
   1. CONTROLE DA SEÇÃO DE AVISO
   ===================================== */

/**
 * Controle da Seção de Aviso Legal - IRA
 * 
 * Este script gerencia o comportamento da seção de aviso legal no site do IRA.
 * Implementa funcionalidades de exibição, fechamento e persistência da preferência do usuário.
 */

// Aguardar carregamento do DOM antes de inicializar controle do aviso
document.addEventListener("DOMContentLoaded", () => {
  console.log('[Aviso] Inicializando controle do aviso legal');
  inicializarControleAviso();
});

/**
 * Função principal para inicializar o controle do aviso
 */
function inicializarControleAviso() {
  try {
    const secaoAviso = document.getElementById('secao-aviso');
    const botaoFecharAviso = document.getElementById('aviso-botao-fechar');
    
    if (!secaoAviso) {
      console.warn('[Aviso] Seção de aviso não encontrada no DOM');
      return;
    }

    console.log('[Aviso] Seção de aviso encontrada, iniciando configuração');

    // Verificar se o aviso já foi fechado anteriormente
    if (verificarAvisoFechado()) {
      console.log('[Aviso] Aviso previamente fechado, ocultando');
      ocultarAviso(secaoAviso);
      return;
    }

    console.log('[Aviso] Configurando eventos e acessibilidade');

    // Configurar evento de fechar se o botão existir
    if (botaoFecharAviso) {
      configurarEventoFechar(botaoFecharAviso, secaoAviso);
    } else {
      console.warn('[Aviso] Botão de fechar não encontrado');
    }
    
    // Configurar acessibilidade
    configurarAcessibilidadeAviso(secaoAviso, botaoFecharAviso);
    
    console.log('[Aviso] Controle do aviso inicializado com sucesso');
  } catch (error) {
    console.error('[Aviso] Erro ao inicializar controle do aviso:', error);
  }
}

/**
 * Função para verificar se o aviso foi fechado
 * @returns {boolean} true se o aviso foi fechado e ainda está dentro do prazo
 */
function verificarAvisoFechado() {
  try {
    const avisoFechado = localStorage.getItem('aviso_fechado');
    const dataFechamento = localStorage.getItem('aviso_data_fechamento');
    
    if (avisoFechado === 'true' && dataFechamento) {
      const agora = Date.now();
      const tempoFechamento = parseInt(dataFechamento);
      const seteias = 7 * 24 * 60 * 60 * 1000; // 7 dias em millisegundos
      const tempoDecorrido = agora - tempoFechamento;
      
      console.log(`[Aviso] Verificando estado: fechado há ${Math.round(tempoDecorrido / (24 * 60 * 60 * 1000))} dias`);
      
      // Se passou mais de 7 dias, limpar o localStorage e permitir exibir novamente
      if (tempoDecorrido > seteias) {
        console.log('[Aviso] Prazo de 7 dias expirado, restaurando aviso');
        localStorage.removeItem('aviso_fechado');
        localStorage.removeItem('aviso_data_fechamento');
        return false;
      }
      
      return true;
    }
  } catch (error) {
    console.error('[Aviso] Erro ao verificar estado do aviso:', error);
  }
  return false;
}

/**
 * Configura eventos de fechamento do aviso
 * @param {HTMLElement} botaoFechar - Botão de fechar o aviso
 * @param {HTMLElement} secaoAviso - Seção do aviso a ser ocultada
 */
function configurarEventoFechar(botaoFechar, secaoAviso) {
  const fecharAviso = () => {
    // Adicionar animação de fechamento
    secaoAviso.classList.add('aviso-fechando');
    
    // Aguardar animação antes de ocultar completamente
    setTimeout(() => {
      ocultarAviso(secaoAviso);
      salvarPreferenciaFechamento();
      secaoAviso.classList.remove('aviso-fechando');
    }, 300);
  };

  // Event listener para o botão
  botaoFechar.addEventListener('click', fecharAviso);

  // Fechar com ESC
  const handleKeydown = (e) => {
    if (e.key === 'Escape' && !secaoAviso.hidden) {
      fecharAviso();
    }
  };

  document.addEventListener('keydown', handleKeydown);

  // Limpar event listener quando o aviso for fechado
  const observer = new MutationObserver((mutations) => {
    mutations.forEach((mutation) => {
      if (mutation.attributeName === 'hidden' && secaoAviso.hidden) {
        document.removeEventListener('keydown', handleKeydown);
        observer.disconnect();
      }
    });
  });

  observer.observe(secaoAviso, { attributes: true, attributeFilter: ['hidden'] });
}

/**
 * Função para configurar acessibilidade
 */
function configurarAcessibilidadeAviso(secaoAviso, botaoFechar) {
  // Configurar aria-label se não existir
  if (botaoFechar && !botaoFechar.getAttribute('aria-label')) {
    botaoFechar.setAttribute('aria-label', 'Fechar aviso importante');
  }

  // Configurar role se não existir
  if (!secaoAviso.getAttribute('role')) {
    secaoAviso.setAttribute('role', 'banner');
  }

  // Configurar aria-labelledby para a seção
  const titulo = secaoAviso.querySelector('.aviso-titulo');
  if (titulo && !titulo.id) {
    titulo.id = 'aviso-titulo-principal';
    secaoAviso.setAttribute('aria-labelledby', 'aviso-titulo-principal');
  }
}

/**
 * Função para ocultar o aviso
 */
function ocultarAviso(secaoAviso) {
  secaoAviso.style.display = 'none';
  secaoAviso.hidden = true;
  secaoAviso.setAttribute('aria-hidden', 'true');
}

/**
 * Função para salvar preferência de fechamento
 */
function salvarPreferenciaFechamento() {
  try {
    localStorage.setItem('aviso_fechado', 'true');
    localStorage.setItem('aviso_data_fechamento', Date.now().toString());
    console.log('[Aviso] Preferência de fechamento do aviso salva');
  } catch (error) {
    console.error('[Aviso] Erro ao salvar preferência de fechamento:', error);
  }
}

/**
 * Função para restaurar aviso (útil para testes ou configurações)
 */
function restaurarAviso() {
  const secaoAviso = document.getElementById('secao-aviso');
  if (secaoAviso) {
    secaoAviso.style.display = 'block';
    secaoAviso.hidden = false;
    secaoAviso.setAttribute('aria-hidden', 'false');
    secaoAviso.classList.remove('aviso-fechando');
    
    // Limpar localStorage
    localStorage.removeItem('aviso_fechado');
    localStorage.removeItem('aviso_data_fechamento');
    
    console.log('[Aviso] Aviso restaurado');
  }
}

/**
 * Função para debug - verificar estado do aviso
 */
function debugAviso() {
  const secaoAviso = document.getElementById('secao-aviso');
  const avisoFechado = localStorage.getItem('aviso_fechado');
  const dataFechamento = localStorage.getItem('aviso_data_fechamento');
  
  console.log('[Aviso] Estado do aviso:', {
    elemento: secaoAviso ? 'encontrado' : 'não encontrado',
    visivel: secaoAviso ? !secaoAviso.hidden && secaoAviso.style.display !== 'none' : 'N/A',
    localStorage: {
      fechado: avisoFechado,
      dataFechamento: dataFechamento ? new Date(parseInt(dataFechamento)).toLocaleString() : 'N/A'
    }
  });
}

/* =====================================
   2. APLICAÇÃO PRINCIPAL DO IRA
   ===================================== */

// Nova estrutura de código para o cálculo do IRA
// 1. Templates HTML estão no index.html dentro da div #templates (oculta)
// 2. O JavaScript clona os templates e os configura ao invés de criar HTML dinamicamente
// 3. Esta abordagem melhora a performance e facilita a manutenção
// 4. Os elementos são mostrados/ocultados conforme necessário

let periodoCount = 0;
let disciplinaCount = {};
const maxDisciplinas = 8;
const maxPeriodos = 20;

// Sistema de Cookies para salvar/carregar dados
const STORAGE_KEY = 'ira_dados_salvos';

// Sistema de aviso para salvar dados antes de sair
let dadosModificados = false;

document.addEventListener("DOMContentLoaded", () => {
  // Mostrar modal de disclaimer primeiro
  mostrarModalDisclaimer();

  // Adicionar evento ao botão "Novo Período"
  const botaoNovoPeriodo = document.getElementById("novoPeriodo");
  if (botaoNovoPeriodo) {
    botaoNovoPeriodo.addEventListener("click", criaPeriodo);
  }

  // Carregar dados salvos automaticamente
  carregarDados();

  // Criar botões de funcionalidades adicionais
  criarBotoesAdicionais();

  // Iniciar sistema de auto-save
  iniciarAutoSave();
  
  // Adicionar atalhos de teclado
  adicionarAtalhosTeclado();
  
  // Resetar flag de modificação inicial
  dadosModificados = false;
  atualizarIndicadorModificacao();
});

// Função para criar botões adicionais
function criarBotoesAdicionais() {
  const linhaSuperior = document.getElementById("linhaSuperior");
  if (!linhaSuperior) return;

  // Criar botões dinamicamente se os templates existirem
  const templates = {
    csv: document.getElementById("template-btn-csv"),
    importar: document.getElementById("template-btn-importar"),
    limpar: document.getElementById("template-btn-limpar"),
    estatisticas: document.getElementById("template-btn-estatisticas"),
    inputImportar: document.getElementById("template-input-importar")
  };

  // Botão para baixar CSV
  if (templates.csv) {
    const btnBaixarCSV = templates.csv.cloneNode(true);
    btnBaixarCSV.id = "baixarCSV";
    btnBaixarCSV.style.display = "none";
    btnBaixarCSV.classList.remove("template-btn");
    btnBaixarCSV.addEventListener("click", baixarDadosCSV);
    linhaSuperior.appendChild(btnBaixarCSV);
  }

  // Input para importar dados
  if (templates.inputImportar) {
    const inputImportar = templates.inputImportar.cloneNode(true);
    inputImportar.id = "importarDados";
    inputImportar.style.display = "none";
    inputImportar.classList.remove("template-input");
    inputImportar.addEventListener("change", importarDadosCSV);
    linhaSuperior.appendChild(inputImportar);
  }

  // Botão para importar dados
  if (templates.importar) {
    const btnImportar = templates.importar.cloneNode(true);
    btnImportar.id = "importarCSV";
    btnImportar.style.display = "inline-block";
    btnImportar.classList.remove("template-btn");
    btnImportar.addEventListener("click", () => {
      const input = document.getElementById("importarDados");
      if (input) input.click();
    });
    linhaSuperior.appendChild(btnImportar);
  }

  // Botão para limpar dados
  if (templates.limpar) {
    const btnLimpar = templates.limpar.cloneNode(true);
    btnLimpar.id = "limparDados";
    btnLimpar.style.display = "none";
    btnLimpar.classList.remove("template-btn");
    btnLimpar.addEventListener("click", () => {
      mostrarModal(
        "Confirmar Limpeza", 
        "Tem certeza que deseja limpar todos os dados? Esta ação não pode ser desfeita.",
        () => {
          limparFormulario();
          localStorage.removeItem(STORAGE_KEY);
          localStorage.removeItem(STORAGE_KEY + '_backup');
          dadosModificados = false;
          atualizarIndicadorModificacao();
          atualizarIRA();
          atualizarEstatisticas();
          atualizarVisibilidadeBotoes();
        }
      );
    });
    linhaSuperior.appendChild(btnLimpar);
  }
}

// Função para atualizar visibilidade dos botões baseado na presença de períodos e disciplinas completas
function atualizarVisibilidadeBotoes() {
  const temPeriodos = periodoCount > 0;
  const temDisciplinasCompletas = verificarDisciplinasCompletas();
  const botoes = ['limparDados'];

  botoes.forEach(id => {
    const botao = document.getElementById(id);
    if (botao) {
      botao.style.display = temPeriodos ? 'inline-block' : 'none';
    }
  });

  const botaoCSV = document.getElementById('baixarCSV');
  if (botaoCSV) {
    botaoCSV.style.display = temDisciplinasCompletas ? 'inline-block' : 'none';
  }
}

// Função para verificar se há pelo menos uma disciplina com todos os campos preenchidos
function verificarDisciplinasCompletas() {
  for (let periodoId = 1; periodoId <= periodoCount; periodoId++) {
    if (!disciplinaCount[periodoId]) continue;
    
    for (let disciplinaId = 1; disciplinaId <= disciplinaCount[periodoId]; disciplinaId++) {
      const codigo = document.getElementById(`periodo${periodoId}-disciplina${disciplinaId}-codigo`);
      const creditos = document.getElementById(`periodo${periodoId}-disciplina${disciplinaId}-creditos`);
      const mencao = document.getElementById(`periodo${periodoId}-disciplina${disciplinaId}-mencao`);
      
      if (codigo && creditos && mencao && 
          codigo.value.trim() && 
          creditos.value && 
          mencao.value) {
        return true;
      }
    }
  }
  return false;
}

function criaPeriodo() {
  if (periodoCount >= maxPeriodos) {
    alert(`Você só pode adicionar até ${maxPeriodos} períodos.`);
    return;
  }

  periodoCount++;
  disciplinaCount[periodoCount] = 0;

  const container = document.getElementById("container-periodos-academicos");
  const template = document.getElementById("modelo-periodo");

  if (!container || !template) {
    console.error('Template de período não encontrado');
    return;
  }

  // Clonar template
  const periodoDiv = template.cloneNode(true);
  periodoDiv.id = `periodo${periodoCount}`;
  periodoDiv.style.display = 'block';
  periodoDiv.classList.remove('periodo-template');

  // Configurar elementos específicos
  const numeroElement = periodoDiv.querySelector('.numero-periodo');
  if (numeroElement) {
    numeroElement.textContent = `${periodoCount}º Período`;
  }

  const disciplinasContainer = periodoDiv.querySelector('.lista-disciplinas-periodo');
  if (disciplinasContainer) {
    disciplinasContainer.id = `periodo${periodoCount}-disciplinas`;
  }

  container.appendChild(periodoDiv);

  // Adicionar eventos aos botões
  const botaoRemoverPeriodo = periodoDiv.querySelector(".botao-remover-periodo");
  const botaoAdicionarDisciplina = periodoDiv.querySelector(".adicionar-disciplina");

  if (botaoRemoverPeriodo) {
    botaoRemoverPeriodo.addEventListener("click", () => removerPeriodo(periodoCount));
  }
  if (botaoAdicionarDisciplina) {
    botaoAdicionarDisciplina.addEventListener("click", () => adicionarDisciplina(periodoCount));
  }

  adicionarDisciplina(periodoCount);
  atualizarVisibilidadeBotoes();
}

function removerPeriodo(periodoId) {
  const periodoDiv = document.getElementById(`periodo${periodoId}`);
  if (periodoDiv) {
    periodoDiv.remove();
    delete disciplinaCount[periodoId];
    periodoCount--;
    atualizarVisibilidadeBotoes();
  }
}

function adicionarDisciplina(periodoId) {
  if (disciplinaCount[periodoId] >= maxDisciplinas) {
    alert(`Você atingiu o limite máximo de ${maxDisciplinas} disciplinas para este período.`);
    return;
  }
  
  disciplinaCount[periodoId]++;
  const disciplinaId = disciplinaCount[periodoId];
  const disciplinasDiv = document.getElementById(`periodo${periodoId}-disciplinas`);
  const template = document.getElementById("modelo-disciplina");

  if (!disciplinasDiv || !template) {
    console.error('Template de disciplina não encontrado');
    return;
  }

  // Clonar template
  const disciplinaDiv = template.cloneNode(true);
  disciplinaDiv.id = `periodo${periodoId}-disciplina${disciplinaId}-preencher`;
  disciplinaDiv.style.display = 'block';
  disciplinaDiv.classList.remove('disciplina-template');

  // Configurar IDs únicos
  const inputCodigo = disciplinaDiv.querySelector('.disciplina-codigo');
  const selectCreditos = disciplinaDiv.querySelector('.disciplina-creditos');
  const selectMencao = disciplinaDiv.querySelector('.disciplina-mencao');
  const statusSpan = disciplinaDiv.querySelector('.disciplina-status');

  if (inputCodigo) inputCodigo.id = `periodo${periodoId}-disciplina${disciplinaId}-codigo`;
  if (selectCreditos) selectCreditos.id = `periodo${periodoId}-disciplina${disciplinaId}-creditos`;
  if (selectMencao) selectMencao.id = `periodo${periodoId}-disciplina${disciplinaId}-mencao`;
  if (statusSpan) statusSpan.id = `status-${periodoId}-${disciplinaId}`;

  disciplinasDiv.appendChild(disciplinaDiv);

  // Adicionar eventos
  const botaoRemoverDisciplina = disciplinaDiv.querySelector(".remover-disciplina");

  if (inputCodigo) {
    inputCodigo.addEventListener("input", () => formatarCodigo(inputCodigo));
  }
  if (selectMencao) {
    selectMencao.addEventListener("change", () => atualizarStatus(periodoId, disciplinaId));
  }
  if (botaoRemoverDisciplina) {
    botaoRemoverDisciplina.addEventListener("click", () => removerDisciplina(periodoId, disciplinaId));
  }

  adicionarEventosParaMonitoramento(periodoId, disciplinaId);
}

function removerDisciplina(periodoId, disciplinaId) {
  const disciplinaDiv = document.getElementById(`periodo${periodoId}-disciplina${disciplinaId}-preencher`);
  if (disciplinaDiv) {
    disciplinaDiv.remove();
    disciplinaCount[periodoId]--;
    atualizarVisibilidadeBotoes();
  }
}

function determinarStatus(mencao) {
  const aprovadas = ["MM", "MS", "SS"];
  return aprovadas.includes(mencao) ? "Aprovado" : "Reprovado";
}

function atualizarStatus(periodoId, disciplinaId) {
  const mencao = document.getElementById(`periodo${periodoId}-disciplina${disciplinaId}-mencao`).value;
  const statusSpan = document.getElementById(`status-${periodoId}-${disciplinaId}`);

  if (!statusSpan) return;

  if (!mencao) {
    statusSpan.textContent = "Incompleto";
    return;
  }

  const status = determinarStatus(mencao);
  statusSpan.textContent = status;
  atualizarIRA();
}

function adicionarEventosParaMonitoramento(periodo, disciplina) {
  const codigo = document.getElementById(`periodo${periodo}-disciplina${disciplina}-codigo`);
  const creditos = document.getElementById(`periodo${periodo}-disciplina${disciplina}-creditos`);
  const mencao = document.getElementById(`periodo${periodo}-disciplina${disciplina}-mencao`);

  [codigo, creditos, mencao].forEach(elemento => {
    if (elemento) {
      elemento.addEventListener("input", () => {
        coletaDados();
        calcularIRA();
        marcarDadosComoModificados();
        atualizarVisibilidadeBotoes();
      });
      elemento.addEventListener("change", () => {
        coletaDados();
        calcularIRA();
        marcarDadosComoModificados();
        atualizarVisibilidadeBotoes();
      });
    }
  });
}

function formatarCodigo(input) {
  let valor = input.value.replace(/[^A-Za-z0-9]/g, '');
  if (valor.length > 3) {
    valor = valor.slice(0, 3).toUpperCase() + valor.slice(3, 7).replace(/[^0-9]/g, '');
  } else {
    valor = valor.toUpperCase();
  }
  input.value = valor.slice(0, 7);
}

/* =====================================
   3. SISTEMA DE PERSISTÊNCIA DE DADOS
   ===================================== */

// Função para salvar dados nos cookies/localStorage
function salvarDados() {
  const dados = coletarTodosDados();
  try {
    localStorage.setItem(STORAGE_KEY, JSON.stringify(dados));
    const csvData = gerarCSVEstruturado(dados);
    localStorage.setItem(STORAGE_KEY + '_csv', csvData);
    console.log('Dados salvos com sucesso!');
    dadosModificados = false;
    return true;
  } catch (error) {
    console.error('Erro ao salvar dados:', error);
    return false;
  }
}

// Função auxiliar para gerar CSV estruturado
function gerarCSVEstruturado(dados) {
  let csv = 'periodo;disciplina;creditos;mencao;status\\n';
  dados.periodos.forEach(periodo => {
    periodo.disciplinas.forEach(disciplina => {
      if (disciplina.codigo && disciplina.creditos && disciplina.mencao) {
        const status = determinarStatus(disciplina.mencao);
        csv += `${periodo.id};${disciplina.codigo};${disciplina.creditos};${disciplina.mencao};${status}\\n`;
      }
    });
  });
  return csv;
}

// Função para carregar dados dos cookies/localStorage
function carregarDados() {
  try {
    const dadosSalvos = localStorage.getItem(STORAGE_KEY);
    if (dadosSalvos) {
      const dados = JSON.parse(dadosSalvos);
      preencherFormularioComDados(dados);
      console.log('Dados carregados com sucesso!');
      return true;
    }
  } catch (error) {
    console.error('Erro ao carregar dados:', error);
  }
  return false;
}

// Função para coletar todos os dados do formulário
function coletarTodosDados() {
  const dados = {
    periodos: [],
    dataUltimaModificacao: new Date().toISOString()
  };

  for (let periodoId = 1; periodoId <= periodoCount; periodoId++) {
    const periodoElement = document.getElementById(`periodo${periodoId}`);
    if (!periodoElement) continue;

    const periodo = {
      id: periodoId,
      disciplinas: []
    };

    const disciplinasCount = disciplinaCount[periodoId] || 0;
    for (let disciplinaId = 1; disciplinaId <= disciplinasCount; disciplinaId++) {
      const codigo = document.getElementById(`periodo${periodoId}-disciplina${disciplinaId}-codigo`);
      const creditos = document.getElementById(`periodo${periodoId}-disciplina${disciplinaId}-creditos`);
      const mencao = document.getElementById(`periodo${periodoId}-disciplina${disciplinaId}-mencao`);

      if (codigo && creditos && mencao) {
        periodo.disciplinas.push({
          id: disciplinaId,
          codigo: codigo.value,
          creditos: creditos.value,
          mencao: mencao.value
        });
      }
    }

    if (periodo.disciplinas.length > 0) {
      dados.periodos.push(periodo);
    }
  }

  return dados;
}

// Função para preencher o formulário com dados salvos
function preencherFormularioComDados(dados) {
  limparFormulario();

  dados.periodos.forEach(periodo => {
    while (periodoCount < periodo.id) {
      criaPeriodo();
    }

    periodo.disciplinas.forEach(disciplina => {
      while (disciplinaCount[periodo.id] < disciplina.id) {
        adicionarDisciplina(periodo.id);
      }

      const codigo = document.getElementById(`periodo${periodo.id}-disciplina${disciplina.id}-codigo`);
      const creditos = document.getElementById(`periodo${periodo.id}-disciplina${disciplina.id}-creditos`);
      const mencao = document.getElementById(`periodo${periodo.id}-disciplina${disciplina.id}-mencao`);

      if (codigo) codigo.value = disciplina.codigo;
      if (creditos) creditos.value = disciplina.creditos;
      if (mencao) {
        mencao.value = disciplina.mencao;
        atualizarStatus(periodo.id, disciplina.id);
      }
    });
  });

  atualizarIRA();
  atualizarVisibilidadeBotoes();
}

// Função para limpar formulário
function limparFormulario() {
  const container = document.getElementById("container-periodos-academicos");
  if (container) {
    container.innerHTML = '';
  }
  periodoCount = 0;
  disciplinaCount = {};
  atualizarVisibilidadeBotoes();
}

/* =====================================
   4. CÁLCULO DO IRA
   ===================================== */

// Função para calcular e atualizar o IRA
function atualizarIRA() {
  const dados = coletarTodosDados();
  let totalPontos = 0;
  let totalCreditos = 0;

  dados.periodos.forEach(periodo => {
    periodo.disciplinas.forEach(disciplina => {
      if (disciplina.creditos && disciplina.mencao) {
        const creditos = parseInt(disciplina.creditos);
        const pontosMencao = obterPontosMencao(disciplina.mencao);
        
        if (pontosMencao !== null) {
          totalPontos += creditos * pontosMencao;
          totalCreditos += creditos;
        }
      }
    });
  });

  const ira = totalCreditos > 0 ? (totalPontos / totalCreditos).toFixed(2) : '0.00';
  
  const iraDisplay = document.getElementById('ira-mp');
  if (iraDisplay) {
    iraDisplay.textContent = `IRA: ${ira} MP: ${totalCreditos}`;
  }
  
  const areaEstatisticas = document.getElementById('estatisticas-rapidas');
  if (areaEstatisticas && areaEstatisticas.style.display !== 'none') {
    atualizarEstatisticas();
  }
  
  if (totalCreditos > 0) {
    criarBackupAutomatico();
  }
}

// Função para converter menção em pontos
function obterPontosMencao(mencao) {
  const tabelaMencoes = {
    'SS': 5.0,
    'MS': 4.0,
    'MM': 3.0,
    'MI': 2.0,
    'II': 1.0,
    'SR': 0.0
  };
  return tabelaMencoes[mencao] || null;
}

/* =====================================
   5. MODAL DE DISCLAIMER
   ===================================== */

// Modal de disclaimer - Apple Design System
function mostrarModalDisclaimer() {
  const modal = document.getElementById('modal-aviso-legal');
  if (!modal) return;

  const botaoOk = document.getElementById('disclaimer-botao-ok');
  const botaoFechar = document.getElementById('disclaimer-botao-fechar');
  const modalContent = modal.querySelector('.modal-aviso-legal');

  document.documentElement.classList.add('modal-open');
  const scrollbarWidth = window.innerWidth - document.documentElement.clientWidth;
  document.documentElement.style.setProperty('--modal-scrollbar-buffer', `${scrollbarWidth}px`);

  modal.setAttribute('aria-hidden', 'false');
  if (modalContent) modalContent.focus();

  modal.classList.remove('modal-oculto');
  modal.classList.add('modal-visivel', 'modal-aberto');

  const fecharModal = () => {
    modal.setAttribute('aria-hidden', 'true');
    modal.classList.add('modal-fechando');
    modal.classList.remove('modal-aberto');
    
    document.documentElement.classList.remove('modal-open');
    document.documentElement.style.removeProperty('--modal-scrollbar-buffer');
    
    setTimeout(() => {
      modal.classList.remove('modal-visivel', 'modal-fechando');
      modal.classList.add('modal-oculto');
    }, 300);
  };

  if (botaoOk) {
    botaoOk.addEventListener('click', fecharModal, { once: true });
  }

  if (botaoFechar) {
    botaoFechar.addEventListener('click', fecharModal, { once: true });
  }

  const handleKeydown = (e) => {
    if (e.key === 'Escape') {
      fecharModal();
      document.removeEventListener('keydown', handleKeydown);
    }
  };

  const handleClickOutside = (e) => {
    if (e.target === modal) {
      fecharModal();
      modal.removeEventListener('click', handleClickOutside);
      document.removeEventListener('keydown', handleKeydown);
    }
  };

  document.addEventListener('keydown', handleKeydown);
  modal.addEventListener('click', handleClickOutside);
}

/* =====================================
   6. FUNCIONALIDADES AUXILIARES
   ===================================== */

function mostrarModal(titulo, mensagem, callback) {
  const modal = document.getElementById('modal-confirmacao-acao');
  if (!modal) return;

  const modalTitulo = document.getElementById('modal-titulo');
  const modalMensagem = document.getElementById('modal-mensagem');
  const modalConfirmar = document.getElementById('modal-confirmar');
  const modalCancelar = document.getElementById('modal-cancelar');

  if (modalTitulo) modalTitulo.textContent = titulo;
  if (modalMensagem) modalMensagem.textContent = mensagem;
  modal.style.display = 'block';

  if (modalConfirmar) {
    modalConfirmar.replaceWith(modalConfirmar.cloneNode(true));
    document.getElementById('modal-confirmar').addEventListener('click', () => {
      modal.style.display = 'none';
      if (callback) callback();
    });
  }

  if (modalCancelar) {
    modalCancelar.replaceWith(modalCancelar.cloneNode(true));
    document.getElementById('modal-cancelar').addEventListener('click', () => {
      modal.style.display = 'none';
    });
  }
}

function baixarDadosCSV() {
  const dados = coletarTodosDados();
  let csv = 'periodo;disciplina;creditos;mencao;status\\n';

  dados.periodos.forEach(periodo => {
    periodo.disciplinas.forEach(disciplina => {
      if (disciplina.codigo && disciplina.creditos && disciplina.mencao) {
        const status = determinarStatus(disciplina.mencao);
        csv += `${periodo.id};${disciplina.codigo};${disciplina.creditos};${disciplina.mencao};${status}\\n`;
      }
    });
  });

  const blob = new Blob([csv], { type: 'text/csv;charset=utf-8;' });
  const link = document.createElement('a');
  const url = URL.createObjectURL(blob);
  link.setAttribute('href', url);
  link.setAttribute('download', `ira_dados_${new Date().toISOString().split('T')[0]}.csv`);
  link.style.visibility = 'hidden';
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
}

function importarDadosCSV(event) {
  const file = event.target.files[0];
  if (!file) return;

  const reader = new FileReader();
  reader.onload = function(e) {
    try {
      const csvText = e.target.result;
      const linhas = csvText.split('\\n');

      const cabecalho = linhas[0].trim().toLowerCase();
      if (cabecalho !== 'periodo;disciplina;creditos;mencao;status') {
        alert('Formato de arquivo inválido. O cabeçalho deve ser: periodo;disciplina;creditos;mencao;status');
        return;
      }

      const dadosImportados = { periodos: [] };
      const periodosMap = new Map();

      for (let i = 1; i < linhas.length; i++) {
        const linha = linhas[i].trim();
        if (!linha) continue;

        const campos = linha.split(';');
        if (campos.length !== 5) {
          console.warn(`Linha ${i + 1} ignorada - formato inválido: ${linha}`);
          continue;
        }

        const [periodo, disciplina, creditos, mencao, status] = campos.map(campo => campo.trim());

        if (!periodo || !disciplina || !creditos || !mencao) {
          console.warn(`Linha ${i + 1} ignorada - dados incompletos: ${linha}`);
          continue;
        }

        const periodoNum = parseInt(periodo);
        if (isNaN(periodoNum)) {
          console.warn(`Linha ${i + 1} ignorada - período inválido: ${periodo}`);
          continue;
        }

        const mencoesValidas = ['SR', 'II', 'MI', 'MM', 'MS', 'SS'];
        if (!mencoesValidas.includes(mencao.toUpperCase())) {
          console.warn(`Linha ${i + 1} ignorada - menção inválida: ${mencao}`);
          continue;
        }

        if (!periodosMap.has(periodoNum)) {
          periodosMap.set(periodoNum, {
            id: periodoNum,
            disciplinas: []
          });
        }

        periodosMap.get(periodoNum).disciplinas.push({
          id: periodosMap.get(periodoNum).disciplinas.length + 1,
          codigo: disciplina.toUpperCase(),
          creditos: creditos,
          mencao: mencao.toUpperCase()
        });
      }

      dadosImportados.periodos = Array.from(periodosMap.values()).sort((a, b) => a.id - b.id);

      if (dadosImportados.periodos.length === 0) {
        alert('Nenhum dado válido encontrado no arquivo CSV.');
        return;
      }

      limparFormulario();
      preencherFormularioComDados(dadosImportados);

      const totalDisciplinas = dadosImportados.periodos.reduce((total, periodo) => total + periodo.disciplinas.length, 0);
      console.log(`Dados importados: ${dadosImportados.periodos.length} períodos, ${totalDisciplinas} disciplinas!`);

    } catch (error) {
      alert('Erro ao importar dados CSV. Verifique se o arquivo está no formato correto.');
      console.error('Erro ao importar CSV:', error);
    }
  };
  reader.readAsText(file);
}

function atualizarEstatisticas() {
  const dados = coletarTodosDados();
  
  let totalDisciplinas = 0;
  let disciplinasAprovadas = 0;
  let disciplinasReprovadas = 0;
  let creditosTotais = 0;
  let creditosAprovados = 0;

  dados.periodos.forEach(periodo => {
    periodo.disciplinas.forEach(disciplina => {
      if (disciplina.codigo && disciplina.creditos && disciplina.mencao) {
        totalDisciplinas++;
        const creditos = parseInt(disciplina.creditos);
        creditosTotais += creditos;
        
        const status = determinarStatus(disciplina.mencao);
        if (status === 'Aprovado') {
          disciplinasAprovadas++;
          creditosAprovados += creditos;
        } else {
          disciplinasReprovadas++;
        }
      }
    });
  });

  const elementos = {
    'stat-periodos': dados.periodos.length,
    'stat-disciplinas': totalDisciplinas,
    'stat-aprovadas': disciplinasAprovadas,
    'stat-reprovadas': disciplinasReprovadas,
    'stat-creditos-totais': creditosTotais,
    'stat-creditos-aprovados': creditosAprovados
  };

  Object.entries(elementos).forEach(([id, valor]) => {
    const elemento = document.getElementById(id);
    if (elemento) {
      elemento.textContent = valor;
    }
  });

  const areaEstatisticas = document.getElementById('estatisticas-rapidas');
  if (areaEstatisticas) {
    areaEstatisticas.style.display = totalDisciplinas > 0 ? 'block' : 'none';
  }
}

function adicionarAtalhosTeclado() {
  document.addEventListener('keydown', (e) => {
    if (e.ctrlKey && e.key === 's') {
      e.preventDefault();
      salvarDados();
    }
    
    if (e.ctrlKey && e.key === 'n') {
      e.preventDefault();
      criaPeriodo();
    }
    
    if (e.ctrlKey && e.key === 'e') {
      e.preventDefault();
      baixarDadosCSV();
    }
    
    if (e.ctrlKey && e.key === 'i') {
      e.preventDefault();
      document.getElementById('importarDados')?.click();
    }
  });
}

function iniciarAutoSave() {
  setInterval(() => {
    if (dadosModificados) {
      salvarDados();
    }
  }, 30000);
}

function atualizarIndicadorModificacao() {
  const iraDisplay = document.getElementById('ira-mp');
  if (iraDisplay) {
    if (dadosModificados) {
      iraDisplay.classList.add('dados-modificados');
    } else {
      iraDisplay.classList.remove('dados-modificados');
    }
  }
}

function marcarDadosComoModificados() {
  dadosModificados = true;
  atualizarIndicadorModificacao();
}

function criarBackupAutomatico() {
  const dados = coletarTodosDados();
  const backup = {
    ...dados,
    backup: true,
    timestamp: Date.now()
  };
  
  try {
    localStorage.setItem(STORAGE_KEY + '_backup', JSON.stringify(backup));
    console.log('Backup automático criado');
  } catch (error) {
    console.error('Erro ao criar backup:', error);
  }
}

// Funções placeholder para compatibilidade
function coletaDados() {
  marcarDadosComoModificados();
  return coletarTodosDados();
}

function calcularIRA() {
  atualizarIRA();
}

// Detectar quando o usuário está prestes a sair da página
window.addEventListener('beforeunload', function(e) {
  if (dadosModificados) {
    salvarDados();
    const mensagem = 'Você tem dados não salvos. Deseja realmente sair? Os dados foram salvos automaticamente.';
    e.returnValue = mensagem;
    return mensagem;
  }
});

// Detectar quando o foco sai da janela
document.addEventListener('visibilitychange', function() {
  if (document.hidden && dadosModificados) {
    salvarDados();
  }
});

/* =====================================
   7. FUNÇÕES DE DEBUG GLOBAIS
   ===================================== */

// Expor funções globalmente para debug (apenas em desenvolvimento)
if (typeof window !== 'undefined') {
  window.debugAviso = debugAviso;
  window.restaurarAviso = restaurarAviso;
  
  // Log de inicialização
  console.log('[IRA] Funções de debug disponíveis: debugAviso(), restaurarAviso()');
}
