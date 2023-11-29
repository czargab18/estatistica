document.addEventListener("DOMContentLoaded", function () {
  // Selecione todos os elementos com a classe 'no-url-change'
  var linksSemAlterarURL = document.querySelectorAll(".no-url-change");

  // Adicione um ouvinte de evento de clique a cada um deles
  linksSemAlterarURL.forEach(function (link) {
    link.addEventListener("click", function (event) {
      // Impedir o comportamento padrão de navegação
      event.preventDefault();

      // Você pode adicionar qualquer lógica adicional aqui
      // Por exemplo, rolar para a seção desejada
      var targetId = link.getAttribute("href").substring(1);
      var targetElement = document.getElementById(targetId);
      if (targetElement) {
        targetElement.scrollIntoView({ behavior: "smooth" });
      }
    });
  });
});
