// Função para mudar cor globalnav quando submenu:houver 
function handleNavbarHover() {
  const navbar = document.getElementById('globalnavbar');
  const navItems = document.querySelectorAll('.globalnavbar-item');

  navItems.forEach(item => {
    const hasSubmenu = item.querySelector('.globalnavbar-submenu') !== null;
    if (hasSubmenu) {
      const link = item.querySelector('.globalnavbar-item-link');
      link.addEventListener('mouseenter', () => {
        navbar.classList.add('globalnavbar-hover-active');
      });
      link.addEventListener('mouseleave', () => {
        if (!item.querySelector('.globalnavbar-submenu:hover')) {
          navbar.classList.remove('globalnavbar-hover-active');
        }
      });
    }
  });
  navbar.addEventListener('mouseleave', () => {
    navbar.classList.remove('globalnavbar-hover-active');
  });
}

document.addEventListener('DOMContentLoaded', handleNavbarHover);

document.addEventListener('DOMContentLoaded', () => {
  const navbar = document.getElementById('globalnavbar');
  if (!navbar) return;

  const curtain = document.getElementById('globalnavbar-curtain');
  const items = Array.from(navbar.querySelectorAll('.globalnavbar-item'));
  const isMobile = () => window.matchMedia('(max-width: 979px)').matches;

  const closeAll = () => {
    navbar.classList.remove('globalnavbar-hover-active');
    navbar.querySelectorAll('.globalnavbar-submenu-open').forEach(el => el.classList.remove('globalnavbar-submenu-open'));
    navbar.querySelectorAll('.globalnavbar-item-link[aria-expanded="true"]').forEach(a => a.setAttribute('aria-expanded', 'false'));
  };

  items.forEach(item => {
    const submenu = item.querySelector('.globalnavbar-submenu');
    const trigger = item.querySelector('.globalnavbar-item-link');
    if (!submenu || !trigger) return;

    const show = () => navbar.classList.add('globalnavbar-hover-active');
    const hide = () => {
      setTimeout(() => {
        if (!navbar.contains(document.activeElement) && !navbar.querySelector(':hover')) {
          navbar.classList.remove('globalnavbar-hover-active');
        }
      }, 40);
    };

    item.addEventListener('mouseenter', show);
    item.addEventListener('mouseleave', hide);
    item.addEventListener('focusin', show);
    item.addEventListener('focusout', hide);

    trigger.setAttribute('aria-haspopup', 'true');
    trigger.setAttribute('aria-expanded', 'false');

    trigger.addEventListener('click', (e) => {
      if (!isMobile()) return;
      e.preventDefault();
      const opened = item.classList.toggle('globalnavbar-submenu-open');
      trigger.setAttribute('aria-expanded', opened ? 'true' : 'false');
      if (opened) navbar.classList.add('globalnavbar-hover-active');
      else if (!navbar.querySelector('.globalnavbar-submenu-open')) navbar.classList.remove('globalnavbar-hover-active');
    });
  });

  if (curtain) {
    curtain.addEventListener('click', closeAll);
  }

  navbar.addEventListener('mouseleave', () => navbar.classList.remove('globalnavbar-hover-active'));
});

document.addEventListener('DOMContentLoaded', function () {
  const menuButton = document.getElementById('globalnavbar-menutrigger-button');
  const navbar = document.getElementById('globalnavbar');
  const curtain = document.getElementById('globalnavbar-curtain');

  // Elementos das animações
  const topLineOpenAnim = document.getElementById('globalnavbar-anim-menutrigger-bread-top-open');
  const topLineCloseAnim = document.getElementById('globalnavbar-anim-menutrigger-bread-top-close');
  const bottomLineOpenAnim = document.getElementById('globalnavbar-anim-menutrigger-bread-bottom-open');
  const bottomLineCloseAnim = document.getElementById('globalnavbar-anim-menutrigger-bread-bottom-close');

  let isMenuOpen = false;

  menuButton.addEventListener('click', function () {
    if (!isMenuOpen) {
      // Abrir menu - transformar em X
      openMenu();
    } else {
      // Fechar menu - voltar ao hambúrguer
      closeMenu();
    }

    isMenuOpen = !isMenuOpen;
  });

  function openMenu() {
    // Iniciar animações de abertura
    topLineOpenAnim.beginElement();
    bottomLineOpenAnim.beginElement();

    // Adicionar classes para o menu aberto
    navbar.classList.add('globalnavbar-open');
    curtain.classList.add('globalnavbar-curtain-visible');
    menuButton.setAttribute('aria-expanded', 'true');
    menuButton.setAttribute('aria-label', 'Fechar menu principal');
  }

  function closeMenu() {
    // Iniciar animações de fechamento
    topLineCloseAnim.beginElement();
    bottomLineCloseAnim.beginElement();

    // Remover classes do menu aberto
    navbar.classList.remove('globalnavbar-open');
    curtain.classList.remove('globalnavbar-curtain-visible');
    menuButton.setAttribute('aria-expanded', 'false');
    menuButton.setAttribute('aria-label', 'Abrir menu principal');
  }

  // Fechar menu ao clicar na cortina
  curtain.addEventListener('click', function () {
    if (isMenuOpen) {
      closeMenu();
      isMenuOpen = false;
    }
  });

  // Fechar menu com a tecla ESC
  document.addEventListener('keydown', function (event) {
    if (event.key === 'Escape' && isMenuOpen) {
      closeMenu();
      isMenuOpen = false;
    }
  });
});