// Função única para inicializar o globalnavbar
function initGlobalNavbar() {
  // Captura dos elementos principais
  const globalheader = document.getElementById("globalheader");
  const navbar = document.getElementById("globalnavbar");
  const curtain = document.getElementById("globalnavbar-curtain");
  const menuButton = document.getElementById("globalnavbar-menutrigger-button");
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

  // Variável de estado do menu
  let isMenuOpen = false;

  // Função para fechar todos os submenus
  function closeAll() {
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
  }

  // Função para mostrar/ocultar submenu
  items.forEach((item) => {
    const submenu = item.querySelector(".globalnavbar-submenu");
    const trigger = item.querySelector(".globalnavbar-item-link");
    if (!submenu || !trigger) return;

    const show = () =>
      navbar.classList.add(
        "globalnavbar-with-flyout-open",
        "globalnavbar-with-submenu-open"
      );
    const hide = () => {
      setTimeout(() => {
        if (
          !navbar.contains(document.activeElement) &&
          !navbar.querySelector(":hover")
        ) {
          navbar.classList.remove(
            "globalnavbar-with-flyout-open",
            "globalnavbar-with-submenu-open"
          );
        }
      }, 40);
    };

    item.addEventListener("mouseenter", show);
    item.addEventListener("mouseleave", hide);
    item.addEventListener("focusin", show);
    item.addEventListener("focusout", hide);

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
    curtain.addEventListener("click", closeAll);
  }

  // Menu mobile
  if (menuButton) {
    menuButton.addEventListener("click", function () {
      if (!isMenuOpen) {
        openMenu();
      } else {
        closeMenu();
      }
      isMenuOpen = !isMenuOpen;
    });
  }

  function openMenu() {
    if (topLineOpenAnim) topLineOpenAnim.beginElement();
    if (bottomLineOpenAnim) bottomLineOpenAnim.beginElement();
    navbar.classList.add("globalnavbar-with-menu-open");
    if (curtain) curtain.classList.add("globalnavbar-curtain-visible");
    if (menuButton) {
      menuButton.setAttribute("aria-expanded", "true");
      menuButton.setAttribute("aria-label", "Fechar menu principal");
    }
  }

  function closeMenu() {
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
        closeMenu();
        isMenuOpen = false;
      }
    });
  }

  document.addEventListener("keydown", function (event) {
    if (event.key === "Escape" && isMenuOpen) {
      closeMenu();
      isMenuOpen = false;
    }
  });

  // Função para monitorar mudanças de tela
  function handleResize() {
    if (window.innerWidth >= 834) {
      if (navbar && navbar.classList.contains("globalnavbar-with-menu-open")) {
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

  window.addEventListener("resize", handleResize);
  handleResize();
}

document.addEventListener("DOMContentLoaded", initGlobalNavbar);
