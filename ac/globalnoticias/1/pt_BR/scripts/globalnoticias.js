/**
 * Globalnoticias.js - Sistema Completo de Navegação para Galeria de Notícias
 * Baseado nos padrões do Apple TV+ para navegação entre slides com PaddleNav
 * Inclui suporte para touch, teclado, e navegação por clique
 */
(function () {
  'use strict';

  class PaddleNavigation {
    constructor(gallerySelector) {
      this.gallery = document.querySelector(gallerySelector);
      this.itemContainer = this.gallery?.querySelector('.item-container');
      this.items = this.gallery?.querySelectorAll('.gallery-item');
      this.paddlenav = this.gallery?.querySelector('.paddlenav');
      this.nextButton = this.paddlenav?.querySelector('.next button, .paddlenav-arrow-next');
      this.prevButton = this.paddlenav?.querySelector('.previous button, .paddlenav-arrow-previous');
      this.playButton = this.gallery?.querySelector('.play-pause, #playButton');
      this.playIcon = this.gallery?.querySelector('#play-icon');
      this.pauseIcon = this.gallery?.querySelector('#pause-icon');
      this.dots = this.gallery?.querySelectorAll('.dotnav-item');

      this.currentIndex = 0;
      this.totalItems = this.items?.length || 0;
      this.autoPlayInterval = null;
      this.isPlaying = false;
      this.autoPlayDelay = 5000; // 5 segundos
      this.transitionDuration = 600; // Duração padrão das transições em ms

      if (this.isValid()) {
        this.init();
      } else {
        console.warn('❌ PaddleNavigation: Invalid gallery setup for', gallerySelector);
        this.logDebugInfo();
      }
    }

    logDebugInfo() {
      console.log('Debug Info:', {
        gallery: !!this.gallery,
        itemContainer: !!this.itemContainer,
        items: this.items?.length,
        paddlenav: !!this.paddlenav,
        nextButton: !!this.nextButton,
        prevButton: !!this.prevButton,
        playButton: !!this.playButton,
        dots: this.dots?.length
      });
    }

    isValid() {
      return this.gallery && this.itemContainer && this.items &&
        this.paddlenav && this.nextButton && this.prevButton &&
        this.totalItems > 0;
    }

    init() {
      // Set initial inline styles for all gallery items
      this.setInitialStyles();

      // Bind event listeners
      this.nextButton.addEventListener('click', () => {
        this.next();
        this.stopAutoPlay();
      });
      this.prevButton.addEventListener('click', () => {
        this.previous();
        this.stopAutoPlay();
      });

      // Play/pause button
      if (this.playButton) {
        this.playButton.addEventListener('click', this.togglePlayPause.bind(this));
      }

      // Dots navigation
      if (this.dots) {
        this.dots.forEach((dot, index) => {
          dot.addEventListener('click', (e) => {
            e.preventDefault();
            this.goToSlide(index);
            this.stopAutoPlay();
          });
        });
      }

      // Keyboard navigation
      document.addEventListener('keydown', this.handleKeydown.bind(this));

      // Touch/swipe support (basic)
      this.addTouchSupport();

      // Intersection Observer for auto-start
      this.addIntersectionObserver();

      // Initialize first state
      this.updateGallery();
      this.updateButtons();
      this.updateDots();
      this.updatePlayPauseIcons();
    }

    setInitialStyles() {
      // Set initial inline styles for all gallery items based on their position
      const containerWidth = this.getContainerWidth();

      this.items.forEach((item, index) => {
        const progress = index - this.currentIndex; // currentIndex is 0 initially
        let translateItemX = index * containerWidth;
        const zIndex = index === this.currentIndex ? 1 : 0;

        // Special positioning: when starting on first slide (index 0), position last slide as previous
        if (this.currentIndex === 0 && index === this.totalItems - 1) {
          // Position last slide to the left of first slide (as previous)
          translateItemX = -containerWidth;
          const adjustedProgress = -1; // Previous slide progress
          item.style.cssText = `--progress: ${adjustedProgress}; z-index: 0; opacity: 1; transform: translate(${translateItemX}px, 0px);`;
        } else {
          // Normal positioning for all other slides
          item.style.cssText = `--progress: ${progress}; z-index: ${zIndex}; opacity: 1; transform: translate(${translateItemX}px, 0px);`;
        }

        // Ensure first item has 'current' class
        if (index === 0) {
          item.classList.add('current');
        } else {
          item.classList.remove('current');
        }
      });
    }

    next() {
      const wasLastSlide = this.currentIndex === this.totalItems - 1;

      this.currentIndex++;

      if (this.currentIndex >= this.totalItems) {
        this.currentIndex = 0;
      }

      // Use smooth circular transition for last -> first
      if (wasLastSlide) {
        this.smoothCircularTransition('next');
      } else {
        this.updateGallery();
        this.updateButtons();
        this.updateDots();
      }
    }

    previous() {
      const wasFirstSlide = this.currentIndex === 0;

      this.currentIndex--;

      if (this.currentIndex < 0) {
        this.currentIndex = this.totalItems - 1;
      }

      // Use smooth circular transition for first -> last
      if (wasFirstSlide) {
        this.smoothCircularTransition('previous');
      } else {
        this.updateGallery();
        this.updateButtons();
        this.updateDots();
      }
    }

    smoothCircularTransition(direction) {
      const containerWidth = this.getContainerWidth();

      if (direction === 'next') {
        // Transição do último slide (currentIndex = 0 após incremento) para o primeiro
        // O primeiro slide já está posicionado à direita pelo updateGallery()

        // Mover o container suavemente para mostrar o primeiro slide
        const translateX = -(this.totalItems * containerWidth);
        this.itemContainer.style.transform = `translate3d(${translateX}px, 0px, 0px)`;

        // Após a transição CSS, reposicionar tudo normalmente
        setTimeout(() => {
          // Temporariamente desabilita transições para reposicionamento instantâneo
          this.itemContainer.style.transition = 'none';

          // Atualiza para posicionamento normal
          this.updateGallery();
          this.updateButtons();
          this.updateDots();

          // Reabilita transições após um frame
          requestAnimationFrame(() => {
            this.itemContainer.style.transition = '';
          });
        }, this.transitionDuration); // Usa a duração configurada

      } else { // direction === 'previous'
        // Transição do primeiro slide (currentIndex = totalItems-1 após decremento) para o último
        // O último slide já está posicionado à esquerda pelo updateGallery()

        // Mover o container suavemente para mostrar o último slide
        const translateX = containerWidth;
        this.itemContainer.style.transform = `translate3d(${translateX}px, 0px, 0px)`;

        // Após a transição CSS, reposicionar tudo normalmente
        setTimeout(() => {
          // Temporariamente desabilita transições para reposicionamento instantâneo
          this.itemContainer.style.transition = 'none';

          // Atualiza para posicionamento normal
          this.updateGallery();
          this.updateButtons();
          this.updateDots();

          // Reabilita transições após um frame
          requestAnimationFrame(() => {
            this.itemContainer.style.transition = '';
          });
        }, this.transitionDuration); // Usa a duração configurada
      }
    }

    goToSlide(index) {
      if (index >= 0 && index < this.totalItems) {
        this.currentIndex = index;
        this.updateGallery();
        this.updateButtons();
        this.updateDots();
      }
    }

    updateGallery() {
      // Calculate container width based on current breakpoint
      const containerWidth = this.getContainerWidth();

      // Move container to show current item
      const translateX = -(this.currentIndex * containerWidth);
      this.itemContainer.style.transform = `translate3d(${translateX}px, 0px, 0px)`;

      // Update individual items with inline styles as requested
      this.items.forEach((item, index) => {
        const progress = index - this.currentIndex;
        let translateItemX = index * containerWidth;

        // Special positioning: when on first slide (index 0), position last slide as previous
        if (this.currentIndex === 0 && index === this.totalItems - 1) {
          // Position last slide to the left of first slide (as previous)
          translateItemX = -containerWidth;
          const adjustedProgress = -1; // Previous slide progress
          item.style.cssText = `--progress: ${adjustedProgress}; z-index: 0; opacity: 1; transform: translate(${translateItemX}px, 0px);`;
        }
        // Special positioning: when on last slide, position first slide as next
        else if (this.currentIndex === this.totalItems - 1 && index === 0) {
          // Position first slide to the right of last slide (as next)
          translateItemX = this.totalItems * containerWidth;
          const adjustedProgress = 1; // Next slide progress
          item.style.cssText = `--progress: ${adjustedProgress}; z-index: 0; opacity: 1; transform: translate(${translateItemX}px, 0px);`;
        }
        // Normal positioning for all other slides
        else {
          item.style.cssText = `--progress: ${progress}; z-index: ${index === this.currentIndex ? 1 : 0}; opacity: 1; transform: translate(${translateItemX}px, 0px);`;
        }

        // Add/remove current class (matching HTML structure)
        if (index === this.currentIndex) {
          item.classList.add('current');
        } else {
          item.classList.remove('current');
        }
      });

      // Show/hide previous slide preview based on current position
      if (this.currentIndex === 0) {
        this.showPreviousSlidePreview();
      } else {
        this.hidePreviews();
      }

      // Show/hide next slide preview based on current position
      if (this.currentIndex === this.totalItems - 1) {
        this.showNextSlidePreview();
      }

      this.updateButtons();
      this.updateDots();
    }

    updateButtons() {
      // Enable/disable buttons based on current position
      const isFirstItem = this.currentIndex === 0;
      const isLastItem = this.currentIndex === this.totalItems - 1;

      // For infinite loop, buttons are always enabled if we have more than 1 item
      if (this.totalItems > 1) {
        this.prevButton.disabled = false;
        this.prevButton.classList.remove('disabled');
        this.nextButton.disabled = false;
        this.nextButton.classList.remove('disabled');
      } else {
        this.prevButton.disabled = true;
        this.prevButton.classList.add('disabled');
        this.nextButton.disabled = true;
        this.nextButton.classList.add('disabled');
      }
    }

    updateDots() {
      if (!this.dots) return;

      this.dots.forEach((dot, index) => {
        if (index === this.currentIndex) {
          dot.classList.add('current');
        } else {
          dot.classList.remove('current');
        }
      });
    }

    startAutoPlay() {
      if (this.autoPlayInterval) return; // Already playing

      this.autoPlayInterval = setInterval(() => {
        this.next();
      }, this.autoPlayDelay);

      this.isPlaying = true;
      this.updatePlayPauseIcons();

      if (this.gallery) {
        this.gallery.classList.add('autoplay');
      }
    }

    stopAutoPlay() {
      if (this.autoPlayInterval) {
        clearInterval(this.autoPlayInterval);
        this.autoPlayInterval = null;
      }

      this.isPlaying = false;
      this.updatePlayPauseIcons();

      if (this.gallery) {
        this.gallery.classList.remove('autoplay');
      }
    }

    togglePlayPause() {
      if (this.isPlaying) {
        this.stopAutoPlay();
      } else {
        this.startAutoPlay();
      }
    }

    updatePlayPauseIcons() {
      if (this.playIcon && this.pauseIcon) {
        if (this.isPlaying) {
          this.playIcon.style.display = 'none';
          this.pauseIcon.style.display = 'block';
        } else {
          this.playIcon.style.display = 'block';
          this.pauseIcon.style.display = 'none';
        }
      }

      if (this.playButton) {
        if (this.isPlaying) {
          this.playButton.classList.remove('paused');
          this.playButton.setAttribute('aria-label', 'pause slideshow gallery');
        } else {
          this.playButton.classList.add('paused');
          this.playButton.setAttribute('aria-label', 'play slideshow gallery');
        }
      }
    }

    addIntersectionObserver() {
      const observer = new IntersectionObserver((entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting && !this.isPlaying) {
            // Auto-start when gallery comes into view
            setTimeout(() => {
              if (entry.isIntersecting && !this.isPlaying) {
                this.startAutoPlay();
              }
            }, 1000); // Delay 1 segundo antes de iniciar
          } else if (!entry.isIntersecting && this.isPlaying) {
            this.stopAutoPlay();
          }
        });
      }, {
        threshold: 0.5,
        rootMargin: '0px 0px -100px 0px' // Start a bit before fully visible
      });

      if (this.gallery) {
        observer.observe(this.gallery);
      }
    }

    getContainerWidth() {
      // Return width based on current breakpoint (matching CSS media queries)
      const windowWidth = window.innerWidth;

      if (windowWidth >= 1441) {
        return 1265; // xlarge
      } else if (windowWidth > 1068) {
        return 995;  // desktop
      } else if (windowWidth > 734) {
        return 704;  // medium
      } else {
        return 289;  // small
      }
    }

    handleKeydown(event) {
      // Only handle keys when gallery is in focus or visible
      if (!this.gallery.closest(':focus-within') && !this.isInViewport()) {
        return;
      }

      switch (event.key) {
        case 'ArrowLeft':
          event.preventDefault();
          this.stopAutoPlay();
          this.previous();
          break;
        case 'ArrowRight':
          event.preventDefault();
          this.stopAutoPlay();
          this.next();
          break;
        case 'Home':
          event.preventDefault();
          this.stopAutoPlay();
          this.goToSlide(0);
          break;
        case 'End':
          event.preventDefault();
          this.stopAutoPlay();
          this.goToSlide(this.totalItems - 1);
          break;
        case ' ': // Spacebar
        case 'Enter':
          event.preventDefault();
          this.togglePlayPause();
          break;
      }
    }

    addTouchSupport() {
      let startX = 0;
      let startY = 0;
      let deltaX = 0;
      let deltaY = 0;
      const threshold = 50; // minimum distance for swipe

      this.itemContainer.addEventListener('touchstart', (e) => {
        startX = e.touches[0].clientX;
        startY = e.touches[0].clientY;
      }, { passive: true });

      this.itemContainer.addEventListener('touchmove', (e) => {
        if (!startX || !startY) return;

        deltaX = e.touches[0].clientX - startX;
        deltaY = e.touches[0].clientY - startY;
      }, { passive: true });

      this.itemContainer.addEventListener('touchend', (e) => {
        if (!startX || !startY) return;

        // Check if horizontal swipe is more significant than vertical
        if (Math.abs(deltaX) > Math.abs(deltaY) && Math.abs(deltaX) > threshold) {
          this.stopAutoPlay(); // Stop autoplay on swipe

          if (deltaX > 0) {
            // Swipe right - go to previous
            this.previous();
          } else {
            // Swipe left - go to next
            this.next();
          }
        }

        // Reset values
        startX = 0;
        startY = 0;
        deltaX = 0;
        deltaY = 0;
      }, { passive: true });
    }

    isInViewport() {
      const rect = this.gallery.getBoundingClientRect();
      return (
        rect.top >= 0 &&
        rect.left >= 0 &&
        rect.bottom <= (window.innerHeight || document.documentElement.clientHeight) &&
        rect.right <= (window.innerWidth || document.documentElement.clientWidth)
      );
    }

    // Public API methods
    getCurrentIndex() {
      return this.currentIndex;
    }

    getTotalItems() {
      return this.totalItems;
    }

    isAutoPlaying() {
      return this.isPlaying;
    }

    setAutoPlayDelay(delay) {
      this.autoPlayDelay = delay;
      if (this.isPlaying) {
        this.stopAutoPlay();
        this.startAutoPlay();
      }
    }

    setTransitionDuration(duration) {
      this.transitionDuration = duration;
      // Update CSS custom property for transition duration
      if (this.itemContainer) {
        this.itemContainer.style.setProperty('--transition-duration', `${duration}ms`);
      }
    }

    // Show preview of the previous slide when on first slide
    showPreviousSlidePreview() {
      if (this.currentIndex === 0 && this.totalItems > 1) {
        const lastSlideIndex = this.totalItems - 1;
        const lastSlide = this.items[lastSlideIndex];

        // Get the background image from the last slide
        const lastSlideLink = lastSlide?.querySelector('a');
        const backgroundImage = lastSlideLink ?
          window.getComputedStyle(lastSlideLink).backgroundImage : null;

        // Create or update preview element
        let previewElement = this.gallery.querySelector('.previous-slide-preview');

        if (!previewElement) {
          previewElement = document.createElement('div');
          previewElement.className = 'previous-slide-preview';
          previewElement.style.cssText = `
            position: absolute;
            left: -120px;
            top: 50%;
            transform: translateY(-50%);
            width: 80px;
            height: 60px;
            background-size: cover;
            background-position: center;
            border-radius: 8px;
            opacity: 0.7;
            transition: opacity 0.3s ease;
            pointer-events: none;
            z-index: 5;
          `;
          this.gallery.appendChild(previewElement);
        }

        if (backgroundImage && backgroundImage !== 'none') {
          previewElement.style.backgroundImage = backgroundImage;
          previewElement.style.opacity = '0.7';
        }
      }
    }

    // Show preview of the next slide when on last slide
    showNextSlidePreview() {
      if (this.currentIndex === this.totalItems - 1 && this.totalItems > 1) {
        const firstSlide = this.items[0];

        // Get the background image from the first slide
        const firstSlideLink = firstSlide?.querySelector('a');
        const backgroundImage = firstSlideLink ?
          window.getComputedStyle(firstSlideLink).backgroundImage : null;

        // Create or update preview element
        let previewElement = this.gallery.querySelector('.next-slide-preview');

        if (!previewElement) {
          previewElement = document.createElement('div');
          previewElement.className = 'next-slide-preview';
          previewElement.style.cssText = `
            position: absolute;
            right: -120px;
            top: 50%;
            transform: translateY(-50%);
            width: 80px;
            height: 60px;
            background-size: cover;
            background-position: center;
            border-radius: 8px;
            opacity: 0.7;
            transition: opacity 0.3s ease;
            pointer-events: none;
            z-index: 5;
          `;
          this.gallery.appendChild(previewElement);
        }

        if (backgroundImage && backgroundImage !== 'none') {
          previewElement.style.backgroundImage = backgroundImage;
          previewElement.style.opacity = '0.7';
        }
      }
    }

    // Hide preview elements
    hidePreviews() {
      const previousPreview = this.gallery.querySelector('.previous-slide-preview');
      const nextPreview = this.gallery.querySelector('.next-slide-preview');

      if (previousPreview) {
        previousPreview.style.opacity = '0';
      }

      if (nextPreview) {
        nextPreview.style.opacity = '0';
      }
    }

    // Show preview of the previous slide when on first slide
    showPreviousSlidePreview() {
      if (this.currentIndex === 0 && this.totalItems > 1) {
        const lastSlideIndex = this.totalItems - 1;
        const lastSlide = this.items[lastSlideIndex];

        // Get the background image from the last slide
        const lastSlideLink = lastSlide?.querySelector('a');
        const backgroundImage = lastSlideLink ?
          window.getComputedStyle(lastSlideLink).backgroundImage : null;

        // Create or update preview element
        let previewElement = this.gallery.querySelector('.previous-slide-preview');

        if (!previewElement) {
          previewElement = document.createElement('div');
          previewElement.className = 'previous-slide-preview';
          previewElement.style.cssText = `
            position: absolute;
            left: -100px;
            top: 50%;
            transform: translateY(-50%);
            width: 80px;
            height: 60px;
            background-size: cover;
            background-position: center;
            border-radius: 8px;
            opacity: 0.7;
            z-index: 10;
            transition: opacity 0.3s ease, transform 0.3s ease;
            cursor: pointer;
          `;

          // Add click handler to go to last slide
          previewElement.addEventListener('click', () => {
            this.goToSlide(lastSlideIndex);
            this.stopAutoPlay();
          });

          // Add hover effects
          previewElement.addEventListener('mouseenter', () => {
            previewElement.style.opacity = '1';
            previewElement.style.transform = 'translateY(-50%) scale(1.05)';
          });

          previewElement.addEventListener('mouseleave', () => {
            previewElement.style.opacity = '0.7';
            previewElement.style.transform = 'translateY(-50%) scale(1)';
          });

          this.gallery.appendChild(previewElement);
        }

        // Update background image
        if (backgroundImage && backgroundImage !== 'none') {
          previewElement.style.backgroundImage = backgroundImage;
          previewElement.style.display = 'block';
        }

        return previewElement;
      }

      return null;
    }

    // Hide preview of the previous slide
    hidePreviousSlidePreview() {
      const previewElement = this.gallery.querySelector('.previous-slide-preview');
      if (previewElement) {
        previewElement.style.display = 'none';
      }
    }

    // Show preview of the next slide when on last slide
    showNextSlidePreview() {
      if (this.currentIndex === this.totalItems - 1 && this.totalItems > 1) {
        const firstSlideIndex = 0;
        const firstSlide = this.items[firstSlideIndex];

        // Get the background image from the first slide
        const firstSlideLink = firstSlide?.querySelector('a');
        const backgroundImage = firstSlideLink ?
          window.getComputedStyle(firstSlideLink).backgroundImage : null;

        // Create or update preview element
        let previewElement = this.gallery.querySelector('.next-slide-preview');

        if (!previewElement) {
          previewElement = document.createElement('div');
          previewElement.className = 'next-slide-preview';
          previewElement.style.cssText = `
            position: absolute;
            right: -100px;
            top: 50%;
            transform: translateY(-50%);
            width: 80px;
            height: 60px;
            background-size: cover;
            background-position: center;
            border-radius: 8px;
            opacity: 0.7;
            z-index: 10;
            transition: opacity 0.3s ease, transform 0.3s ease;
            cursor: pointer;
          `;

          // Add click handler to go to first slide
          previewElement.addEventListener('click', () => {
            this.goToSlide(firstSlideIndex);
            this.stopAutoPlay();
          });

          // Add hover effects
          previewElement.addEventListener('mouseenter', () => {
            previewElement.style.opacity = '1';
            previewElement.style.transform = 'translateY(-50%) scale(1.05)';
          });

          previewElement.addEventListener('mouseleave', () => {
            previewElement.style.opacity = '0.7';
            previewElement.style.transform = 'translateY(-50%) scale(1)';
          });

          this.gallery.appendChild(previewElement);
        }

        // Update background image
        if (backgroundImage && backgroundImage !== 'none') {
          previewElement.style.backgroundImage = backgroundImage;
          previewElement.style.display = 'block';
        }

        return previewElement;
      }

      return null;
    }

    // Hide preview of the next slide
    hideNextSlidePreview() {
      const previewElement = this.gallery.querySelector('.next-slide-preview');
      if (previewElement) {
        previewElement.style.display = 'none';
      }
    }

    // Toggle slide previews on/off
    toggleSlidePreviews(enabled = true) {
      if (enabled) {
        if (this.currentIndex === 0) {
          this.showPreviousSlidePreview();
        }
        if (this.currentIndex === this.totalItems - 1) {
          this.showNextSlidePreview();
        }
      } else {
        this.hidePreviousSlidePreview();
        this.hideNextSlidePreview();
      }
    }

    // Handle window resize
    handleResize() {
      // Recalculate and apply inline styles for new container width
      this.setInitialStyles();
      this.updateGallery();
    }

    // Cleanup method
    destroy() {
      this.stopAutoPlay();
      // Remove event listeners would go here if needed
    }
  }

  // Auto-initialize when DOM is ready
  function initializePaddleNav() {
    // Look for the specific noticias gallery
    const mainGallery = document.querySelector('section[data-module-template="noticias"] .gallery#noticias');
    const paddleNavInstances = [];

    if (mainGallery) {
      const paddleNav = new PaddleNavigation('#noticias');
      if (paddleNav.isValid()) {
        paddleNavInstances.push(paddleNav);
        console.log('✅ PaddleNavigation initialized for #noticias gallery');
      } else {
        console.warn('❌ Failed to initialize PaddleNavigation for #noticias gallery');
      }
    } else {
      // Fallback: look for any gallery in noticias section
      const galleries = document.querySelectorAll('section[data-module-template="noticias"] .gallery');

      galleries.forEach((gallery, index) => {
        const galleryId = gallery.id || `noticias-gallery-${index}`;
        if (!gallery.id) {
          gallery.id = galleryId;
        }

        const paddleNav = new PaddleNavigation(`#${galleryId}`);
        if (paddleNav.isValid()) {
          paddleNavInstances.push(paddleNav);
          console.log(`✅ PaddleNavigation initialized for #${galleryId}`);
        }
      });
    }

    // Handle window resize for all instances
    let resizeTimeout;
    window.addEventListener('resize', () => {
      clearTimeout(resizeTimeout);
      resizeTimeout = setTimeout(() => {
        paddleNavInstances.forEach(instance => {
          instance.handleResize();
        });
      }, 100);
    });

    return paddleNavInstances;
  }

  // Initialize when DOM is ready
  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initializePaddleNav);
  } else {
    initializePaddleNav();
  }

  // Export for external use
  window.PaddleNavigation = PaddleNavigation;
  window.initializePaddleNav = initializePaddleNav;

})();
