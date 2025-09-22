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