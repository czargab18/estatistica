document.addEventListener("DOMContentLoaded", function () {
  var columns = document.querySelectorAll(".gf-directory-column");

  columns.forEach(function (column) {
    var button = column.querySelector(
      ".gf-directory-column-section-title-button"
    );
    var list = column.querySelector(".gf-directory-column-section-list");
    var section = column.querySelector(".gf-directory-column-section");

    if (!button || !list || !section) return; // Verifica se todos os elementos existem

    // Função para alternar visibilidade
    function toggleSection() {
      var isExpanded = section.classList.contains("gf-directory-column-expanded");

      if (isExpanded) {
        // Fechar
        section.classList.remove("gf-directory-column-expanded");
        button.setAttribute("aria-expanded", "false");
      } else {
        // Abrir
        section.classList.add("gf-directory-column-expanded");
        button.setAttribute("aria-expanded", "true");
      }
    }

    // Event listener para o botão
    button.addEventListener("click", function (e) {
      e.preventDefault();
      toggleSection();
    });

    // Event listeners para os links (opcional - fecha ao clicar em um link)
    var links = column.querySelectorAll(".gf-directory-column-section-link");
    links.forEach(function (link) {
      link.addEventListener("click", function () {
        // Em telas pequenas, fecha o acordeon após clicar em um link
        if (window.innerWidth <= 833) {
          section.classList.remove("gf-directory-column-expanded");
          button.setAttribute("aria-expanded", "false");
        }
      });
    });

    // Inicializa o estado do aria-expanded
    button.setAttribute("aria-expanded", "false");
  });

  // Listener para mudanças de tamanho da tela
  window.addEventListener("resize", function () {
    // Em telas grandes, garantir que as listas sejam visíveis
    if (window.innerWidth > 833) {
      var sections = document.querySelectorAll(".gf-directory-column-section");
      sections.forEach(function (section) {
        section.classList.remove("gf-directory-column-expanded");
      });
    }
  });
});
