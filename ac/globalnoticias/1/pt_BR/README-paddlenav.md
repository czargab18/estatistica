# Paddlenav - Sistema de Navegação para Galeria

## Visão Geral

Sistema de navegação inspirado no Apple TV+ que permite navegar entre slides de uma galeria usando botões estilizados, teclado ou gestos touch.

## Arquivos

### CSS
- **`globalnoticias.css`** - CSS base da galeria e paddlenav
- **`paddlenav-icons.css`** - Ícones SVG das setas de navegação

### JavaScript
- **`paddlenav.js`** - Lógica de navegação e interações

### HTML
- **`paddlenav-demo.html`** - Exemplo completo de implementação

## Como Implementar

### 1. Estrutura HTML

```html
<section data-module-template="noticias">
  <div class="module-content">
    <div class="gallery" id="noticias">
      
      <!-- Container dos slides -->
      <div class="item-container">
        <div class="gallery-item theme-dark" id="tv-plus-gallery-item-1">
          <!-- Conteúdo do slide 1 -->
        </div>
        <div class="gallery-item theme-dark" id="tv-plus-gallery-item-2">
          <!-- Conteúdo do slide 2 -->
        </div>
        <!-- Mais slides... -->
      </div>
      
      <!-- Botões de navegação paddlenav -->
      <div class="paddlenav paddlenav-framed">
        <ul>
          <li class="previous">
            <button class="paddlenav-arrow paddlenav-arrow-previous" type="button" aria-label="Slide anterior">
              <span class="sr-only">Anterior</span>
            </button>
          </li>
          <li class="next">
            <button class="paddlenav-arrow paddlenav-arrow-next" type="button" aria-label="Próximo slide">
              <span class="sr-only">Próximo</span>
            </button>
          </li>
        </ul>
      </div>
      
    </div>
  </div>
</section>
```

### 2. Incluir CSS

```html
<link rel="stylesheet" href="styles/globalnoticias.css">
<link rel="stylesheet" href="styles/paddlenav-icons.css">
```

### 3. Incluir JavaScript

```html
<script src="js/paddlenav.js"></script>
```

## Funcionalidades

### Navegação por Clique
- Botão **Anterior**: Navega para o slide anterior
- Botão **Próximo**: Navega para o próximo slide
- Botões são desabilitados automaticamente nos extremos

### Navegação por Teclado
- **←** (Seta Esquerda): Slide anterior
- **→** (Seta Direita): Próximo slide  
- **Home**: Primeiro slide
- **End**: Último slide

### Navegação Touch
- **Swipe Left**: Próximo slide
- **Swipe Right**: Slide anterior
- Suporte a threshold para evitar ativações acidentais

### Responsividade
Breakpoints automáticos:
- **≥1441px**: Container 1265px (xlarge)
- **1069-1440px**: Container 995px (desktop)
- **735-1068px**: Container 704px (medium)  
- **≤734px**: Container 289px (small)

## API JavaScript

### Métodos Públicos

```javascript
const paddleNav = new PaddleNavigation('#gallery-selector');

// Navegação
paddleNav.next();           // Próximo slide
paddleNav.previous();       // Slide anterior
paddleNav.goToSlide(2);     // Ir para slide específico (índice 2)

// Informações
paddleNav.getCurrentIndex(); // Índice atual (0-based)
paddleNav.getTotalItems();   // Total de slides

// Utilidades
paddleNav.handleResize();    // Recalcular após redimensionamento
```

### Inicialização Automática

O sistema inicializa automaticamente quando o DOM está pronto:

```javascript
// Busca por todas as galerias e inicializa paddlenav
document.addEventListener('DOMContentLoaded', initializePaddleNav);
```

## Estilos Visuais

### Variações de Estilo

**Paddlenav Padrão** (transparente):
```html
<div class="paddlenav">
```

**Paddlenav com Fundo** (recomendado):
```html
<div class="paddlenav paddlenav-framed">
```

### Customização CSS

Principais variáveis CSS para customização:

```css
/* Tamanhos dos botões */
.paddlenav-arrow {
  width: 5.29412rem;
  height: 5.29412rem;
  font-size: 53px;
}

/* Cores - Versão framed */
.paddlenav-framed .paddlenav-arrow {
  background-color: rgba(210, 210, 215, 0.64);
  color: rgba(0, 0, 0, 0.56);
}

/* Posicionamento */
.paddlenav-arrow-next { right: 18px; }
.paddlenav-arrow-previous { left: 18px; }
```

## Acessibilidade

### Recursos Inclusos
- **ARIA Labels**: Botões com labels descritivos
- **Navegação por Teclado**: Suporte completo
- **Focus Management**: Estados de foco visíveis
- **Screen Reader**: Textos alternativos inclusos

### Exemplo ARIA
```html
<button class="paddlenav-arrow paddlenav-arrow-next" 
        type="button" 
        aria-label="Próximo slide">
  <span class="sr-only">Próximo</span>
</button>
```

## Compatibilidade

### Navegadores Suportados
- Chrome 60+
- Firefox 55+  
- Safari 11+
- Edge 79+

### Dispositivos
- Desktop (mouse + teclado)
- Tablet (touch)
- Mobile (touch + gestos)

## Exemplos de Uso

### Inicialização Manual
```javascript
// Aguardar DOM ready
document.addEventListener('DOMContentLoaded', function() {
  const paddleNav = new PaddleNavigation('#minha-galeria');
  
  if (paddleNav.isValid()) {
    console.log('Paddlenav inicializado com sucesso');
  }
});
```

### Eventos Personalizados
```javascript
// Monitorar mudanças de slide
const nextBtn = document.querySelector('.paddlenav-arrow-next');
nextBtn.addEventListener('click', function() {
  console.log('Próximo slide clicado');
  // Lógica customizada aqui
});
```

### Integração com Analytics
```javascript
function trackSlideChange(slideIndex) {
  // Exemplo Google Analytics
  gtag('event', 'slide_change', {
    'slide_index': slideIndex,
    'gallery_id': 'noticias'
  });
}
```

## Troubleshooting

### Problemas Comuns

**Botões não aparecem:**
- Verificar se o CSS está carregado
- Verificar estrutura HTML correta
- Verificar se JavaScript foi executado

**Navegação não funciona:**
- Verificar console para erros JavaScript
- Verificar se elementos têm IDs únicos
- Verificar se container tem itens filhos

**Responsividade quebrada:**
- Verificar media queries no CSS
- Verificar se `handleResize()` está sendo chamado
- Verificar larguras dos containers

### Debug Mode

Para depuração, adicione logs:

```javascript
// No paddlenav.js, adicionar na função updateGallery():
console.log('Current index:', this.currentIndex);
console.log('Container width:', this.getContainerWidth());
console.log('Translate X:', translateX);
```

## Performance

### Otimizações Incluídas
- **CSS Transforms**: Hardware acceleration com `translate3d`
- **Event Throttling**: Resize events com debounce
- **Passive Listeners**: Touch events otimizados
- **Minimal DOM**: Manipulação eficiente

### Recomendações
- Use imagens otimizadas nos slides
- Implemente lazy loading para imagens
- Minimize reflows durante animações
- Use `will-change` para elementos animados
