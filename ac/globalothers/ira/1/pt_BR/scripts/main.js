// JavaScript para o aplicativo de cálculo do IRA

document.addEventListener('DOMContentLoaded', function() {
  // Inicializa as animações de entrada
  inicializarAnimacoes();
  
  // Configura o modal de aviso legal
  configurarModalAvisoLegal();
  
  // Configura o modal de informações sobre o IRA
  configurarModalInfoIRA();
  
  // Inicializa o formulário de cálculo do IRA
  inicializarFormularioIRA();
  
  // Configura os botões do cabeçalho simples
  configurarBotoesCabecalho();
});

/**
 * Inicializa as animações de entrada dos elementos
 */
function inicializarAnimacoes() {
  // Já que as classes de animação estão sendo aplicadas diretamente no HTML,
  // podemos adicionar lógica para animar elementos adicionais aqui no futuro
  
  // Se quiser animar elementos que ainda não possuem a classe 'animacao-ativa':
  const elementosAnimados = document.querySelectorAll('.animacao-entrada:not(.animacao-ativa)');
  
  elementosAnimados.forEach((elemento, index) => {
    setTimeout(() => {
      elemento.classList.add('animacao-ativa');
    }, 100 * index); // Adiciona um pequeno atraso para criar um efeito em cascata
  });
}

/**
 * Configura o comportamento do modal de aviso legal
 */
function configurarModalAvisoLegal() {
  const modal = document.getElementById('modal-aviso-legal');
  const botaoFechar = document.getElementById('disclaimer-botao-fechar');
  
  // Verifica se o aviso já foi aceito antes
  const avisoAceito = localStorage.getItem('avisoLegalAceito');
  
  if (!avisoAceito) {
    // Mostra o modal se o aviso não foi aceito anteriormente
    mostrarModal();
  }
  
  // Adiciona evento para fechar o modal
  if (botaoFechar) {
    botaoFechar.addEventListener('click', fecharModal);
  }
  
  // Permite fechar o modal clicando fora dele
  modal.addEventListener('click', function(e) {
    if (e.target === modal) {
      fecharModal();
    }
  });
  
  /**
   * Mostra o modal de aviso legal
   */
  function mostrarModal() {
    modal.classList.remove('modal-oculto');
    modal.setAttribute('aria-hidden', 'false');
    document.body.style.overflow = 'hidden'; // Impede a rolagem do fundo
    
    // Foca no primeiro elemento focável dentro do modal para acessibilidade
    setTimeout(() => {
      const primeiroFocavel = modal.querySelector('button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])');
      if (primeiroFocavel) {
        primeiroFocavel.focus();
      }
    }, 100);
  }
  
  /**
   * Fecha o modal de aviso legal
   */
  function fecharModal() {
    modal.classList.add('modal-oculto');
    modal.setAttribute('aria-hidden', 'true');
    document.body.style.overflow = ''; // Restaura a rolagem do fundo
    
    // Salva no localStorage que o usuário já viu o aviso
    localStorage.setItem('avisoLegalAceito', 'true');
  }
}

/**
 * Configura o comportamento do modal de informações sobre o IRA
 */
function configurarModalInfoIRA() {
  const modal = document.getElementById('modal-info-ira');
  const botaoFechar = document.getElementById('info-botao-fechar');
  const linkMostrarInfo = document.getElementById('mostrar-info-ira');
  
  // Adiciona evento para abrir o modal
  if (linkMostrarInfo) {
    linkMostrarInfo.addEventListener('click', function(e) {
      e.preventDefault();
      mostrarModal();
    });
  }
  
  // Adiciona evento para fechar o modal
  if (botaoFechar) {
    botaoFechar.addEventListener('click', fecharModal);
  }
  
  // Permite fechar o modal clicando fora dele
  modal.addEventListener('click', function(e) {
    if (e.target === modal) {
      fecharModal();
    }
  });
  
  /**
   * Mostra o modal de informações
   */
  function mostrarModal() {
    modal.classList.remove('modal-oculto');
    modal.setAttribute('aria-hidden', 'false');
    document.body.style.overflow = 'hidden'; // Impede a rolagem do fundo
    
    // Foca no primeiro elemento focável dentro do modal para acessibilidade
    setTimeout(() => {
      const primeiroFocavel = modal.querySelector('button, [href], input, select, textarea, [tabindex]:not([tabindex="-1"])');
      if (primeiroFocavel) {
        primeiroFocavel.focus();
      }
    }, 100);
  }
  
  /**
   * Fecha o modal de informações
   */
  function fecharModal() {
    modal.classList.add('modal-oculto');
    modal.setAttribute('aria-hidden', 'true');
    document.body.style.overflow = ''; // Restaura a rolagem do fundo
  }
}

