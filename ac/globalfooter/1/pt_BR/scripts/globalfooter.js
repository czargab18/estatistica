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

  // Sistema automático de breadcrumbs
  class AutoBreadcrumbs {
    constructor() {
      this.init();
    }

    init() {
      this.createBreadcrumbsHTML();
      this.setupBreadcrumbs();
    }

    createBreadcrumbsHTML() {
      // Verifica se o breadcrumbs já existe
      if (document.querySelector('.ac-gf-breadcrumbs')) {
        return;
      }

      // Encontra onde inserir (antes da navegação do footer)
      const footerNav = document.querySelector('#globalfooter-navgation') ||
        document.querySelector('.ac-gf-directory');

      if (!footerNav) return;

      // Cria o HTML dos breadcrumbs
      const breadcrumbsHTML = `
        <nav class="ac-gf-breadcrumbs" aria-label="Breadcrumbs" role="navigation" style="display: none;">
          <a href="/" class="ac-gf-breadcrumbs-home">
            <span class="ac-gf-breadcrumbs-home-icon" aria-hidden="true"></span>
            <span class="ac-gf-breadcrumbs-home-label">Estatística UnB</span>
          </a>
          <div class="ac-gf-breadcrumbs-path">
            <ol class="ac-gf-breadcrumbs-list" vocab="http://schema.org/" typeof="BreadcrumbList" id="auto-breadcrumbs">
            </ol>
          </div>
        </nav>
      `;

      // Insere antes da navegação
      footerNav.insertAdjacentHTML('beforebegin', breadcrumbsHTML);
    }

    setupBreadcrumbs() {
      const path = window.location.pathname;
      const breadcrumbsNav = document.querySelector('.ac-gf-breadcrumbs');
      const container = document.getElementById('auto-breadcrumbs');

      if (!breadcrumbsNav || !container) return;

      // Se for home ou páginas especiais, ocultar breadcrumbs
      if (path === '/' ||
        path === '/index.html' ||
        path.endsWith('/estatistica/') ||
        path === '/boasvindas/' ||
        path === '/boasvindas/index.html' ||
        path.endsWith('/footer.html')) {
        breadcrumbsNav.style.display = 'none';
        return;
      }

      // Filtrar arquivos desnecessários e criar breadcrumbs baseado na URL
      const pathSegments = path.split('/').filter(segment =>
        segment &&
        segment !== 'index.html' &&
        segment !== 'footer.html' &&
        !segment.endsWith('.html')
      );

      const breadcrumbItems = [];

      // Se não tiver segmentos válidos, ocultar breadcrumbs
      if (pathSegments.length === 0) {
        breadcrumbsNav.style.display = 'none';
        return;
      }

      pathSegments.forEach((segment, index) => {
        const url = '/' + pathSegments.slice(0, index + 1).join('/') + '/';
        const name = segment.charAt(0).toUpperCase() + segment.slice(1);

        if (index === pathSegments.length - 1) {
          breadcrumbItems.push({ name }); // Último item sem URL
        } else {
          breadcrumbItems.push({ name, url });
        }
      });

      // Preencher container apenas se tiver itens
      container.innerHTML = '';
      if (breadcrumbItems.length > 0) {
        breadcrumbItems.forEach((item, index) => {
          const li = document.createElement('li');
          li.className = 'ac-gf-breadcrumbs-item';
          li.setAttribute('property', 'itemListElement');
          li.setAttribute('typeof', 'ListItem');

          if (item.url) {
            li.innerHTML = `
              <a class="ac-gf-breadcrumbs-link" href="${item.url}" property="item" typeof="WebPage">
                <span property="name">${item.name}</span>
              </a>
              <meta property="position" content="${index + 1}">
            `;
          } else {
            li.innerHTML = `
              <span property="name">${item.name}</span>
              <meta property="position" content="${index + 1}">
            `;
          }

          container.appendChild(li);
        });

        // Mostrar breadcrumbs
        breadcrumbsNav.style.display = 'block';
      } else {
        // Ocultar se não tiver itens
        breadcrumbsNav.style.display = 'none';
      }
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
        // Inicializar breadcrumbs automáticos
        new AutoBreadcrumbs();
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
