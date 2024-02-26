document.addEventListener("DOMContentLoaded", function () {
  const slides = document.querySelectorAll(".gallery-item");
  const dots = document.querySelectorAll(".dotnav-item");
  const playPauseButton = document.querySelector(".play-pause");
  const playIcon = document.getElementById("play-icon");
  const pauseIcon = document.getElementById("pause-icon");
  const paddlePrevious = document.querySelector(".paddlenav-arrow-previous");
  const paddleNext = document.querySelector(".paddlenav-arrow-next");

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
      hideAllSlides();
      slides[index].style.display = "block";
      currentSlideIndex = index;
    }
  }

  function nextSlide() {
    const nextIndex = (currentSlideIndex + 1) % slides.length;
    dots[currentSlideIndex].classList.remove("current");
    dots[nextIndex].classList.add("current");
    showSlide(nextIndex);
  }

  function previousSlide() {
    const previousIndex =
      currentSlideIndex === 0 ? slides.length - 1 : currentSlideIndex - 1;
    dots[currentSlideIndex].classList.remove("current");
    dots[previousIndex].classList.add("current");
    showSlide(previousIndex);
  }

  function startAutoPlay() {
    autoPlayInterval = setInterval(nextSlide, 3000);
    isPlaying = true;
    playIcon.style.display = "none";
    pauseIcon.style.display = "block";
  }

  function stopAutoPlay() {
    clearInterval(autoPlayInterval);
    isPlaying = false;
    playIcon.style.display = "block";
    pauseIcon.style.display = "none";
  }

  function togglePlayPause() {
    if (isPlaying) {
      stopAutoPlay();
    } else {
      startAutoPlay();
    }
  }

  playPauseButton.addEventListener("click", () => {
    togglePlayPause();
  });

  paddlePrevious.addEventListener("click", () => {
    stopAutoPlay();
    previousSlide();
  });

  paddleNext.addEventListener("click", () => {
    stopAutoPlay();
    nextSlide();
  });

  dots.forEach((dot, index) => {
    dot.addEventListener("click", () => {
      stopAutoPlay();
      dots.forEach((d) => d.classList.remove("current"));
      dot.classList.add("current");
      showSlide(index);
    });
  });

  showSlide(0);
  dots[0].classList.add("current");

  startAutoPlay();
});
