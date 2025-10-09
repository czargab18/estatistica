/**
 * Book Visibility Manager
 * Gerencia a visibilidade de elementos de livros baseado na existência dos diretórios
 * Analisa a pasta /book/ e modifica o display das divs conforme os diretórios existentes
 */

(function () {
  "use strict";

  let availableBooks = new Set();

  /**
   * Busca a lista de diretórios disponíveis na pasta /book/
   * Lê o arquivo disciplinas.json ou analisa os diretórios disponíveis
   * @returns {Promise<Set<string>>}
   */
  async function scanBookDirectory() {
    try {
      // Tenta buscar a lista de disciplinas do arquivo JSON
      const response = await fetch("/books/disciplinas.json", {
        cache: "no-cache",
      });

      if (response.ok) {
        const data = await response.json();
        const books = new Set();

        // Extrair códigos das disciplinas
        if (data.disciplinas && Array.isArray(data.disciplinas)) {
          data.disciplinas.forEach((disciplina) => {
            if (disciplina.codigo) {
              books.add(disciplina.codigo);
            }
          });
        }

        console.log(`📚 Livros encontrados no disciplinas.json: ${books.size}`);
        return books;
      }
    } catch (error) {
      console.warn(
        "Erro ao ler disciplinas.json, tentando método alternativo:",
        error
      );
    }

    // Método alternativo: verificar index.html de cada livro
    return await scanByIndexFiles();
  }

  /**
   * Método alternativo: verifica quais index.html existem
   * @returns {Promise<Set<string>>}
   */
  async function scanByIndexFiles() {
    const books = new Set();
    const possibleBooks = [
      "TAS0000",
      "EST0033",
      "MAT0075",
      "CIC0007",
      "EST0001",
      "EST0069",
      "MAT0025",
      "EST0070",
      "MAT0026",
      "MAT0031",
      "EST0017",
      "EST0087",
      "MAT0027",
      "MAT0053",
      "EST0035",
      "EST0036",
      "EST0046",
      "EST0081",
      "EST0091",
      "EST0092",
    ];

    const checks = possibleBooks.map(async (code) => {
      try {
        const response = await fetch(`/book/${code}/index.html`, {
          method: "HEAD",
          cache: "no-cache",
        });
        if (response.ok) {
          books.add(code);
        }
      } catch (error) {
        // Silenciosamente ignora erros
      }
    });

    await Promise.all(checks);
    console.log(`📂 Livros encontrados por verificação: ${books.size}`);
    return books;
  }

  /**
   * Atualiza a visibilidade de um elemento de livro
   * @param {HTMLElement} bookElement - Elemento do livro (div ou a)
   * @param {boolean} exists - Se o livro existe
   */
  function updateBookVisibility(bookElement, exists) {
    if (exists) {
      bookElement.style.display = ""; // Remove o display inline, usa o CSS padrão
      bookElement.classList.remove("book-hidden");
      bookElement.classList.add("book-visible");
      bookElement.removeAttribute("data-book-missing");
    } else {
      bookElement.style.display = "none";
      bookElement.classList.remove("book-visible");
      bookElement.classList.add("book-hidden");
      bookElement.setAttribute("data-book-missing", "true");
    }
  }

  /**
   * Extrai o código do livro de uma URL
   * @param {string} href - URL do livro
   * @returns {string|null}
   */
  function extractBookCode(href) {
    if (!href) return null;
    const match = href.match(/\/book\/([A-Z]{3}\d{4})\/?/);
    return match ? match[1] : null;
  }

  /**
   * Verifica e atualiza a visibilidade de todos os livros
   */
  async function updateAllBooksVisibility() {
    console.log("🔍 Analisando diretório /book/...");

    // Escanear o diretório para obter lista de livros disponíveis
    availableBooks = await scanBookDirectory();

    if (availableBooks.size === 0) {
      console.warn("⚠️ Nenhum livro encontrado no diretório");
      return;
    }

    // Buscar todos os elementos que referenciam livros
    const bookSelectors = [
      'a.book-item[href*="/book/"]',
      "div.book-item[data-book]",
      "[data-book-code]",
      'a[href^="/book/"]',
    ];

    const bookItems = document.querySelectorAll(bookSelectors.join(", "));

    if (bookItems.length === 0) {
      console.log("ℹ️ Nenhum elemento de livro encontrado na página");
      return;
    }

    console.log(`📖 Processando ${bookItems.length} elementos de livros...`);

    let visibleCount = 0;
    let hiddenCount = 0;

    bookItems.forEach((item) => {
      let bookCode = null;

      // Tentar extrair o código de diferentes formas
      const href = item.getAttribute("href");
      const dataBook =
        item.getAttribute("data-book") || item.getAttribute("data-book-code");

      if (dataBook) {
        bookCode = dataBook;
      } else if (href) {
        bookCode = extractBookCode(href);
      }

      if (bookCode) {
        const exists = availableBooks.has(bookCode);
        updateBookVisibility(item, exists);

        if (exists) {
          visibleCount++;
          console.log(`  ✅ ${bookCode}: Visível`);
        } else {
          hiddenCount++;
          console.log(`  ❌ ${bookCode}: Oculto (não encontrado)`);
        }
      }
    });

    console.log(
      `\n📊 Resultado: ${visibleCount} visíveis, ${hiddenCount} ocultos`
    );

    // Atualizar visibilidade dos títulos de seção e divs semester
    updateSectionTitlesVisibility();
  }

  /**
   * Atualiza a visibilidade dos títulos de seção e divs semester baseado se há livros visíveis
   */
  function updateSectionTitlesVisibility() {
    // Processar divs book semester
    const semesterDivs = document.querySelectorAll(".book.semester");

    semesterDivs.forEach((semesterDiv) => {
      // Encontrar todos os book-items dentro desta div
      const bookItems = semesterDiv.querySelectorAll(".book-item");
      let hasVisibleBooks = false;

      bookItems.forEach((item) => {
        const display = window.getComputedStyle(item).display;
        if (display !== "none") {
          hasVisibleBooks = true;
        }
      });

      // Controlar visibilidade da div semester e seu título
      if (hasVisibleBooks) {
        semesterDiv.style.display = "";
        semesterDiv.classList.remove("semester-hidden");

        // Mostrar o título h2 dentro da div
        const title = semesterDiv.querySelector("h2.book-title");
        if (title) {
          title.style.display = "";
          title.classList.remove("section-hidden");
        }
      } else {
        semesterDiv.style.display = "none";
        semesterDiv.classList.add("semester-hidden");

        // Ocultar o título h2 dentro da div
        const title = semesterDiv.querySelector("h2.book-title");
        if (title) {
          title.style.display = "none";
          title.classList.add("section-hidden");
        }
      }
    });

    // Processar outras divs book que não são semester (como projeto)
    const otherBookDivs = document.querySelectorAll(".book:not(.semester)");

    otherBookDivs.forEach((bookDiv) => {
      const bookItems = bookDiv.querySelectorAll(".book-item");
      let hasVisibleBooks = false;

      bookItems.forEach((item) => {
        const display = window.getComputedStyle(item).display;
        if (display !== "none") {
          hasVisibleBooks = true;
        }
      });

      // Controlar visibilidade da div book e seu título
      if (hasVisibleBooks) {
        bookDiv.style.display = "";
        bookDiv.classList.remove("book-hidden");

        const title = bookDiv.querySelector("h2.book-title");
        if (title) {
          title.style.display = "";
          title.classList.remove("section-hidden");
        }
      } else {
        bookDiv.style.display = "none";
        bookDiv.classList.add("book-hidden");

        const title = bookDiv.querySelector("h2.book-title");
        if (title) {
          title.style.display = "none";
          title.classList.add("section-hidden");
        }
      }
    });
  }

  /**
   * Verifica se um elemento é um título de seção
   * @param {HTMLElement} element
   * @returns {boolean}
   */
  function isSectionTitle(element) {
    if (!element) return false;
    return (
      element.classList.contains("book-title") ||
      element.classList.contains("book-section-title") ||
      element.classList.contains("book-category-title") ||
      element.tagName === "H2" ||
      element.tagName === "H3"
    );
  }

  /**
   * Verifica se um elemento é um item de livro
   * @param {HTMLElement} element
   * @returns {boolean}
   */
  function isBookElement(element) {
    if (!element) return false;
    return (
      element.classList.contains("book-item") ||
      element.hasAttribute("data-book") ||
      element.hasAttribute("data-book-code")
    );
  }

  /**
   * Força a atualização manual de um livro específico
   * @param {string} bookCode - Código do livro
   */
  async function refreshBookStatus(bookCode) {
    await scanBookDirectory();

    const bookSelectors = [
      `a.book-item[href*="/book/${bookCode}"]`,
      `[data-book="${bookCode}"]`,
      `[data-book-code="${bookCode}"]`,
    ];

    const bookItem = document.querySelector(bookSelectors.join(", "));

    if (bookItem) {
      const exists = availableBooks.has(bookCode);
      updateBookVisibility(bookItem, exists);
      updateSectionTitlesVisibility();
      console.log(
        `🔄 ${bookCode} atualizado: ${exists ? "Visível" : "Oculto"}`
      );
      return exists;
    }

    console.warn(`⚠️ Elemento para ${bookCode} não encontrado na página`);
    return false;
  }

  /**
   * Retorna a lista de livros disponíveis
   * @returns {Array<string>}
   */
  function getAvailableBooks() {
    return Array.from(availableBooks).sort();
  }

  /**
   * Adiciona um livro manualmente à lista (útil para testes)
   * @param {string} bookCode
   */
  function addBook(bookCode) {
    availableBooks.add(bookCode);
    refreshBookStatus(bookCode);
  }

  /**
   * Remove um livro manualmente da lista (útil para testes)
   * @param {string} bookCode
   */
  function removeBook(bookCode) {
    availableBooks.delete(bookCode);
    refreshBookStatus(bookCode);
  }

  /**
   * Inicializa o gerenciador quando o DOM estiver pronto
   */
  function init() {
    console.log("📚 Book Visibility Manager iniciado");

    if (document.readyState === "loading") {
      document.addEventListener("DOMContentLoaded", updateAllBooksVisibility);
    } else {
      updateAllBooksVisibility();
    }
  }

  // Expor API pública para uso externo e debug
  window.BookVisibilityManager = {
    // Funções principais
    refresh: updateAllBooksVisibility,
    refreshBook: refreshBookStatus,
    scan: scanBookDirectory,

    // Gerenciamento manual
    addBook: addBook,
    removeBook: removeBook,

    // Consulta
    getAvailableBooks: getAvailableBooks,
    isBookAvailable: (code) => availableBooks.has(code),

    // Utilitários
    updateVisibility: updateBookVisibility,
    extractCode: extractBookCode,
  };

  // Inicializar automaticamente
  init();

  console.log("📚 Book Visibility Manager carregado e pronto!");
})();
