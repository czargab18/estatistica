/**
 * Controle da Seção de Aviso Legal - IRA
 * 
 * Este script gerencia o comportamento da seção de aviso legal no site do IRA.
 * Implementa funcionalidades de exibição, fechamento e persistência da preferência do usuário.
 * 
 * Inspirado nos padrões e práticas do ira.build.js para manter consistência no projeto.
 * 
 * Funcionalidades:
 * - Verificação automática do estado de fechamento do aviso
 * - Persistência no localStorage por 7 dias
 * - Animações CSS para fechamento suave
 * - Suporte a atalhos de teclado (ESC)
 * - Notificações de feedback
 * - Configuração de acessibilidade
 * - Funções de debug e restauração
 */

// Aguardar carregamento do DOM antes de inicializar
document.addEventListener("DOMContentLoaded", () => {
  console.log('[Aviso] Inicializando controle do aviso legal');
  inicializarControleAviso();
});

/**
 * Função principal para inicializar o controle do aviso
 * Baseada no padrão de inicialização do ira.build.js
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
 * Baseada no padrão de verificação do localStorage do ira.build.js
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
 * Baseada no padrão de eventos do ira.build.js
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

  // Fechar com ESC (inspirado no adicionarAtalhosTeclado)
  const handleKeydown = (e) => {
    if (e.key === 'Escape' && !secaoAviso.hidden) {
      fecharAviso();
    }
  };

  document.addEventListener('keydown', handleKeydown);

  // Limpar event listener quando o aviso for fechado (baseado no MutationObserver)
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

// Função para configurar acessibilidade
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

// Função para ocultar o aviso (baseada no padrão style.display)
function ocultarAviso(secaoAviso) {
  secaoAviso.style.display = 'none';
  secaoAviso.hidden = true;
  secaoAviso.setAttribute('aria-hidden', 'true');
}

// Função para salvar preferência de fechamento (baseada no padrão localStorage do script)
function salvarPreferenciaFechamento() {
  try {
    localStorage.setItem('aviso_fechado', 'true');
    localStorage.setItem('aviso_data_fechamento', Date.now().toString());
    console.log('Preferência de fechamento do aviso salva');
  } catch (error) {
    console.error('Erro ao salvar preferência de fechamento:', error);
  }
}

// Função para mostrar notificações (baseada na mostrarNotificacao original)
function mostrarNotificacaoAviso(mensagem, tipo = 'info', duracao = 3000) {
  // Remover notificação anterior se existir
  const notificacaoExistente = document.querySelector('.aviso-notificacao');
  if (notificacaoExistente) {
    notificacaoExistente.remove();
  }

  // Criar nova notificação
  const notificacao = document.createElement('div');
  notificacao.className = `aviso-notificacao ${tipo}`;
  notificacao.textContent = mensagem;
  
  // Estilos inline para a notificação
  Object.assign(notificacao.style, {
    position: 'fixed',
    top: '20px',
    right: '20px',
    padding: '10px 15px',
    borderRadius: '8px',
    backgroundColor: tipo === 'info' ? '#0071e3' : '#ff3b30',
    color: 'white',
    fontSize: '14px',
    fontWeight: '500',
    zIndex: '9999',
    opacity: '0',
    transform: 'translateX(100%)',
    transition: 'all 0.3s ease',
    maxWidth: '300px',
    boxShadow: '0 4px 12px rgba(0, 0, 0, 0.15)'
  });
  
  document.body.appendChild(notificacao);
  
  // Mostrar notificação com animação
  setTimeout(() => {
    notificacao.style.opacity = '1';
    notificacao.style.transform = 'translateX(0)';
  }, 100);
  
  // Remover notificação após duração especificada
  setTimeout(() => {
    notificacao.style.opacity = '0';
    notificacao.style.transform = 'translateX(100%)';
    setTimeout(() => {
      if (notificacao.parentNode) {
        notificacao.remove();
      }
    }, 300);
  }, duracao);
}

// Função para restaurar aviso (útil para testes ou configurações)
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
    
    mostrarNotificacaoAviso('Aviso restaurado', 'info', 2000);
  }
}

// Função para debug - verificar estado do aviso
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

// Expor funções globalmente para debug (apenas em desenvolvimento)
if (typeof window !== 'undefined') {
  window.debugAviso = debugAviso;
  window.restaurarAviso = restaurarAviso;
  
  // Log de inicialização
  console.log('[Aviso] Funções de debug disponíveis: debugAviso(), restaurarAviso()');
}
