function handleNavbarHover() {
  const navbar = document.getElementById('globalnavbar');
  const navItems = document.querySelectorAll('.globalnavbar-item');

  navItems.forEach(item => {
    // Verifica se o item tem submenu (ignora itens como "Estatística")
    const hasSubmenu = item.querySelector('.globalnavbar-submenu') !== null;

    if (hasSubmenu) {
      const link = item.querySelector('.globalnavbar-link');

      // Adiciona a classe no hover do link principal
      link.addEventListener('mouseenter', () => {
        navbar.classList.add('globalnavbar-hover-active');
      });

      // Remove a classe ao sair do link (se não estiver no submenu)
      link.addEventListener('mouseleave', () => {
        if (!item.querySelector('.globalnavbar-submenu:hover')) {
          navbar.classList.remove('globalnavbar-hover-active');
        }
      });
    }
  });

  // Remove a classe se o mouse sair completamente da navbar
  navbar.addEventListener('mouseleave', () => {
    navbar.classList.remove('globalnavbar-hover-active');
  });
}

// Função para mudar cor globalnav quando submenu:houver
document.addEventListener('DOMContentLoaded', handleNavbarHover);