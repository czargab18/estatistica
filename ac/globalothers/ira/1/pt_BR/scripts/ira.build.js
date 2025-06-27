// Nova estrutura de código para o cálculo do IRA
// 1. Ao invés injetar html com JaVascript, os elemtos HTML
//    estarão na página mas ocultos par ao usuário.
// 2. O javascrit apenas ira desocultar os elementos e adicionar
//    os eventos necessários para o funcionamento do IRA.


let periodoCount = 0;
let disciplinaCount = {};
const maxDisciplinas = 8;
const maxPeriodos = 20;

document.addEventListener("DOMContentLoaded", () => {
  // Adicionar evento ao botão "Novo Período"
  const botaoNovoPeriodo = document.getElementById("novoPeriodo");
  if (botaoNovoPeriodo) {
    botaoNovoPeriodo.addEventListener("click", criaPeriodo);
  }

  // Carregar dados salvos automaticamente
  carregarDados();

  // Criar botões de funcionalidades adicionais
  criarBotoesAdicionais();
  
  // Adicionar tooltips aos botões
  setTimeout(adicionarTooltips, 100);
  
  // Iniciar sistema de auto-save
  iniciarAutoSave();
  
  // Adicionar atalhos de teclado
  adicionarAtalhosTeclado();
  
  // Resetar flag de modificação inicial
  dadosModificados = false;
  atualizarIndicadorModificacao();
  
  // Mostrar dicas de uso
  setTimeout(() => {
    mostrarNotificacao('Dica: Use Ctrl+S para salvar, Ctrl+N para novo período, Ctrl+E para exportar CSV, Ctrl+I para importar CSV', 'info', 5000);
  }, 2000);
});

// Função para criar botões adicionais
function criarBotoesAdicionais() {
  const linhaSuperior = document.getElementById("linhaSuperior");
  if (!linhaSuperior) return;

  // Botão para baixar CSV
  const btnBaixarCSV = document.createElement("button");
  btnBaixarCSV.id = "baixarCSV";
  btnBaixarCSV.className = "btn btn-info";
  btnBaixarCSV.textContent = "Baixar CSV";
  btnBaixarCSV.addEventListener("click", baixarDadosCSV);

  // Input para importar dados CSV
  const inputImportar = document.createElement("input");
  inputImportar.type = "file";
  inputImportar.accept = ".csv";
  inputImportar.id = "importarDados";
  inputImportar.style.display = "none";
  inputImportar.addEventListener("change", importarDadosCSV);

  // Botão para importar dados
  const btnImportar = document.createElement("button");
  btnImportar.id = "importarCSV";
  btnImportar.className = "btn btn-warning";
  btnImportar.textContent = "Importar CSV";
  btnImportar.addEventListener("click", () => inputImportar.click());

  // Botão para limpar dados
  const btnLimpar = document.createElement("button");
  btnLimpar.id = "limparDados";
  btnLimpar.className = "btn btn-danger";
  btnLimpar.textContent = "Limpar Tudo";
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
        mostrarNotificacao('Todos os dados foram limpos!', 'info');
      }
    );
  });

  // Botão para estatísticas
  const btnEstatisticas = document.createElement("button");
  btnEstatisticas.id = "toggleEstatisticas";
  btnEstatisticas.className = "btn btn-secondary";
  btnEstatisticas.textContent = "Estatísticas";
  btnEstatisticas.addEventListener("click", () => {
    const area = document.getElementById('estatisticas-rapidas');
    if (area) {
      const isVisible = area.style.display !== 'none';
      area.style.display = isVisible ? 'none' : 'block';
      btnEstatisticas.textContent = isVisible ? 'Estatísticas' : 'Ocultar Stats';
      if (!isVisible) {
        atualizarEstatisticas();
      }
    }
  });

  // Adicionar botões à linha superior
  linhaSuperior.appendChild(btnBaixarCSV);
  linhaSuperior.appendChild(btnImportar);
  linhaSuperior.appendChild(inputImportar);
  linhaSuperior.appendChild(btnEstatisticas);
  linhaSuperior.appendChild(btnLimpar);
}

