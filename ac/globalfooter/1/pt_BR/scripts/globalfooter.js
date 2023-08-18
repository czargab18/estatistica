document.addEventListener("DOMContentLoaded", function () {
  var columns = document.querySelectorAll(".gf-directory-column");

  columns.forEach(function (column) {
    var button = column.querySelector(
      ".gf-directory-column-section-title-button"
    );
    var list = column.querySelector(".gf-directory-column-section-list");

    button.addEventListener("click", function () {
      if (list.style.display === "none" || list.style.display === "") {
        list.style.display = "block";
        button.setAttribute("aria-expanded", "true");
      } else {
        list.style.display = "none";
        button.setAttribute("aria-expanded", "false");
      }
    });

    var links = column.querySelectorAll(".gf-directory-column-section-link");
    links.forEach(function (link) {
      link.addEventListener("click", function () {
        list.style.display = "none";
        button.setAttribute("aria-expanded", "false");
      });
    });
  });
});
