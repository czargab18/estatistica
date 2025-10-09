/**
 * Book Visibility Manager
 * Gerencia a visibilidade de elementos de livros baseado na existência dos diretórios
 */

(function() {
    'use strict';

    /**
     * Lista de diretórios conhecidos do book que devem ser verificados
     * Pode ser configurado dinamicamente ou manualmente
     */
    const KNOWN_BOOKS = [
        'TAS0000',
        'EST0033',
        'MAT0075',
        'CIC0007',
        'EST0001',
        'EST0069',
        'MAT0025',
        'EST0070',
        'MAT0026',
        'MAT0031',
        'EST0017',
        'EST0087',
        'MAT0027',
        'MAT0053',
        'EST0035',
        'EST0036',
        'EST0046',
        'EST0081',
        'EST0091',
        'EST0092'
    ];

    /**
     * Verifica se um diretório de livro existe fazendo uma requisição HEAD
     * @param {string} bookCode - Código do livro (ex: EST0033)
     * @returns {Promise<boolean>}
     */
    async function checkBookExists(bookCode) {
        try {
            const response = await fetch(`/book/${bookCode}/index.html`, {
                method: 'HEAD',
                cache: 'no-cache'
            });
            return response.ok;
        } catch (error) {
            console.warn(`Erro ao verificar livro ${bookCode}:`, error);
            return false;
        }
    }

    /**
     * Atualiza a visibilidade de um elemento de livro
     * @param {HTMLElement} bookElement - Elemento do livro
     * @param {boolean} exists - Se o livro existe
     */
    function updateBookVisibility(bookElement, exists) {
        if (exists) {
            bookElement.style.display = 'block';
            bookElement.removeAttribute('data-book-missing');
        } else {
            bookElement.style.display = 'none';
            bookElement.setAttribute('data-book-missing', 'true');
        }
    }

    /**
     * Extrai o código do livro de uma URL
     * @param {string} href - URL do livro
     * @returns {string|null}
     */
    function extractBookCode(href) {
        const match = href.match(/\/book\/([^\/]+)\/?/);
        return match ? match[1] : null;
    }

    /**
     * Verifica e atualiza a visibilidade de todos os livros
     */
    async function updateAllBooksVisibility() {
        const bookItems = document.querySelectorAll('a.book-item[href*="/book/"]');
        
        if (bookItems.length === 0) {
            console.log('Nenhum item de livro encontrado na página');
            return;
        }

        console.log(`Verificando ${bookItems.length} livros...`);

        // Criar um mapa de promises para verificar todos os livros
        const checks = [];
        const bookElements = [];

        bookItems.forEach(item => {
            const href = item.getAttribute('href');
            const bookCode = extractBookCode(href);
            
            if (bookCode) {
                bookElements.push({ element: item, code: bookCode });
                checks.push(checkBookExists(bookCode));
            }
        });

        // Aguardar todas as verificações
        const results = await Promise.all(checks);

        // Atualizar a visibilidade baseado nos resultados
        results.forEach((exists, index) => {
            const { element, code } = bookElements[index];
            updateBookVisibility(element, exists);
            console.log(`${code}: ${exists ? '✓ Existe' : '✗ Não encontrado'}`);
        });

        // Atualizar visibilidade dos títulos de seção
        updateSectionTitlesVisibility();
    }

    /**
     * Atualiza a visibilidade dos títulos de seção baseado se há livros visíveis
     */
    function updateSectionTitlesVisibility() {
        const sections = document.querySelectorAll('h2.book-title');
        
        sections.forEach(title => {
            // Encontrar todos os itens de livro após este título até o próximo título
            let hasVisibleBooks = false;
            let nextElement = title.nextElementSibling;
            
            while (nextElement && !nextElement.classList.contains('book-title')) {
                if (nextElement.classList.contains('book-item')) {
                    const display = window.getComputedStyle(nextElement).display;
                    if (display !== 'none') {
                        hasVisibleBooks = true;
                        break;
                    }
                }
                nextElement = nextElement.nextElementSibling;
            }
            
            // Mostrar o título apenas se houver livros visíveis
            title.style.display = hasVisibleBooks ? 'block' : 'none';
        });
    }

    /**
     * Força a atualização manual de um livro específico
     * @param {string} bookCode - Código do livro
     */
    async function refreshBookStatus(bookCode) {
        const bookItem = document.querySelector(`a.book-item[href*="/book/${bookCode}"]`);
        if (bookItem) {
            const exists = await checkBookExists(bookCode);
            updateBookVisibility(bookItem, exists);
            updateSectionTitlesVisibility();
            return exists;
        }
        return false;
    }

    /**
     * Inicializa o gerenciador quando o DOM estiver pronto
     */
    function init() {
        if (document.readyState === 'loading') {
            document.addEventListener('DOMContentLoaded', updateAllBooksVisibility);
        } else {
            updateAllBooksVisibility();
        }
    }

    // Expor funções úteis globalmente para debug/uso manual
    window.BookVisibilityManager = {
        refresh: updateAllBooksVisibility,
        refreshBook: refreshBookStatus,
        checkExists: checkBookExists
    };

    // Inicializar
    init();

})();