function criaPeriodo() {
  if (periodoCount >= maxPeriodos) {
    alert(`Você só pode adicionar até ${maxPeriodos} períodos.`);
    return;
  }

  periodoCount++;
  disciplinaCount[periodoCount] = 0;

  const container = document.getElementById("container-periodos");

  const periodoDiv = document.createElement("div");
  periodoDiv.id = `periodo${periodoCount}`;
  periodoDiv.innerHTML = `
    <div class="periodo-title">
      <h3>${periodoCount}º Período</h3>
      <div class="periodo-title-btns">
        <button class="btn btn-danger remove-periodo">Remover Período</button>
        <button class="btn btn-primary adicionar-disciplina">Adicionar Disciplina</button>
      </div>
    </div>
    <div id="periodo${periodoCount}-disciplinas"></div>
  `;

  container.appendChild(periodoDiv);

  // Adicionar eventos aos botões recém-criados
  const botaoRemoverPeriodo = periodoDiv.querySelector(".remove-periodo");
  const botaoAdicionarDisciplina = periodoDiv.querySelector(".adicionar-disciplina");

  botaoRemoverPeriodo.addEventListener("click", () => removerPeriodo(periodoCount));
  botaoAdicionarDisciplina.addEventListener("click", () => adicionarDisciplina(periodoCount));

  adicionarDisciplina(periodoCount);
}

