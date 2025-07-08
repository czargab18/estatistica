// Função para gerenciar hover dos submenus com compatibilidade dual (globalnav/globalnavbar)
function handleNavbarHover() {
  // Suporte para ambos os IDs: globalnavbar e globalnav
  const navbar = document.getElementById('globalnavbar') || document.getElementById('globalnav');
  if (!navbar) return;

  // Detectar se é globalnav ou globalnavbar baseado no ID
  const isGlobalNav = navbar.id === 'globalnav';
  const prefix = isGlobalNav ? 'globalnav' : 'globalnavbar';

  // Seletores dinâmicos baseados no prefixo
  const navItems = document.querySelectorAll(`.${prefix}-item`);
  const submenuClass = `.${prefix}-submenu`;
  const linkClass = `.${prefix}-link`;
  const hoverActiveClass = `${prefix}-hover-active`;

  console.log(`Inicializando hover para ${navItems.length} itens no navbar ${navbar.id}`);

  navItems.forEach((item, index) => {
    const hasSubmenu = item.querySelector(submenuClass) !== null;
    console.log(`Item ${index}: hasSubmenu = ${hasSubmenu}`);

    if (hasSubmenu) {
      const link = item.querySelector(linkClass);
      const submenu = item.querySelector(submenuClass);

      if (link && submenu) {
        // Mouse enter no link - ativa o hover
        link.addEventListener('mouseenter', () => {
          console.log(`Ativando hover para item ${index}`);
          navbar.classList.add(hoverActiveClass);
        });

        // Mouse leave no link - só remove hover se não estiver sobre o submenu
        link.addEventListener('mouseleave', (e) => {
          // Aguarda um frame para verificar se o mouse está sobre o submenu
          setTimeout(() => {
            const isOverSubmenu = submenu.matches(':hover');
            if (!isOverSubmenu) {
              console.log(`Removendo hover para item ${index} (mouse não está no submenu)`);
              navbar.classList.remove(hoverActiveClass);
            }
          }, 10);
        });

        // Mouse leave no submenu - remove hover
        submenu.addEventListener('mouseleave', () => {
          console.log(`Mouse saiu do submenu do item ${index}`);
          navbar.classList.remove(hoverActiveClass);
        });

        // Mouse enter no submenu - mantém hover ativo
        submenu.addEventListener('mouseenter', () => {
          console.log(`Mouse entrou no submenu do item ${index}`);
          navbar.classList.add(hoverActiveClass);
        });
      }
    }
  });

  // Mouse leave do navbar inteiro - sempre remove hover
  navbar.addEventListener('mouseleave', () => {
    console.log('Mouse saiu do navbar - removendo hover');
    navbar.classList.remove(hoverActiveClass);
  });
}

// Função auxiliar para debug
function debugNavbarState() {
  const navbar = document.getElementById('globalnavbar') || document.getElementById('globalnav');
  if (navbar) {
    console.log('Navbar classes:', navbar.classList.toString());
    console.log('Navbar hover active:', navbar.classList.contains('globalnavbar-hover-active') || navbar.classList.contains('globalnav-hover-active'));
  }
}

// Inicializar quando o DOM estiver pronto
document.addEventListener('DOMContentLoaded', () => {
  console.log('DOM carregado - inicializando navbar hover');
  handleNavbarHover();

  // Debug opcional - remover em produção
  // setInterval(debugNavbarState, 2000);
});