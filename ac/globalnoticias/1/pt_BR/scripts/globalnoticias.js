// Adicione seu código JavaScript aqui para implementar a funcionalidade de slider
const itemContainer = document.querySelector(".item-container");
const galleryItems = document.querySelectorAll(".gallery-item");
const playButton = document.getElementById("playButton");

let currentIndex = 0;
let isPlaying = false;
let intervalId;

function goToSlide(index) {
  itemContainer.style.transform = `translateX(-${index * 100}%)`;
  currentIndex = index;
}

function startSlider() {
  if (!isPlaying) {
    isPlaying = true;
    // playButton.textContent = "Pause";

    intervalId = setInterval(() => {
      let nextIndex = currentIndex + 1;
      if (nextIndex >= galleryItems.length) {
        nextIndex = 0;
      }
      goToSlide(nextIndex);
    }, 3000); // Altere o intervalo conforme necessário (em milissegundos)
  }
}

function pauseSlider() {
  if (isPlaying) {
    clearInterval(intervalId);
    isPlaying = false;
    // playButton.textContent = "Play";
  }
}

playButton.addEventListener("click", () => {
  if (isPlaying) {
    pauseSlider();
  } else {
    // Adicione um atraso antes de iniciar o slider novamente
    setTimeout(startSlider, 1000); // Atraso de 1 segundo (1000 milissegundos)
  }
});
