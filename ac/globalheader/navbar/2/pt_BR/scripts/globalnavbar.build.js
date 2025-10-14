!(function () {
  "use strict";
  function init() {
    const navbar = document.getElementById("globalnavbar");
    const curtain = document.getElementById("globalnavbar-curtain");
    const menuButton = document.getElementById(
      "globalnavbar-menutrigger-button"
    );
    const topLineOpenAnim = document.getElementById(
      "globalnavbar-anim-menutrigger-bread-top-open"
    );
    const topLineCloseAnim = document.getElementById(
      "globalnavbar-anim-menutrigger-bread-top-close"
    );
    const bottomLineOpenAnim = document.getElementById(
      "globalnavbar-anim-menutrigger-bread-bottom-open"
    );
    const bottomLineCloseAnim = document.getElementById(
      "globalnavbar-anim-menutrigger-bread-bottom-close"
    );
    const items = Array.from(
      navbar ? navbar.querySelectorAll(".globalnavbar-item") : []
    );
    let isMenuOpen = false;
    let currentOpenItem = null; // Adicione esta variável

    function resetsubmenu() {
      navbar.classList.remove(
        "globalnavbar-with-flyout-open",
        "globalnavbar-with-submenu-open"
      );
      navbar
        .querySelectorAll(".globalnavbar-submenu-opened")
        .forEach((el) => el.classList.remove("globalnavbar-submenu-opened"));
      navbar
        .querySelectorAll('.globalnavbar-item-link[aria-expanded="true"]')
        .forEach((a) => a.setAttribute("aria-expanded", "false"));
      currentOpenItem = null; // Reset da variável
    }

    items.forEach((item) => {
      const submenu = item.querySelector(".globalnavbar-submenu");
      const trigger = item.querySelector(".globalnavbar-item-link");
      if (!submenu || !trigger) return;

      const showflyout = () => {
        // Remove classes do item anterior se houver
        if (currentOpenItem && currentOpenItem !== item) {
          currentOpenItem.classList.remove("globalnavbar-item-hover");
        }
        
        currentOpenItem = item;
        item.classList.add("globalnavbar-item-hover");
        navbar.classList.add(
          "globalnavbar-with-flyout-open",
          "globalnavbar-with-submenu-open"
        );
      };
      
      const hideflyout = () => {
        // Remove imediatamente quando sair do item
        item.classList.remove("globalnavbar-item-hover");
        
        // Verifica se ainda há algum item com hover
        setTimeout(() => {
          const hasHoveredItem = navbar.querySelector(".globalnavbar-item-hover");
          if (!hasHoveredItem) {
            navbar.classList.remove(
              "globalnavbar-with-flyout-open",
              "globalnavbar-with-submenu-open"
            );
            currentOpenItem = null;
          }
        }, 50);
      };

      item.addEventListener("mouseenter", showflyout);
      item.addEventListener("mouseleave", hideflyout);
      item.addEventListener("focusin", showflyout);
      item.addEventListener("focusout", hideflyout);

      trigger.setAttribute("aria-haspopup", "true");
      trigger.setAttribute("aria-expanded", "false");

      trigger.addEventListener("click", (e) => {
        if (!window.matchMedia("(max-width: 979px)").matches) return;
        e.preventDefault();
        const opened = item.classList.toggle("globalnavbar-submenu-opened");
        trigger.setAttribute("aria-expanded", opened ? "true" : "false");
        if (opened)
          navbar.classList.add(
            "globalnavbar-with-flyout-open",
            "globalnavbar-with-submenu-open"
          );
        else if (!navbar.querySelector(".globalnavbar-submenu-opened"))
          navbar.classList.remove(
            "globalnavbar-with-flyout-open",
            "globalnavbar-with-submenu-open"
          );
      });
    });

    if (curtain) {
      curtain.addEventListener("click", resetsubmenu);
    }

    if (menuButton) {
      menuButton.addEventListener("click", function () {
        if (!isMenuOpen) {
          openmenu();
        } else {
          closemenu();
        }
        isMenuOpen = !isMenuOpen;
      });
    }

    function openmenu() {
      if (topLineOpenAnim) topLineOpenAnim.beginElement();
      if (bottomLineOpenAnim) bottomLineOpenAnim.beginElement();
      navbar.classList.add("globalnavbar-with-menu-open");
      if (curtain) curtain.classList.add("globalnavbar-curtain-visible");
      if (menuButton) {
        menuButton.setAttribute("aria-expanded", "true");
        menuButton.setAttribute("aria-label", "Fechar menu principal");
      }
    }

    function closemenu() {
      if (topLineCloseAnim) topLineCloseAnim.beginElement();
      if (bottomLineCloseAnim) bottomLineCloseAnim.beginElement();
      navbar.classList.remove("globalnavbar-with-menu-open");
      if (curtain) curtain.classList.remove("globalnavbar-curtain-visible");
      if (menuButton) {
        menuButton.setAttribute("aria-expanded", "false");
        menuButton.setAttribute("aria-label", "Abrir menu principal");
      }
    }

    if (curtain) {
      curtain.addEventListener("click", function () {
        if (isMenuOpen) {
          closemenu();
          isMenuOpen = false;
        }
        resetsubmenu(); // Adicione esta linha
      });
    }

    document.addEventListener("keydown", function (event) {
      if (event.key === "Escape") {
        if (isMenuOpen) {
          closemenu();
          isMenuOpen = false;
        }
        resetsubmenu(); // Adicione esta linha
      }
    });

    function resize() {
      if (window.innerWidth >= 834) {
        if (
          navbar &&
          navbar.classList.contains("globalnavbar-with-menu-open")
        ) {
          navbar.classList.remove("globalnavbar-with-menu-open");
          if (curtain) {
            curtain.classList.remove("globalnavbar-curtain-visible");
          }
          if (menuButton) {
            menuButton.setAttribute("aria-expanded", "false");
            menuButton.setAttribute("aria-label", "Abrir menu principal");
          }
          isMenuOpen = false;
        }
      }
    }

    window.addEventListener("resize", resize);
    resize();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", init);
  } else {
    init();
  }
})();
