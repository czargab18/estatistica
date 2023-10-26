// document.addEventListener("DOMContentLoaded", function () {
//   const slides = document.querySelectorAll(".gallery-item");
//   const dots = document.querySelectorAll(".dotnav-item");
//   const playButton = document.getElementById("playButton");
//   const pauseButton = document.getElementById("pauseButton");

//   let currentSlideIndex = 0;
//   let autoPlayInterval;

//   function hideAllSlides() {
//     slides.forEach((slide) => {
//       slide.style.display = "none";
//     });
//   }

//   function showSlide(index) {
//     if (index >= 0 && index < slides.length) {
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
//     autoPlayInterval = setInterval(nextSlide, 3000); // Altere o intervalo conforme necessário (atualmente definido como 3000 ms)
//   }

//   function stopAutoPlay() {
//     clearInterval(autoPlayInterval);
//   }

//   dots.forEach((dot, index) => {
//     dot.addEventListener("click", () => {
//       dots.forEach((d) => d.classList.remove("current"));
//       dot.classList.add("current");
//       hideAllSlides();
//       showSlide(index);
//       stopAutoPlay(); // Pare a reprodução automática quando o usuário clicar em um ponto
//     });
//   });

//   playButton.addEventListener("click", () => {
//     startAutoPlay(); // Inicie a reprodução automática quando o botão "play" for clicado
//     playButton.style.display = "none";
//     pauseButton.style.display = "block";
//   });

//   pauseButton.addEventListener("click", () => {
//     stopAutoPlay(); // Pare a reprodução automática quando o botão "pause" for clicado
//     pauseButton.style.display = "none";
//     playButton.style.display = "block";
//   });

//   dots[0].classList.add("current");
//   showSlide(0);
//   startAutoPlay(); // Inicie a reprodução automática ao carregar a página
// });

// ================ VERSÃO 2.0 ================
// ================ VERSÃO 2.0 ================
// ================ VERSÃO 2.0 ================
document.addEventListener("DOMContentLoaded", function () {
  const slides = document.querySelectorAll(".gallery-item");
  const dots = document.querySelectorAll(".dotnav-item");
  const playButton = document.getElementById("playButton");
  const pauseButton = document.getElementById("pauseButton");

  let currentSlideIndex = 0;
  let autoPlayInterval;
  let isPlaying = false; // Variável para rastrear se a reprodução automática está ativada

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
    autoPlayInterval = setInterval(nextSlide, 3000); // Altere o intervalo conforme necessário (atualmente definido como 3000 ms)
    isPlaying = true;
    playButton.classList.remove("show");
    pauseButton.classList.add("show");
  }

  function stopAutoPlay() {
    clearInterval(autoPlayInterval);
    isPlaying = false;
    playButton.classList.add("show");
    pauseButton.classList.remove("show");
  }

  dots.forEach((dot, index) => {
    dot.addEventListener("click", () => {
      dots.forEach((d) => d.classList.remove("current"));
      dot.classList.add("current");
      hideAllSlides();
      showSlide(index);
      stopAutoPlay(); // Pare a reprodução automática quando o usuário clicar em um ponto
    });
  });

  playButton.addEventListener("click", () => {
    if (!isPlaying) {
      startAutoPlay(); // Inicie a reprodução automática quando o botão "play" for clicado
    }
  });

  pauseButton.addEventListener("click", () => {
    if (isPlaying) {
      stopAutoPlay(); // Pare a reprodução automática quando o botão "pause" for clicado
    }
  });

  dots[0].classList.add("current");
  showSlide(0);
  startAutoPlay(); // Inicie a reprodução automática ao carregar a página
});