function removerPeriodo(periodoId) {
  const periodoDiv = document.getElementById(`periodo${periodoId}`);
  if (periodoDiv) {
    periodoDiv.remove();
    delete disciplinaCount[periodoId];
    periodoCount--;
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

  const disciplinaDiv = document.createElement("div");
  disciplinaDiv.id = `periodo${periodoId}-disciplina${disciplinaId}-preencher`;
  disciplinaDiv.className = `preencher-linha`;
  disciplinaDiv.innerHTML = `
    <div id="periodo${periodoId}-disciplina${disciplinaId}-lista" class="left">
      <div class="col-items">
        <input
          type="text"
          id="periodo${periodoId}-disciplina${disciplinaId}-codigo"
          class="form-control"
          placeholder="Código da Disciplina"
          pattern="[A-Z]{3}[0-9]{4}"
          title="O código será automaticamente formatado para 3 letras maiúsculas e 4 números (ex.: ABC1234)."
          maxlength="7"
        />
      </div>
      <div class="col-items">
        <select id="periodo${periodoId}-disciplina${disciplinaId}-creditos" class="form-control">
          <option value="" selected disabled>Selecione os Créditos</option>
          <option value="2">2 Créditos</option>
          <option value="3">3 Créditos</option>
          <option value="4">4 Créditos</option>
          <option value="6">6 Créditos</option>
          <option value="8">8 Créditos</option>
          <option value="10">10 Créditos</option>
          <option value="12">12 Créditos</option>
          <option value="16">16 Créditos</option>
          <option value="22">22 Créditos</option>
          <option value="40">40 Créditos</option>
          <option value="52">52 Créditos</option>
          <option value="64">64 Créditos</option>
        </select>
      </div>
      <div class="col-items">
        <select id="periodo${periodoId}-disciplina${disciplinaId}-mencao" class="form-control">
          <option value="" selected disabled>Menção</option>
          <option value="SR">SR</option>
          <option value="II">II</option>
          <option value="MI">MI</option>
          <option value="MM">MM</option>
          <option value="MS">MS</option>
          <option value="SS">SS</option>
        </select>
      </div>
    </div>
    <div id="periodo${periodoId}-disciplina${disciplinaId}-status-removeDiscp" class="rigth">
      <div class="col-items">
        <span id="status-${periodoId}-${disciplinaId}">Status</span>
      </div>
      <div class="col-items">
        <button class="btn btn-danger remover-disciplina">Remover Disciplina</button>
      </div>
    </div>
  `;

  disciplinasDiv.appendChild(disciplinaDiv);

  // Adicionar eventos aos elementos recém-criados
  const inputCodigo = disciplinaDiv.querySelector(`#periodo${periodoId}-disciplina${disciplinaId}-codigo`);
  const selectCreditos = disciplinaDiv.querySelector(`#periodo${periodoId}-disciplina${disciplinaId}-creditos`);
  const selectMencao = disciplinaDiv.querySelector(`#periodo${periodoId}-disciplina${disciplinaId}-mencao`);
  const botaoRemoverDisciplina = disciplinaDiv.querySelector(".remover-disciplina");

  inputCodigo.addEventListener("input", () => formatarCodigo(inputCodigo));
  selectMencao.addEventListener("change", () => atualizarStatus(periodoId, disciplinaId));
  botaoRemoverDisciplina.addEventListener("click", () => removerDisciplina(periodoId, disciplinaId));

  adicionarEventosParaMonitoramento(periodoId, disciplinaId);
}

function removerDisciplina(periodoId, disciplinaId) {
  const disciplinaDiv = document.getElementById(`periodo${periodoId}-disciplina${disciplinaId}-preencher`);
  if (disciplinaDiv) {
    disciplinaDiv.remove();
    disciplinaCount[periodoId]--;
  }
}

function determinarStatus(mencao) {
  const aprovadas = ["MM", "MS", "SS"];
  return aprovadas.includes(mencao) ? "Aprovado" : "Reprovado";
}

function atualizarStatus(periodoId, disciplinaId) {
  const mencao = document.getElementById(`periodo${periodoId}-disciplina${disciplinaId}-mencao`).value;
  const statusSpan = document.getElementById(`status-${periodoId}-${disciplinaId}`);

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

  codigo.addEventListener("input", () => {
    coletaDados();
    calcularIRA();
    marcarDadosComoModificados();
  });
  creditos.addEventListener("change", () => {
    coletaDados();
    calcularIRA();
    marcarDadosComoModificados();
  });
  mencao.addEventListener("change", () => {
    coletaDados();
    calcularIRA();
    marcarDadosComoModificados();
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

// =====================================
// NOVAS FUNCIONALIDADES - ISSUE #19
// =====================================

// Sistema de Cookies para salvar/carregar dados
const STORAGE_KEY = 'ira_dados_salvos';

// Função para salvar dados nos cookies/localStorage
function salvarDados() {
  const dados = coletarTodosDados();
  try {
    // Salvar em formato JSON para funcionamento interno
    localStorage.setItem(STORAGE_KEY, JSON.stringify(dados));

    // Salvar também em formato CSV estruturado como backup
    const csvData = gerarCSVEstruturado(dados);
    localStorage.setItem(STORAGE_KEY + '_csv', csvData);

    console.log('Dados salvos com sucesso!');
    mostrarNotificacao('Dados salvos automaticamente!', 'success');
    dadosModificados = false;
    return true;
  } catch (error) {
    console.error('Erro ao salvar dados:', error);
    mostrarNotificacao('Erro ao salvar dados!', 'error');
    return false;
  }
}

// Função auxiliar para gerar CSV estruturado
function gerarCSVEstruturado(dados) {
  let csv = 'periodo;disciplina;creditos;mencao;status\n';

  dados.periodos.forEach(periodo => {
    periodo.disciplinas.forEach(disciplina => {
      if (disciplina.codigo && disciplina.creditos && disciplina.mencao) {
        const status = determinarStatus(disciplina.mencao);
        csv += `${periodo.id};${disciplina.codigo};${disciplina.creditos};${disciplina.mencao};${status}\n`;
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
      mostrarNotificacao('Dados anteriores carregados!', 'info', 2000);
      return true;
    }
  } catch (error) {
    console.error('Erro ao carregar dados:', error);
    mostrarNotificacao('Erro ao carregar dados salvos!', 'error');
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
  // Limpar formulário atual
  limparFormulario();

  dados.periodos.forEach(periodo => {
    // Criar período se necessário
    while (periodoCount < periodo.id) {
      criaPeriodo();
    }

    periodo.disciplinas.forEach(disciplina => {
      // Adicionar disciplina se necessário
      while (disciplinaCount[periodo.id] < disciplina.id) {
        adicionarDisciplina(periodo.id);
      }

      // Preencher campos
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

  // Recalcular IRA após carregar dados
  atualizarIRA();
}

// Função para limpar formulário
function limparFormulario() {
  const container = document.getElementById("container-periodos");
  container.innerHTML = '';
  periodoCount = 0;
  disciplinaCount = {};
}

// Função para mostrar notificações
function mostrarNotificacao(mensagem, tipo = 'info', duracao = 3000) {
  // Remover notificação anterior se existir
  const notificacaoExistente = document.querySelector('.status-message');
  if (notificacaoExistente) {
    notificacaoExistente.remove();
  }

  // Criar nova notificação
  const notificacao = document.createElement('div');
  notificacao.className = `status-message ${tipo}`;
  notificacao.textContent = mensagem;
  
  document.body.appendChild(notificacao);
  
  // Mostrar notificação
  setTimeout(() => {
    notificacao.classList.add('show');
  }, 100);
  
  // Remover notificação após duração especificada
  setTimeout(() => {
    notificacao.classList.remove('show');
    setTimeout(() => {
      if (notificacao.parentNode) {
        notificacao.remove();
      }
    }, 300);
  }, duracao);
}

// Função para atualizar o título com indicador de modificação
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

// Atualizar função marcarDadosComoModificados
function marcarDadosComoModificados() {
  dadosModificados = true;
  atualizarIndicadorModificacao();
}

// Função para salvar dados periodicamente (auto-save)
let autoSaveTimer;
function iniciarAutoSave() {
  // Salvar a cada 30 segundos se houver modificações
  autoSaveTimer = setInterval(() => {
    if (dadosModificados) {
      salvarDados();
    }
  }, 30000);
}

// Função para adicionar tooltips aos botões
function adicionarTooltips() {
  const botoes = [
    { id: 'novoPeriodo', tooltip: 'Adicionar um novo período acadêmico (Ctrl+N)' },
    { id: 'baixarCSV', tooltip: 'Baixar dados em formato CSV estruturado (Ctrl+E)' },
    { id: 'importarCSV', tooltip: 'Importar dados de arquivo CSV (Ctrl+I)' },
    { id: 'toggleEstatisticas', tooltip: 'Mostrar/ocultar estatísticas detalhadas' },
    { id: 'limparDados', tooltip: 'Limpar todos os dados do formulário' }
  ];

  botoes.forEach(({ id, tooltip }) => {
    const botao = document.getElementById(id);
    if (botao) {
      botao.classList.add('btn-tooltip');
      botao.setAttribute('data-tooltip', tooltip);
    }
  });
}

// Função para validar dados antes de salvar
function validarDados(dados) {
  let valido = true;
  let mensagensErro = [];

  dados.periodos.forEach((periodo, periodoIndex) => {
    periodo.disciplinas.forEach((disciplina, disciplinaIndex) => {
      if (disciplina.codigo && (!disciplina.creditos || !disciplina.mencao)) {
        valido = false;
        mensagensErro.push(`Período ${periodo.id}, Disciplina ${disciplina.id}: Créditos e Menção são obrigatórios`);
      }
    });
  });

  if (!valido) {
    mostrarNotificacao('Dados incompletos detectados!', 'error');
    console.warn('Erros de validação:', mensagensErro);
  }

  return valido;
}

// Função melhorada para baixar CSV com validação
function baixarDadosCSV() {
  const dados = coletarTodosDados();
  
  if (!validarDados(dados)) {
    if (!confirm('Existem dados incompletos. Deseja continuar mesmo assim?')) {
      return;
    }
  }

  // Formato estruturado: periodo;disciplina;creditos;mencao;status
  let csv = 'periodo;disciplina;creditos;mencao;status\n';

  dados.periodos.forEach(periodo => {
    periodo.disciplinas.forEach(disciplina => {
      if (disciplina.codigo && disciplina.creditos && disciplina.mencao) {
        const status = determinarStatus(disciplina.mencao);
        csv += `${periodo.id};${disciplina.codigo};${disciplina.creditos};${disciplina.mencao};${status}\n`;
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
  
  mostrarNotificacao('Arquivo CSV baixado com sucesso!', 'success');
}

// Função para importar dados de arquivo CSV
function importarDadosCSV(event) {
  const file = event.target.files[0];
  if (!file) return;

  const reader = new FileReader();
  reader.onload = function(e) {
    try {
      const csvText = e.target.result;
      const linhas = csvText.split('\n');

      // Verificar se tem cabeçalho correto
      const cabecalho = linhas[0].trim().toLowerCase();
      if (cabecalho !== 'periodo;disciplina;creditos;mencao;status') {
        alert('Formato de arquivo inválido. O cabeçalho deve ser: periodo;disciplina;creditos;mencao;status');
        return;
      }

      // Processar dados
      const dadosImportados = { periodos: [] };
      const periodosMap = new Map();

      // Pular o cabeçalho e processar cada linha
      for (let i = 1; i < linhas.length; i++) {
        const linha = linhas[i].trim();
        if (!linha) continue; // Pular linhas vazias

        const campos = linha.split(';');
        if (campos.length !== 5) {
          console.warn(`Linha ${i + 1} ignorada - formato inválido: ${linha}`);
          continue;
        }

        const [periodo, disciplina, creditos, mencao, status] = campos.map(campo => campo.trim());

        // Validar dados
        if (!periodo || !disciplina || !creditos || !mencao) {
          console.warn(`Linha ${i + 1} ignorada - dados incompletos: ${linha}`);
          continue;
        }

        const periodoNum = parseInt(periodo);
        if (isNaN(periodoNum)) {
          console.warn(`Linha ${i + 1} ignorada - período inválido: ${periodo}`);
          continue;
        }

        // Verificar se menção é válida
        const mencoesValidas = ['SR', 'II', 'MI', 'MM', 'MS', 'SS'];
        if (!mencoesValidas.includes(mencao.toUpperCase())) {
          console.warn(`Linha ${i + 1} ignorada - menção inválida: ${mencao}`);
          continue;
        }

        // Criar período se não existir
        if (!periodosMap.has(periodoNum)) {
          periodosMap.set(periodoNum, {
            id: periodoNum,
            disciplinas: []
          });
        }

        // Adicionar disciplina ao período
        periodosMap.get(periodoNum).disciplinas.push({
          id: periodosMap.get(periodoNum).disciplinas.length + 1,
          codigo: disciplina.toUpperCase(),
          creditos: creditos,
          mencao: mencao.toUpperCase()
        });
      }

      // Converter Map para array e ordenar por período
      dadosImportados.periodos = Array.from(periodosMap.values()).sort((a, b) => a.id - b.id);

      if (dadosImportados.periodos.length === 0) {
        alert('Nenhum dado válido encontrado no arquivo CSV.');
        return;
      }

      // Limpar formulário atual e preencher com dados importados
      limparFormulario();
      preencherFormularioComDados(dadosImportados);

      const totalDisciplinas = dadosImportados.periodos.reduce((total, periodo) => total + periodo.disciplinas.length, 0);
      mostrarNotificacao(`Dados importados: ${dadosImportados.periodos.length} períodos, ${totalDisciplinas} disciplinas!`, 'success');

    } catch (error) {
      alert('Erro ao importar dados CSV. Verifique se o arquivo está no formato correto.');
      console.error('Erro ao importar CSV:', error);
    }
  };
  reader.readAsText(file);
}

// Sistema de aviso para salvar dados antes de sair
let dadosModificados = false;

// Detectar quando o usuário está prestes a sair da página
window.addEventListener('beforeunload', function(e) {
  if (dadosModificados) {
    // Salvar automaticamente
    salvarDados();
    
    // Mostrar aviso
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

// Função placeholder para coletaDados (compatibilidade)
function coletaDados() {
  marcarDadosComoModificados();
  return coletarTodosDados();
}

// Função placeholder para calcularIRA
function calcularIRA() {
  atualizarIRA();
}

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
  
  // Atualizar display do IRA
  const iraDisplay = document.getElementById('ira-mp');
  if (iraDisplay) {
    iraDisplay.textContent = `IRA: ${ira} MP: ${totalCreditos}`;
  }
  
  // Atualizar estatísticas se a área estiver visível
  const areaEstatisticas = document.getElementById('estatisticas-rapidas');
  if (areaEstatisticas && areaEstatisticas.style.display !== 'none') {
    atualizarEstatisticas();
  }
  
  // Criar backup automático a cada cálculo
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

// Sistema de Modal para confirmações
function mostrarModal(titulo, mensagem, callback) {
  const modal = document.getElementById('modal-confirmacao');
  const modalTitulo = document.getElementById('modal-titulo');
  const modalMensagem = document.getElementById('modal-mensagem');
  const modalConfirmar = document.getElementById('modal-confirmar');
  const modalCancelar = document.getElementById('modal-cancelar');

  modalTitulo.textContent = titulo;
  modalMensagem.textContent = mensagem;
  modal.style.display = 'block';

  // Remover listeners anteriores
  modalConfirmar.replaceWith(modalConfirmar.cloneNode(true));
  modalCancelar.replaceWith(modalCancelar.cloneNode(true));

  // Adicionar novos listeners
  document.getElementById('modal-confirmar').addEventListener('click', () => {
    modal.style.display = 'none';
    if (callback) callback();
  });

  document.getElementById('modal-cancelar').addEventListener('click', () => {
    modal.style.display = 'none';
  });

  // Fechar com ESC ou clique fora
  const fecharModal = (e) => {
    if (e.key === 'Escape' || e.target === modal) {
      modal.style.display = 'none';
      document.removeEventListener('keydown', fecharModal);
      modal.removeEventListener('click', fecharModal);
    }
  };

  document.addEventListener('keydown', fecharModal);
  modal.addEventListener('click', fecharModal);
}

// Função para calcular e exibir estatísticas
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

  // Atualizar elementos na página
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

  // Mostrar/ocultar área de estatísticas
  const areaEstatisticas = document.getElementById('estatisticas-rapidas');
  if (areaEstatisticas) {
    areaEstatisticas.style.display = totalDisciplinas > 0 ? 'block' : 'none';
  }
}

// Função para adicionar atalhos de teclado
function adicionarAtalhosTeclado() {
  document.addEventListener('keydown', (e) => {
    // Ctrl+S para salvar
    if (e.ctrlKey && e.key === 's') {
      e.preventDefault();
      salvarDados();
      mostrarNotificacao('Dados salvos manualmente!', 'success');
    }
    
    // Ctrl+N para novo período
    if (e.ctrlKey && e.key === 'n') {
      e.preventDefault();
      criaPeriodo();
    }
    
    // Ctrl+E para exportar CSV
    if (e.ctrlKey && e.key === 'e') {
      e.preventDefault();
      baixarDadosCSV();
    }
    
    // Ctrl+I para importar CSV
    if (e.ctrlKey && e.key === 'i') {
      e.preventDefault();
      document.getElementById('importarDados')?.click();
    }
  });
}

// Função para backup automático
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

// Função para restaurar backup
function restaurarBackup() {
  try {
    const backup = localStorage.getItem(STORAGE_KEY + '_backup');
    if (backup) {
      const dados = JSON.parse(backup);
      preencherFormularioComDados(dados);
      mostrarNotificacao('Backup restaurado com sucesso!', 'success');
      return true;
    }
  } catch (error) {
    console.error('Erro ao restaurar backup:', error);
    mostrarNotificacao('Erro ao restaurar backup!', 'error');
  }
  return false;
}

