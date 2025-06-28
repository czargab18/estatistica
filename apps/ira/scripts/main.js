document.addEventListener('DOMContentLoaded', function() {
    // Modal de aviso legal
    const modalAvisoLegal = document.getElementById('modal-aviso-legal');
    const botaoFecharAviso = document.getElementById('disclaimer-botao-fechar');
    const modalFecharCirculo = document.querySelector('.modal-fechar-circulo');

    // Mostrar o modal de aviso legal ao carregar a página
    setTimeout(() => {
        modalAvisoLegal.classList.remove('modal-oculto');
    }, 500);

    // Fechar o modal quando o botão de fechar é clicado
    if (botaoFecharAviso) {
        botaoFecharAviso.addEventListener('click', function() {
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