/**
 * Função para abrir o modal de informações manualmente se necessário
 */
function abrirInfoIRA() {
  const modal = document.getElementById('modal-info-ira');
  modal.classList.remove('modal-oculto');
  modal.setAttribute('aria-hidden', 'false');
  document.body.style.overflow = 'hidden';
}

/**
 * Inicializa o formulário de cálculo do IRA
 */
function inicializarFormularioIRA() {
  // Disciplinas adicionadas pelo usuário
  const disciplinas = [];
  
  // Elementos do DOM
  const botaoAdicionarDisciplina = document.getElementById('adicionar-disciplina');
  const botaoCalcularIRA = document.getElementById('calcular-ira');
  const botaoLimparDisciplinas = document.getElementById('limpar-disciplinas');
  const listaDisciplinas = document.getElementById('lista-disciplinas');
  const valorIRA = document.getElementById('valor-ira');
  
  // Adiciona os listeners de eventos aos botões
  botaoAdicionarDisciplina.addEventListener('click', adicionarDisciplina);
  botaoCalcularIRA.addEventListener('click', calcularIRA);
  botaoLimparDisciplinas.addEventListener('click', limparDisciplinas);
  
  // Configurar o botão de compartilhamento
  const botaoCompartilhar = document.getElementById('compartilhar-ira');
  if (botaoCompartilhar) {
    botaoCompartilhar.addEventListener('click', compartilharIRA);
  }
  
  /**
   * Compartilha o resultado do IRA via WhatsApp
   */
  function compartilharIRA() {
    const valorAtual = document.getElementById('valor-ira').textContent;
    if (valorAtual === '0.00') {
      alert('Calcule seu IRA antes de compartilhar!');
      return;
    }
    
    const totalDisciplinas = disciplinas.length;
    const texto = `Meu IRA atual é ${valorAtual}! Calculado com base em ${totalDisciplinas} disciplina${totalDisciplinas !== 1 ? 's' : ''} usando a calculadora em: ${window.location.href}`;
    
    const urlWhatsApp = `https://wa.me/?text=${encodeURIComponent(texto)}`;
    window.open(urlWhatsApp, '_blank');
  }
  
  /**
   * Adiciona uma disciplina à lista
   */
  function adicionarDisciplina() {
    const codigoDisciplina = document.getElementById('codigo-disciplina').value.trim();
    const creditos = parseInt(document.getElementById('creditos').value);
    const mencao = document.getElementById('mencao').value;
    const periodo = document.getElementById('periodo').value;
    
    // Validação dos campos
    if (!codigoDisciplina) {
      alert('Por favor, insira o código da disciplina.');
      return;
    }
    
    if (isNaN(creditos) || creditos <= 0) {
      alert('Por favor, insira um número válido de créditos.');
      return;
    }
    
    // Cria a nova disciplina
    const disciplina = {
      id: Date.now(), // Identificador único baseado no timestamp
      codigo: codigoDisciplina,
      creditos: creditos,
      mencao: mencao,
      periodo: periodo,
      valor: converterMencaoParaValor(mencao)
    };
    
    // Adiciona à lista de disciplinas
    disciplinas.push(disciplina);
    
    // Atualiza a interface
    atualizarListaDisciplinas();
    
    // Feedback visual
    const mensagem = document.createElement('div');
    mensagem.className = 'mensagem-feedback mensagem-sucesso';
    mensagem.textContent = `Disciplina ${codigoDisciplina} adicionada com sucesso!`;
    document.querySelector('.grupo-campos').appendChild(mensagem);
    
    setTimeout(() => {
      mensagem.style.opacity = '0';
      setTimeout(() => mensagem.remove(), 300);
    }, 2000);
    
    // Limpa os campos do formulário
    document.getElementById('codigo-disciplina').value = '';
    document.getElementById('creditos').value = '4';
    document.getElementById('codigo-disciplina').focus();
  }
  
  /**
   * Atualiza a exibição da lista de disciplinas
   */
  function atualizarListaDisciplinas() {
    // Limpa a lista atual
    listaDisciplinas.innerHTML = '';
    
    if (disciplinas.length === 0) {
      listaDisciplinas.innerHTML = '<div class="mensagem-sem-disciplinas">Nenhuma disciplina adicionada ainda.</div>';
      return;
    }
    
    // Adiciona cada disciplina à lista
    disciplinas.forEach(disciplina => {
      const itemDisciplina = document.createElement('div');
      itemDisciplina.className = 'disciplina-item';
      
      const infoDisciplina = document.createElement('div');
      infoDisciplina.className = 'disciplina-info';
      
      const codigoDisciplina = document.createElement('span');
      codigoDisciplina.className = 'disciplina-codigo';
      codigoDisciplina.textContent = disciplina.codigo;
      
      const creditosDisciplina = document.createElement('span');
      creditosDisciplina.className = 'disciplina-creditos';
      creditosDisciplina.textContent = `${disciplina.creditos} créditos`;
      
      const mencaoDisciplina = document.createElement('span');
      mencaoDisciplina.className = `disciplina-mencao mencao-${disciplina.mencao.toLowerCase()}`;
      mencaoDisciplina.textContent = disciplina.mencao;
      
      infoDisciplina.appendChild(codigoDisciplina);
      infoDisciplina.appendChild(document.createTextNode(' - '));
      infoDisciplina.appendChild(creditosDisciplina);
      infoDisciplina.appendChild(mencaoDisciplina);
      
      const acoesDisciplina = document.createElement('div');
      acoesDisciplina.className = 'disciplina-acoes';
      
      const botaoRemover = document.createElement('button');
      botaoRemover.className = 'botao-disciplina botao-remover';
      botaoRemover.innerHTML = '<svg xmlns="http://www.w3.org/2000/svg" width="16" height="16" fill="currentColor" viewBox="0 0 16 16"><path d="M5.5 5.5A.5.5 0 0 1 6 6v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm2.5 0a.5.5 0 0 1 .5.5v6a.5.5 0 0 1-1 0V6a.5.5 0 0 1 .5-.5zm3 .5a.5.5 0 0 0-1 0v6a.5.5 0 0 0 1 0V6z"/><path fill-rule="evenodd" d="M14.5 3a1 1 0 0 1-1 1H13v9a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2V4h-.5a1 1 0 0 1-1-1V2a1 1 0 0 1 1-1H6a1 1 0 0 1 1-1h2a1 1 0 0 1 1 1h3.5a1 1 0 0 1 1 1v1zM4.118 4 4 4.059V13a1 1 0 0 0 1 1h6a1 1 0 0 0 1-1V4.059L11.882 4H4.118zM2.5 3V2h11v1h-11z"/></svg>';
      botaoRemover.setAttribute('aria-label', 'Remover disciplina');
      botaoRemover.addEventListener('click', () => removerDisciplina(disciplina.id));
      
      acoesDisciplina.appendChild(botaoRemover);
      
      itemDisciplina.appendChild(infoDisciplina);
      itemDisciplina.appendChild(acoesDisciplina);
      
      listaDisciplinas.appendChild(itemDisciplina);
    });
  }
  
  /**
   * Remove uma disciplina da lista
   */
  function removerDisciplina(id) {
    const index = disciplinas.findIndex(d => d.id === id);
    if (index !== -1) {
      const disciplinaRemovida = disciplinas[index];
      disciplinas.splice(index, 1);
      atualizarListaDisciplinas();
      
      // Feedback visual
      const mensagem = document.createElement('div');
      mensagem.className = 'mensagem-feedback mensagem-aviso';
      mensagem.textContent = `Disciplina ${disciplinaRemovida.codigo} removida.`;
      document.querySelector('.tabela-disciplinas').appendChild(mensagem);
      
      setTimeout(() => {
        mensagem.style.opacity = '0';
        setTimeout(() => mensagem.remove(), 300);
      }, 2000);
    }
  }
  
  /**
   * Limpa todas as disciplinas da lista
   */
  function limparDisciplinas() {
    if (disciplinas.length === 0) return;
    
    if (confirm('Tem certeza que deseja limpar todas as disciplinas?')) {
      disciplinas.length = 0;
      atualizarListaDisciplinas();
      valorIRA.textContent = '0.00';
    }
  }
  
  /**
   * Calcula o IRA com base nas disciplinas adicionadas
   */
  function calcularIRA() {
    if (disciplinas.length === 0) {
      alert('Adicione pelo menos uma disciplina para calcular o IRA.');
      return;
    }
    
    let somaProdutos = 0;
    let somaCreditos = 0;
    
    disciplinas.forEach(disciplina => {
      somaProdutos += disciplina.valor * disciplina.creditos;
      somaCreditos += disciplina.creditos;
    });
    
    const ira = somaCreditos === 0 ? 0 : somaProdutos / somaCreditos;
    
    // Atualiza o valor do IRA na interface
    valorIRA.textContent = ira.toFixed(2);
    
    // Efeito de destaque na atualização
    valorIRA.classList.add('destacar');
    setTimeout(() => {
      valorIRA.classList.remove('destacar');
    }, 1500);
    
    // Feedback sobre o IRA calculado
    let mensagemFeedback;
    let classeFeedback;
    
    if (ira >= 4.5) {
      mensagemFeedback = "Excelente! Seu IRA está muito bom.";
      classeFeedback = "mensagem-sucesso";
    } else if (ira >= 3.5) {
      mensagemFeedback = "Bom trabalho! Seu IRA está acima da média.";
      classeFeedback = "mensagem-sucesso";
    } else if (ira >= 2.5) {
      mensagemFeedback = "Seu IRA está na média. Continue se esforçando!";
      classeFeedback = "mensagem-aviso";
    } else {
      mensagemFeedback = "Atenção! Seu IRA está abaixo da média.";
      classeFeedback = "mensagem-erro";
    }
    
    // Remove qualquer mensagem anterior
    const mensagemAnterior = document.querySelector('.resultado-ira .mensagem-feedback');
    if (mensagemAnterior) {
      mensagemAnterior.remove();
    }
    
    // Adiciona a nova mensagem
    const mensagem = document.createElement('div');
    mensagem.className = `mensagem-feedback ${classeFeedback}`;
    mensagem.textContent = mensagemFeedback;
    document.querySelector('.resultado-ira').appendChild(mensagem);
  }
  
  /**
   * Converte a menção para o valor numérico correspondente
   */
  function converterMencaoParaValor(mencao) {
    switch (mencao) {
      case 'SS': return 5.0;
      case 'MS': return 4.0;
      case 'MM': return 3.0;
      case 'MI': return 2.0;
      case 'II': return 1.0;
      case 'SR': return 0.0;
      default: return 0.0;
    }
  }
}

// Expõe a função para uso global
window.abrirAvisoLegal = abrirAvisoLegal;
window.abrirInfoIRA = abrirInfoIRA;

/**
 * Configura os botões do cabeçalho simples
 */
function configurarBotoesCabecalho() {
  const botaoSimularIraSemestre = document.getElementById('simular-ira-semestre');
  const botaoPreverIraCurso = document.getElementById('prever-ira-curso');
  
  if (botaoSimularIraSemestre) {
    botaoSimularIraSemestre.addEventListener('click', function() {
      // Por padrão, já estamos na tela de simulação de IRA por semestre
      // Podemos apenas rolar para o formulário
      const formulario = document.querySelector('.formulario-ira');
      if (formulario) {
        formulario.scrollIntoView({ behavior: 'smooth' });
      }
    });
  }
  
  if (botaoPreverIraCurso) {
    botaoPreverIraCurso.addEventListener('click', function() {
      // Aqui poderia mudar para uma segunda aba ou mostrar outro formulário
      // Por enquanto, mostramos um alerta informando que essa funcionalidade está em desenvolvimento
      alert('A funcionalidade de previsão do IRA final do curso está em desenvolvimento. Em breve estará disponível!');
    });
  }
}
