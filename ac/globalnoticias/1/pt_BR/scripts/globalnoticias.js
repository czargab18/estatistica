document.addEventListener("DOMContentLoaded", function () {
  const slides = document.querySelectorAll(".gallery-item");
  const dots = document.querySelectorAll(".dotnav-item");
  const playPauseButton = document.querySelector(".play-pause");
  const playIcon = document.getElementById("play-icon");
  const pauseIcon = document.getElementById("pause-icon");

  let currentSlideIndex = 0;
  let autoPlayInterval;
  let isPlaying = false;

  function hideAllSlides() {
    slides.forEach((slide) => {
      slide.style.display = "none";
    });
  }

  function showSlide(index) {
    if (index >= 0 && index < slides.length) {
      slides[index].style.display = "block";
      currentSlideIndex = index;
    }
  }

  function nextSlide() {
    const nextIndex = (currentSlideIndex + 1) % slides.length;
    dots[currentSlideIndex].classList.remove("current");
    dots[nextIndex].classList.add("current");
    hideAllSlides();
    showSlide(nextIndex);
  }

  function startAutoPlay() {
    autoPlayInterval = setInterval(nextSlide, 3000);
    isPlaying = true;
    playIcon.style.display = "none"; // Esconder o ícone de play
    pauseIcon.style.display = "block"; // Exibir o ícone de pause
  }

  function stopAutoPlay() {
    clearInterval(autoPlayInterval);
    isPlaying = false;
    playIcon.style.display = "block"; // Exibir o ícone de play
    pauseIcon.style.display = "none"; // Esconder o ícone de pause
  }

  function togglePlayPause() {
    if (isPlaying) {
      stopAutoPlay();
    } else {
      startAutoPlay();
    }
  }

  dots.forEach((dot, index) => {
    dot.addEventListener("click", () => {
      dots.forEach((d) => d.classList.remove("current"));
      dot.classList.add("current");
      hideAllSlides();
      showSlide(index);
      stopAutoPlay();
    });
  });

  playPauseButton.addEventListener("click", () => {
    togglePlayPause();
  });

  showSlide(0); // Mostrar o primeiro slide inicialmente
  dots[0].classList.add("current"); // Adicionar classe "current" ao primeiro ponto
  startAutoPlay();

  // Ajuste para ciclo infinito
  function previousSlide() {
    const previousIndex =
      (currentSlideIndex - 1 + slides.length) % slides.length;
    dots[currentSlideIndex].classList.remove("current");
    dots[previousIndex].classList.add("current");
    hideAllSlides();
    showSlide(previousIndex);
  }

  // Atualizar evento de clique para botão anterior
  const previousButton = document.querySelector(".paddlenav-arrow-previous");
  previousButton.addEventListener("click", () => {
    previousSlide();
    stopAutoPlay();
  });
});
