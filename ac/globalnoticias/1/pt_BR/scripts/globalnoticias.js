document.addEventListener("DOMContentLoaded", function () {
  const gallery = document.getElementById("noticias");
  const playButton = document.getElementById("playButton");
  const playIcon = document.getElementById("play-icon");
  const pauseIcon = document.getElementById("pause-icon");

  let slideshowPlaying = false;

  function togglePlayPauseIcons() {
    if (playIcon && pauseIcon) {
      playIcon.style.display = slideshowPlaying ? "none" : "block";
      pauseIcon.style.display = slideshowPlaying ? "block" : "none";
    }
  }

  function toggleSlideshow() {
    slideshowPlaying = !slideshowPlaying;

    togglePlayPauseIcons();

    if (slideshowPlaying) {
      playButton.classList.remove("paused");
      playButton.setAttribute("aria-label", "pause slideshow gallery");
      gallery.classList.add("autoplay");
    } else {
      playButton.classList.add("paused");
      playButton.setAttribute("aria-label", "play slideshow gallery");
      gallery.classList.remove("autoplay");
    }
  }

  if (playButton) {
    playButton.addEventListener("click", toggleSlideshow);
  }
  togglePlayPauseIcons();
});


document.addEventListener("DOMContentLoaded", function () {
  const slides = document.querySelectorAll(".gallery-item");
  const dots = document.querySelectorAll(".dotnav-item");
  const playPauseButton = document.querySelector(".play-pause");
  const playIcon = document.getElementById("play-icon");
  const pauseIcon = document.getElementById("pause-icon");
  const noticiasSection = document.querySelector(
    "[data-module-template='noticias']"
  );
  const paddlenav = document.querySelector(".paddlenav");

  let currentSlideIndex = 0;
  let autoPlayInterval;
  let isPlaying = false;

  function hideAllSlides() {
    slides.forEach((slide, index) => {
      slide.style.display = index === currentSlideIndex ? "block" : "none";
      slide.classList.remove("current");
    });
    if (slides[currentSlideIndex]) {
      slides[currentSlideIndex].classList.add("current");
    }
  }

  function showSlide(index) {
    if (index >= 0 && index < slides.length) {
      currentSlideIndex = index;
      hideAllSlides();
      updateTablist(index);
    }
  }

  function nextSlide() {
    const nextIndex = (currentSlideIndex + 1) % slides.length;
    showSlide(nextIndex);
  }

  function previousSlide() {
    const previousIndex =
      (currentSlideIndex - 1 + slides.length) % slides.length;
    showSlide(previousIndex);
  }

  function startAutoPlay() {
    autoPlayInterval = setInterval(nextSlide, 5000);
    isPlaying = true;
    if (playIcon && pauseIcon) {
      playIcon.style.display = "none";
      pauseIcon.style.display = "block";
    }
  }

  function stopAutoPlay() {
    clearInterval(autoPlayInterval);
    isPlaying = false;
    if (playIcon && pauseIcon) {
      playIcon.style.display = "block";
      pauseIcon.style.display = "none";
    }
  }

  function togglePlayPause() {
    if (isPlaying) {
      stopAutoPlay();
    } else {
      startAutoPlay();
    }
  }

  function updateTablist(index) {
    dots.forEach((dot) => {
      dot.classList.remove("current");
    });
    if (dots[index]) {
      dots[index].classList.add("current");
    }
  }

  dots.forEach((dot, index) => {
    dot.addEventListener("click", (e) => {
      e.preventDefault();
      showSlide(index);
      stopAutoPlay();
    });
  });

  if (playPauseButton) {
    playPauseButton.addEventListener("click", () => {
      togglePlayPause();
    });
  }

  const observer = new IntersectionObserver(
    (entries) => {
      entries.forEach((entry) => {
        if (entry.isIntersecting && !isPlaying) {
          startAutoPlay();
        } else if (!entry.isIntersecting && isPlaying) {
          stopAutoPlay();
        }
      });
    },
    { threshold: 0.5 }
  );

  if (noticiasSection) {
    observer.observe(noticiasSection);
  }

  if (paddlenav) {
    paddlenav.addEventListener("click", (event) => {
      const target = event.target.closest("button");
      if (target && target.classList.contains("paddlenav-arrow")) {
        const direction = target.classList.contains("paddlenav-arrow-previous")
          ? -1
          : 1;
        const newIndex =
          (currentSlideIndex + direction + slides.length) % slides.length;
        showSlide(newIndex);
        stopAutoPlay();
      }
    });
  }

  // Inicialização
  if (slides.length > 0) {
    showSlide(0);
  }
});
