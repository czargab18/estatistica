  document.addEventListener('DOMContentLoaded', function() {
    const navbar = document.getElementById('globalnavbar');
  const navItems = document.querySelectorAll('.globalnavbar-item'); // Todos os itens da nav

    navItems.forEach(item => {
      // Verifica se o item tem um submenu (caso contrário, ignora)
      const hasSubmenu = item.querySelector('.globalnavbar-submenu') !== null;

  if (hasSubmenu) {
        const link = item.querySelector('.globalnavbar-link'); // Link principal do item

        link.addEventListener('mouseenter', () => {
    navbar.style.backgroundColor = '#f5f5f7'; // Cor quando hover no link com submenu
        });

        link.addEventListener('mouseleave', () => {
          // Só volta ao normal se o mouse não estiver no submenu
          if (!item.querySelector('.globalnavbar-submenu:hover')) {
    navbar.style.backgroundColor = 'transparent';
          }
        });
      }
    });

    // Reseta a cor se o mouse sair completamente da navbar
    navbar.addEventListener('mouseleave', () => {
    navbar.style.backgroundColor = 'transparent';
    });
  });

// Dentro do if (hasSubmenu)...
link.addEventListener('mouseenter', () => {
  navbar.classList.add('nav-hover-active');
});

link.addEventListener('mouseleave', () => {
  if (!item.querySelector('.globalnavbar-submenu:hover')) {
    navbar.classList.remove('nav-hover-active');
  }
});