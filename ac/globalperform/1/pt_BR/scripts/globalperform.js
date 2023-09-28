// ** Obtém todos os links com a classe "link-clicavel"
var links = document.querySelectorAll(".link-clicavel");

// Itera sobre os links e adiciona um ouvinte de evento de clique
links.forEach(function (link) {
  link.addEventListener("click", function (event) {
    // Verifica se o link é um link interno (começa com #) ou externo (começa com http ou https)
    if (
      link.getAttribute("href").startsWith("#") ||
      link.getAttribute("href").startsWith("http")
    ) {
      // Impede o comportamento padrão de navegação
      event.preventDefault();
    }
  });
});
