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