// document.addEventListener("DOMContentLoaded", function () {
//   const slides = document.querySelectorAll(".gallery-item");
//   const dots = document.querySelectorAll(".dotnav-item");
//   const playPauseButton = document.querySelector(".play-pause");
//   const playIcon = document.getElementById("play-icon");
//   const pauseIcon = document.getElementById("pause-icon");
//   const noticiasSection = document.querySelector(
//     "[data-module-template='noticias']"
//   );

//   let currentSlideIndex = 0;
//   let autoPlayInterval;
//   let isPlaying = false;

//   function hideAllSlides() {
//     slides.forEach((slide) => {
//       slide.style.display = "none";
//     });
//   }

//   function showSlide(index) {
//     if (index >= 0 && index < slides.length) {
//       slides.forEach((slide) => {
//         slide.style.display = "none";
//       });
//       slides[index].style.display = "block";
//       currentSlideIndex = index;
//     }
//   }

//   function nextSlide() {
//     const nextIndex = (currentSlideIndex + 1) % slides.length;
//     dots[currentSlideIndex].classList.remove("current");
//     dots[nextIndex].classList.add("current");
//     hideAllSlides();
//     showSlide(nextIndex);
//   }

//   function startAutoPlay() {
//     autoPlayInterval = setInterval(nextSlide, 3000);
//     isPlaying = true;
//     playIcon.style.display = "none"; // Esconder o ícone de play
//     pauseIcon.style.display = "block"; // Exibir o ícone de pause
//   }

//   function stopAutoPlay() {
//     clearInterval(autoPlayInterval);
//     isPlaying = false;
//     playIcon.style.display = "block"; // Exibir o ícone de play
//     pauseIcon.style.display = "none"; // Esconder o ícone de pause
//   }

//   function togglePlayPause() {
//     if (isPlaying) {
//       stopAutoPlay();
//     } else {
//       startAutoPlay();
//     }
//   }

//   dots.forEach((dot, index) => {
//     dot.addEventListener("click", () => {
//       dots.forEach((d) => d.classList.remove("current"));
//       dot.classList.add("current");
//       showSlide(index);
//       stopAutoPlay();
//     });
//   });

//   playPauseButton.addEventListener("click", () => {
//     togglePlayPause();
//   });

//   // Verificar quando a seção de notícias está visível na tela
//   function isElementInViewport(el) {
//     const rect = el.getBoundingClientRect();
//     return (
//       rect.top >= 0 &&
//       rect.left >= 0 &&
//       rect.bottom <=
//         (window.innerHeight || document.documentElement.clientHeight) &&
//       rect.right <= (window.innerWidth || document.documentElement.clientWidth)
//     );
//   }

//   function handleScroll() {
//     if (isElementInViewport(noticiasSection) && !isPlaying) {
//       startAutoPlay();
//       window.removeEventListener("scroll", handleScroll);
//     }
//   }

//   // Adicionar listener de evento de scroll
//   window.addEventListener("scroll", handleScroll);

//   showSlide(0); // Mostrar o primeiro slide inicialmente
//   dots[0].classList.add("current"); // Adicionar classe "current" ao primeiro ponto
// });


// ver
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
