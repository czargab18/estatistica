/**
 * Globalnoticias.js - Sistema Completo de Navegação para Galeria de Notícias
 * Baseado nos padrões do Apple TV+ para navegação entre slides com PaddleNav
 * Inclui suporte para touch, teclado, e navegação por clique
 */
(function() {
    'use strict';

    class PaddleNavigation {
        constructor(gallerySelector) {
            this.gallery = document.querySelector(gallerySelector);
            this.itemContainer = this.gallery?.querySelector('.item-container');
            this.items = this.gallery?.querySelectorAll('.gallery-item');
            this.paddlenav = this.gallery?.querySelector('.paddlenav');
            this.nextButton = this.paddlenav?.querySelector('.next button');
            this.prevButton = this.paddlenav?.querySelector('.previous button');
          this.playButton = this.gallery?.querySelector('.play-pause');
          this.playIcon = this.gallery?.querySelector('#play-icon');
          this.pauseIcon = this.gallery?.querySelector('#pause-icon');
          this.dots = this.gallery?.querySelectorAll('.dotnav-item');
            
            this.currentIndex = 0;
            this.totalItems = this.items?.length || 0;
          this.autoPlayInterval = null;
          this.isPlaying = false;
          this.autoPlayDelay = 5000; // 5 segundos
            
            if (this.isValid()) {
                this.init();
            }
        }

        isValid() {
            return this.gallery && this.itemContainer && this.items && 
                   this.paddlenav && this.nextButton && this.prevButton && 
                   this.totalItems > 0;
        }

        init() {
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

        next() {
            if (this.currentIndex < this.totalItems - 1) {
                this.currentIndex++;
            } else {
              this.currentIndex = 0; // Loop back to first item
            }
          this.updateGallery();
          this.updateButtons();
          this.updateDots();
        }

        previous() {
            if (this.currentIndex > 0) {
                this.currentIndex--;
            } else {
              this.currentIndex = this.totalItems - 1; // Loop to last item
            }
          this.updateGallery();
          this.updateButtons();
          this.updateDots();
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
            
            // Move the container to show current item
            const translateX = -(this.currentIndex * containerWidth);
            this.itemContainer.style.transform = `translate3d(${translateX}px, 0px, 0px)`;

            // Update individual items positions and z-index
            this.items.forEach((item, index) => {
                const progress = index - this.currentIndex;
                const translateItemX = index * containerWidth;
                
                item.style.setProperty('--progress', progress);
                item.style.transform = `translate(${translateItemX}px, 0px)`;
                item.style.zIndex = index === this.currentIndex ? 1 : 0;
                item.style.opacity = 1;

                // Add/remove active class
                if (index === this.currentIndex) {
                    item.classList.add('active');
                } else {
                    item.classList.remove('active');
                }
            });
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

        // Handle window resize
        handleResize() {
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
        const galleries = document.querySelectorAll('section[data-module-template="noticias"] .gallery');
        const paddleNavInstances = [];

        galleries.forEach((gallery, index) => {
            const selectorId = `#noticias-gallery-${index}`;
            gallery.id = `noticias-gallery-${index}`;
            
            const paddleNav = new PaddleNavigation(`#${gallery.id}`);
            if (paddleNav.isValid()) {
                paddleNavInstances.push(paddleNav);
            }
        });

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
