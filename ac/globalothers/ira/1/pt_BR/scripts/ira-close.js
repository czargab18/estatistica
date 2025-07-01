/**
 * Função para ocultar a seção de aviso do IRA
 * Remove a classe 'aviso-ira-open' e adiciona 'aviso-ira-closed' para ocultar o aviso
 */
function fecharAvisoIRA() {
    const secaoAviso = document.getElementById('aviso-ira');
  const cabecalhoIRA = document.getElementById('cabecalho-ira');
    
    if (secaoAviso) {
        // Remove a classe que mantém o aviso aberto
        secaoAviso.classList.remove('aviso-ira-open');
        
        // Adiciona a classe que oculta o aviso com transição CSS
        secaoAviso.classList.add('aviso-ira-closed');
        
      // Altera o padding-bottom do cabeçalho IRA
      if (cabecalhoIRA) {
        cabecalhoIRA.style.paddingBottom = '20px';
      }

        // Opcional: remover completamente do DOM após a animação
        setTimeout(() => {
            if (secaoAviso.classList.contains('aviso-ira-closed')) {
                secaoAviso.style.display = 'none';
            }
        }, 400); // 400ms corresponde à duração da transição CSS
    }
}

/**
 * Inicializa os event listeners quando o DOM estiver carregado
 */
document.addEventListener('DOMContentLoaded', function() {
    const botaoFechar = document.getElementById('aviso-botao-fechar');
    
    if (botaoFechar) {
        // Adiciona o event listener para o clique no botão de fechar
        botaoFechar.addEventListener('click', fecharAvisoIRA);
        
        // Opcional: permitir fechar com a tecla Escape
        document.addEventListener('keydown', function(event) {
            if (event.key === 'Escape') {
                const secaoAviso = document.getElementById('aviso-ira');
                if (secaoAviso && secaoAviso.classList.contains('aviso-ira-open')) {
                    fecharAvisoIRA();
                }
            }
        });
    }
});

/**
 * Função alternativa para reabrir o aviso (caso necessário)
 */
function abrirAvisoIRA() {
    const secaoAviso = document.getElementById('aviso-ira');
  const cabecalhoIRA = document.getElementById('cabecalho-ira');
    
    if (secaoAviso) {
        secaoAviso.style.display = 'flex';
        secaoAviso.classList.remove('aviso-ira-closed');
        secaoAviso.classList.add('aviso-ira-open');

      // Restaura o padding-bottom original do cabeçalho IRA
      if (cabecalhoIRA) {
        cabecalhoIRA.style.paddingBottom = '40px';
      }
    }
}