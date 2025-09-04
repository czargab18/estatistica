/**
 * Global Footer JavaScript - Padrão Apple Oficial
 * Baseado no sistema ac-globalfooter da Apple
 */

!function () {
  "use strict";

  // Sistema de Viewports baseado na Apple
  const ViewportEmitter = {
    BREAKPOINTS: [
      { name: "xsmall", mediaQuery: "only screen and (max-width: 480px)" },
      { name: "small", mediaQuery: "only screen and (min-width: 481px) and (max-width: 833px)" },
      { name: "medium", mediaQuery: "only screen and (min-width: 834px) and (max-width: 1023px)" },
      { name: "large", mediaQuery: "only screen and (min-width: 1024px)" }
    ],

    listeners: [],
    currentViewport: null,

      init() {
        this.currentViewport = this.getBreakpoint();
        this.setupListeners();
      },

      getBreakpoint() {
        for (let bp of this.BREAKPOINTS) {
          if (window.matchMedia(bp.mediaQuery).matches) {
            return bp.name;
          }
        }
        return 'large';
      },

      setupListeners() {
        this.BREAKPOINTS.forEach(bp => {
          const mql = window.matchMedia(bp.mediaQuery);
          mql.addListener(e => {
            if (e.matches) {
              const oldViewport = this.currentViewport;
              this.currentViewport = bp.name;
              this.trigger({ viewport: bp.name, oldViewport });
            }
                });
            });
      },

      on(callback) {
        this.listeners.push(callback);
      },

      trigger(data) {
        this.listeners.forEach(callback => callback(data));
      }
    };

  // Sistema de Ícones SVG da Apple
  const FooterIcon = {
    Template: `<svg class="gf-directory-column-section-title-icon-svg" width="11" height="6" viewBox="0 0 11 6">
            <polyline data-footer-icon-shape stroke="currentColor" stroke-linecap="round" 
                stroke-linejoin="round" fill="none" fill-rule="evenodd" 
                points="10.075 0.675 5.5 5.323 0.925 0.675">
                <animate data-footer-animate="expand" attributeName="points"
                    values="10.075 0.675 5.5 5.323 0.925 0.675;
                            10.075 3 5.5 3 0.925 3;
                            10.075 5.325 5.5 0.676 0.925 5.325"
                    dur="320ms" begin="indefinite" fill="freeze"
                    keyTimes="0; 0.5; 1" calcMode="spline"
                    keySplines="0.12, 0, 0.38, 0; 0.2, 1, 0.68, 1"/>
                <animate data-footer-animate="collapse" attributeName="points"
                    values="10.075 5.325 5.5 0.676 0.925 5.325;
                            10.075 3 5.5 3 0.925 3;
                            10.075 0.675 5.5 5.323 0.925 0.675"
                    dur="320ms" begin="indefinite" fill="freeze"
                    keyTimes="0; 0.5; 1" calcMode="spline"
                    keySplines="0.2, 0, 0.68, 0; 0.2, 1, 0.68, 1"/>
            </polyline>
        </svg>`
  };

  // Classe principal do Footer Directory Section
  class FooterDirectorySection {
    constructor(section, button, icon, list) {
      this.section = section;
      this.button = button;
      this.icon = icon;
      this.list = list;
      this.expanded = false;

          this.init();
        }

      init() {
          // Configura o ícone SVG
          this.setupIcon();

          // Event listeners
          this.button.addEventListener('click', this.toggle.bind(this));

          // Inicializa aria attributes
          this.button.setAttribute('aria-expanded', 'false');
          if (this.list.id) {
            this.button.setAttribute('aria-controls', this.list.id);
          }

          // Listener para mudanças de viewport
          ViewportEmitter.on(this.onViewportChange.bind(this));

          // Configuração inicial baseada no viewport
          const currentViewport = ViewportEmitter.getBreakpoint();
          this.onViewportChange({ viewport: currentViewport });
        }

      setupIcon() {
        if (!this.icon) return;

          // Se o ícone estiver vazio, adiciona o SVG da Apple
          if (!this.icon.innerHTML.trim() || this.icon.textContent === '+') {
            this.icon.innerHTML = FooterIcon.Template;

              // Referências para animações
              this.expandAnimation = this.icon.querySelector('[data-footer-animate="expand"]');
              this.collapseAnimation = this.icon.querySelector('[data-footer-animate="collapse"]');
            } else {
              // Fallback para ícone de texto simples
              this.icon.textContent = '+';
            }
        }

      toggle(e) {
        if (e) e.preventDefault();
        this.expanded ? this.collapse() : this.expand();
      }

      expand() {
        if (this.expanded) return;

        this.expanded = true;
          this.section.classList.add('gf-directory-column-expanded');
          this.button.setAttribute('aria-expanded', 'true');

          // Anima o ícone SVG se disponível
          if (this.expandAnimation) {
            this.expandAnimation.beginElement();
          }
        }

      collapse() {
        if (!this.expanded) return;

        this.expanded = false;
          this.section.classList.remove('gf-directory-column-expanded');
          this.button.setAttribute('aria-expanded', 'false');

          // Anima o ícone SVG se disponível
          if (this.collapseAnimation) {
            this.collapseAnimation.beginElement();
          }
        }

      isBreakpointWithMenu(viewport) {
        return viewport === 'xsmall' || viewport === 'small';
      }

      onViewportChange(data) {
        if (this.isBreakpointWithMenu(data.viewport)) {
          // Mobile: Habilita acordeon
          this.button.removeAttribute('disabled');
          this.button.setAttribute('aria-expanded', this.expanded ? 'true' : 'false');

              if (this.list.id) {
                this.button.setAttribute('aria-controls', this.list.id);
              }
            } else {
          // Desktop: Desabilita acordeon
          this.collapse();
          this.button.setAttribute('disabled', '');
          this.button.removeAttribute('aria-expanded');
          this.button.removeAttribute('aria-controls');
        }
      }

      destroy() {
        this.button.removeEventListener('click', this.toggle.bind(this));
      }
  }

  // Classe para Breadcrumbs
  class FooterBreadcrumbs {
    constructor(element) {
      this.element = element;
      this.init();
    }

    init() {
      this.setupStructure();
      this.handleVisibility();
    }

    setupStructure() {
      // Garantir que a estrutura está correta
      const homeLink = this.element.querySelector('.ac-gf-breadcrumbs-home');
      if (homeLink && !homeLink.querySelector('.ac-gf-breadcrumbs-home-icon')) {
        this.createHomeIcon(homeLink);
      }
    }

    createHomeIcon(homeLink) {
      const icon = document.createElement('span');
      icon.className = 'ac-gf-breadcrumbs-home-icon';
      icon.setAttribute('aria-hidden', 'true');

      const label = document.createElement('span');
      label.className = 'ac-gf-breadcrumbs-home-label';
      label.textContent = homeLink.textContent.trim() || 'Página Inicial';

      homeLink.innerHTML = '';
      homeLink.appendChild(icon);
      homeLink.appendChild(label);
    }

    handleVisibility() {
      // Mostrar breadcrumbs apenas se não estivermos na home
      const isHomePage = window.location.pathname === '/' ||
        window.location.pathname === '/index.html' ||
        window.location.pathname.endsWith('/estatistica/');

      if (isHomePage) {
        this.element.style.display = 'none';
      } else {
        this.element.style.display = 'block';
      }
    }

    static createBreadcrumbs(path, title) {
      // Método estático para criar breadcrumbs dinamicamente
      const breadcrumbsHtml = `
        <nav class="ac-gf-breadcrumbs" aria-label="Breadcrumbs" role="navigation">
          <a href="/" class="ac-gf-breadcrumbs-home">
            <span class="ac-gf-breadcrumbs-home-icon" aria-hidden="true"></span>
            <span class="ac-gf-breadcrumbs-home-label">Estatística UnB</span>
          </a>
          <div class="ac-gf-breadcrumbs-path">
            <ol class="ac-gf-breadcrumbs-list" vocab="http://schema.org/" typeof="BreadcrumbList">
              ${path.map((item, index) => {
        if (index === path.length - 1) {
          return `<li class="ac-gf-breadcrumbs-item" property="itemListElement" typeof="ListItem">
                    <span property="name">${item.name}</span>
                    <meta property="position" content="${index + 1}">
                  </li>`;
        } else {
          return `<li class="ac-gf-breadcrumbs-item" property="itemListElement" typeof="ListItem">
                    <a class="ac-gf-breadcrumbs-link" href="${item.url}" property="item" typeof="WebPage">
                      <span property="name">${item.name}</span>
                    </a>
                    <meta property="position" content="${index + 1}">
                  </li>`;
        }
      }).join('')}
            </ol>
          </div>
        </nav>
      `;

      return breadcrumbsHtml;
    }
  }

  // Classe principal do Global Footer
  class GlobalFooter {
    constructor(element) {
      this.el = element;
      this.sections = [];
      this.breadcrumbs = null;
      this.init();
    }

      init() {
        // Adiciona classe JS ao elemento
        this.el.classList.remove('no-js');
        this.el.classList.add('js');

        // Inicializa o sistema de viewport
        ViewportEmitter.init();

        // Inicializar breadcrumbs
        this.initializeBreadcrumbs();

        // Configura as seções do diretório
        this.initializeDirectory();
      }

    initializeBreadcrumbs() {
      const breadcrumbsElement = this.el.querySelector('.ac-gf-breadcrumbs');
      if (breadcrumbsElement) {
        this.breadcrumbs = new FooterBreadcrumbs(breadcrumbsElement);
      }
    }

      initializeDirectory() {
        const sections = this.el.querySelectorAll('.gf-directory-column-section');

        sections.forEach(section => {
          const button = section.querySelector('.gf-directory-column-section-title-button');
          const icon = section.querySelector('.gf-directory-column-section-title-icon');
          const list = section.querySelector('.gf-directory-column-section-list');

          if (button && list) {
            const footerSection = new FooterDirectorySection(section, button, icon, list);
            this.sections.push(footerSection);
          }
        });
      }

      destroy() {
        this.sections.forEach(section => section.destroy());
        this.sections = [];
        this.breadcrumbs = null;
      }
  }

  // Inicialização automática quando o DOM estiver pronto
  function init() {
    const footerElement = document.getElementById('globalfooter') ||
      document.querySelector('[data-module="globalfooter"]') ||
      document.querySelector('.ac-gf') ||
      document.querySelector('#ac-globalfooter');
        
      if (footerElement) {
        new GlobalFooter(footerElement);
      }
    }

  // Aguarda o DOM estar pronto
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', init);
  } else {
    init();
    }

  // Exporta para uso global se necessário
  if (typeof window !== 'undefined') {
    window.GlobalFooter = GlobalFooter;
  }

}();
