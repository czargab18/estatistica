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
            
            this.currentIndex = 0;
            this.totalItems = this.items?.length || 0;
            
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
            this.nextButton.addEventListener('click', this.next.bind(this));
            this.prevButton.addEventListener('click', this.previous.bind(this));

            // Keyboard navigation
            document.addEventListener('keydown', this.handleKeydown.bind(this));

            // Touch/swipe support (basic)
            this.addTouchSupport();

            // Initialize first state
            this.updateGallery();
            this.updateButtons();
        }

        next() {
            if (this.currentIndex < this.totalItems - 1) {
                this.currentIndex++;
                this.updateGallery();
                this.updateButtons();
            }
        }

        previous() {
            if (this.currentIndex > 0) {
                this.currentIndex--;
                this.updateGallery();
                this.updateButtons();
            }
        }

        goToSlide(index) {
            if (index >= 0 && index < this.totalItems) {
                this.currentIndex = index;
                this.updateGallery();
                this.updateButtons();
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

            // Update previous button
            if (isFirstItem) {
                this.prevButton.disabled = true;
                this.prevButton.classList.add('disabled');
            } else {
                this.prevButton.disabled = false;
                this.prevButton.classList.remove('disabled');
            }

            // Update next button
            if (isLastItem) {
                this.nextButton.disabled = true;
                this.nextButton.classList.add('disabled');
            } else {
                this.nextButton.disabled = false;
                this.nextButton.classList.remove('disabled');
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
                    this.previous();
                    break;
                case 'ArrowRight':
                    event.preventDefault();
                    this.next();
                    break;
                case 'Home':
                    event.preventDefault();
                    this.goToSlide(0);
                    break;
                case 'End':
                    event.preventDefault();
                    this.goToSlide(this.totalItems - 1);
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

        // Handle window resize
        handleResize() {
            this.updateGallery();
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
