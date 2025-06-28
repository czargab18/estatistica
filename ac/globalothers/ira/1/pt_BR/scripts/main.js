document.addEventListener('DOMContentLoaded', function() {
    // Seção de aviso
    const secaoAviso = document.getElementById('secao-aviso');
    const botaoFecharAviso = document.getElementById('aviso-botao-fechar');

    // Verifica se o aviso já foi fechado anteriormente
    if (localStorage.getItem('avisoFechado') === 'true') {
        secaoAviso.style.display = 'none';
    }

    // Fechar a seção de aviso quando o botão de fechar é clicado
    if (botaoFecharAviso) {
        botaoFecharAviso.addEventListener('click', function() {
            secaoAviso.style.display = 'none';
            // Armazenar a preferência do usuário por 7 dias
            localStorage.setItem('avisoFechado', 'true');
            setTimeout(() => {
                // Após 7 dias, limpar a preferência
                localStorage.removeItem('avisoFechado');
            }, 7 * 24 * 60 * 60 * 1000);
        });
    }

    // Código antigo para o modal (caso ainda seja usado em algum lugar)
    const modalAvisoLegal = document.getElementById('modal-aviso-legal');
    const disclaimerBotaoFechar = document.getElementById('disclaimer-botao-fechar');
    const modalFecharCirculo = document.querySelector('.modal-fechar-circulo');
    
    if (modalAvisoLegal) {
        // Fechar o modal quando o botão de fechar é clicado
        if (disclaimerBotaoFechar) {
            disclaimerBotaoFechar.addEventListener('click', function() {
                modalAvisoLegal.classList.add('modal-oculto');
            });
        }
        
        // Fechar o modal quando clicar no círculo preto
        if (modalFecharCirculo) {
            modalFecharCirculo.addEventListener('click', function() {
                modalAvisoLegal.classList.add('modal-oculto');
            });
        }
        
        // Fechar o modal quando clicar fora dele
        modalAvisoLegal.addEventListener('click', function(e) {
            if (e.target === modalAvisoLegal) {
                modalAvisoLegal.classList.add('modal-oculto');
            }
        });
    }

    // Modal de informações sobre o IRA
    const modalInfoIra = document.getElementById('modal-info-ira');
    const botaoFecharInfo = document.getElementById('info-botao-fechar');
    
    // Botões para abrir modais
    const simularSemestre = document.getElementById('simular-ira-semestre');
    const preverCurso = document.getElementById('prever-ira-curso');

    // Fechar o modal de informações quando o botão de fechar é clicado
    if (botaoFecharInfo) {
        botaoFecharInfo.addEventListener('click', function() {
            modalInfoIra.classList.add('modal-oculto');
        });

        // Fechar o modal quando clicar fora dele
        modalInfoIra.addEventListener('click', function(e) {
            if (e.target === modalInfoIra) {
                modalInfoIra.classList.add('modal-oculto');
            }
        });
    }
});
