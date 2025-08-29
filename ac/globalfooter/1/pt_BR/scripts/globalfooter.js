/**
 * Global Footer JavaScript - Baseado no padrão Apple
 * Sistema completo de navegação responsiva com animações suaves
 */

document.addEventListener("DOMContentLoaded", function () {
  // Sistema de breakpoints (baseado na Apple)
  const BREAKPOINTS = {
    XSMALL: 480,
    SMALL: 833,
    MEDIUM: 1023,
    LARGE: 1024
  };

  // Classe principal do Footer
  class GlobalFooter {
    constructor() {
      this.sections = [];
      this.currentBreakpoint = this.getCurrentBreakpoint();
      this.init();
    }

    init() {
      this.setupSections();
      this.setupEventListeners();
      this.updateForBreakpoint();
    }

    setupSections() {
      const columns = document.querySelectorAll(".gf-directory-column");
      
      columns.forEach((column) => {
        const section = new FooterSection(column, this);
        this.sections.push(section);
      });
    }

    setupEventListeners() {
      // Listener para mudanças de viewport
      let resizeTimer;
      window.addEventListener("resize", () => {
        clearTimeout(resizeTimer);
        resizeTimer = setTimeout(() => {
          const newBreakpoint = this.getCurrentBreakpoint();
          if (newBreakpoint !== this.currentBreakpoint) {
            this.currentBreakpoint = newBreakpoint;
            this.updateForBreakpoint();
          }
        }, 100);
      });
    }

    getCurrentBreakpoint() {
      const width = window.innerWidth;
      if (width <= BREAKPOINTS.XSMALL) return 'xsmall';
      if (width <= BREAKPOINTS.SMALL) return 'small';
      if (width <= BREAKPOINTS.MEDIUM) return 'medium';
      return 'large';
    }

    updateForBreakpoint() {
      const isSmallScreen = this.currentBreakpoint === 'xsmall' || this.currentBreakpoint === 'small';
      
      this.sections.forEach(section => {
        section.updateForBreakpoint(isSmallScreen);
      });
    }
  }

  // Classe para cada seção do footer
  class FooterSection {
    constructor(column, footer) {
      this.column = column;
      this.footer = footer;
      this.section = column.querySelector(".gf-directory-column-section");
      this.button = column.querySelector(".gf-directory-column-section-title-button");
      this.list = column.querySelector(".gf-directory-column-section-list");
      this.icon = column.querySelector(".gf-directory-column-section-title-icon");
      this.expanded = false;

      if (!this.button || !this.list || !this.section) return;

      this.init();
    }

    init() {
      this.setupEventListeners();
      this.button.setAttribute("aria-expanded", "false");
      
      // Remove o texto '+' e usa CSS para o ícone
      if (this.icon) {
        this.icon.textContent = '';
      }
    }

    setupEventListeners() {
      this.button.addEventListener("click", (e) => {
        e.preventDefault();
        this.toggle();
      });

      // Fecha ao clicar em links (apenas em mobile)
      const links = this.column.querySelectorAll(".gf-directory-column-section-link");
      links.forEach((link) => {
        link.addEventListener("click", () => {
          if (this.footer.currentBreakpoint === 'xsmall' || this.footer.currentBreakpoint === 'small') {
            this.collapse();
          }
        });
      });
    }

    toggle() {
      this.expanded ? this.collapse() : this.expand();
    }

    expand() {
      if (this.expanded) return;
      
      this.expanded = true;
      this.section.classList.add("gf-directory-column-expanded");
      this.button.setAttribute("aria-expanded", "true");
      
      // Animação suave da lista
      this.animateList(true);
    }

    collapse() {
      if (!this.expanded) return;
      
      this.expanded = false;
      this.section.classList.remove("gf-directory-column-expanded");
      this.button.setAttribute("aria-expanded", "false");
      
      // Animação suave da lista
      this.animateList(false);
    }

    animateList(expanding) {
      if (!this.list) return;
      
      const isSmallScreen = this.footer.currentBreakpoint === 'xsmall' || this.footer.currentBreakpoint === 'small';
      if (!isSmallScreen) return;

      if (expanding) {
        // Expandindo - mostra com animação
        this.list.style.display = 'block';
        this.list.style.opacity = '0';
        this.list.style.transform = 'translateY(-10px)';
        
        requestAnimationFrame(() => {
          this.list.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
          this.list.style.opacity = '1';
          this.list.style.transform = 'translateY(0)';
        });
      } else {
        // Colapsando - esconde com animação
        this.list.style.transition = 'opacity 0.3s ease, transform 0.3s ease';
        this.list.style.opacity = '0';
        this.list.style.transform = 'translateY(-10px)';
        
        setTimeout(() => {
          if (!this.expanded) { // Verifica se ainda está colapsado
            this.list.style.display = 'none';
          }
        }, 300);
      }
    }

    updateForBreakpoint(isSmallScreen) {
      if (isSmallScreen) {
        // Mobile: habilita acordeon
        this.button.removeAttribute("disabled");
        this.button.setAttribute("aria-expanded", this.expanded ? "true" : "false");
        
        if (this.list.id) {
          this.button.setAttribute("aria-controls", this.list.id);
        }
      } else {
        // Desktop: desabilita acordeon, mostra tudo
        this.collapse();
        this.button.setAttribute("disabled", "");
        this.button.removeAttribute("aria-expanded");
        this.button.removeAttribute("aria-controls");
        
        // Reset estilos da lista
        this.list.style.display = '';
        this.list.style.opacity = '';
        this.list.style.transform = '';
        this.list.style.transition = '';
      }
    }
  }

  // Inicializa o footer
  new GlobalFooter();
});
