// // // document.addEventListener("DOMContentLoaded", function () {
// // //   const gallery = document.querySelector(".gallery");
// // //   const items = document.querySelectorAll(".gallery-item");
// // //   const playButton = document.getElementById("playButton");

// // //   let currentIndex = 0;
// // //   let isPlaying = true;

// // //   function nextSlide() {
// // //     currentIndex = (currentIndex + 1) % items.length;
// // //     updateGallery();
// // //   }

// // //   function prevSlide() {
// // //     currentIndex = (currentIndex - 1 + items.length) % items.length;
// // //     updateGallery();
// // //   }

// // //   function updateGallery() {
// // //     const translateValue = -currentIndex * 100 + "%";
// // //     gallery.style.transform = "translateX(" + translateValue + ")";
// // //   }

// // //   function togglePlayPause() {
// // //     isPlaying = !isPlaying;
// // //     playButton.classList.toggle("paused", !isPlaying);

// // //     if (isPlaying) {
// // //       playSlideshow();
// // //     } else {
// // //       pauseSlideshow();
// // //     }
// // //   }

// // //   function playSlideshow() {
// // //     intervalId = setInterval(nextSlide, 3000); // Change slide every 3 seconds
// // //   }

// // //   function pauseSlideshow() {
// // //     clearInterval(intervalId);
// // //   }

// // //   playButton.addEventListener("click", togglePlayPause);

// // //   // Set up initial slideshow
// // //   playSlideshow();

// // //   // Handle paddle navigation
// // //   document
// // //     .querySelector(".paddlenav-arrow-previous")
// // //     .addEventListener("click", prevSlide);
// // //   document
// // //     .querySelector(".paddlenav-arrow-next")
// // //     .addEventListener("click", nextSlide);
// // // });

// // document.addEventListener("DOMContentLoaded", function () {
// //   const gallery = document.querySelector(".gallery");
// //   const itemContainer = document.querySelector(".item-container");
// //   const items = document.querySelectorAll(".gallery-item");
// //   const playButton = document.getElementById("playButton");

// //   let currentIndex = 0;
// //   let isPlaying = true;
// //   let intervalId;

// //   function nextSlide() {
// //     currentIndex = (currentIndex + 1) % items.length;
// //     updateGallery();
// //   }

// //   function prevSlide() {
// //     currentIndex = (currentIndex - 1 + items.length) % items.length;
// //     updateGallery();
// //   }

// //   function updateGallery() {
// //     const translateValue = -currentIndex * 100 + "%";
// //     itemContainer.style.transform = "translateX(" + translateValue + ")";
// //   }

// //   function togglePlayPause() {
// //     isPlaying = !isPlaying;
// //     playButton.classList.toggle("paused", !isPlaying);

// //     if (isPlaying) {
// //       playSlideshow();
// //     } else {
// //       pauseSlideshow();
// //     }
// //   }

// //   function playSlideshow() {
// //     intervalId = setInterval(nextSlide, 3000); // Change slide every 3 seconds
// //   }

// //   function pauseSlideshow() {
// //     clearInterval(intervalId);
// //   }

// //   playButton.addEventListener("click", togglePlayPause);

// //   // Set up initial slideshow
// //   playSlideshow();

// //   // Handle paddle navigation
// //   document
// //     .querySelector(".paddlenav-arrow-previous")
// //     .addEventListener("click", prevSlide);
// //   document
// //     .querySelector(".paddlenav-arrow-next")
// //     .addEventListener("click", nextSlide);
// // });

// document.addEventListener("DOMContentLoaded", function () {
//   const gallery = document.querySelector(".gallery");
//   const itemContainer = document.querySelector(".item-container");
//   const items = document.querySelectorAll(".gallery-item");
//   const playButton = document.getElementById("playButton");
//   const dotnav = document.querySelector(".dotnav");

//   let currentIndex = 0;
//   let isPlaying = true;
//   let intervalId;

//   function nextSlide() {
//     currentIndex = (currentIndex + 1) % items.length;
//     updateGallery();
//     updateDotnav();
//   }

//   function prevSlide() {
//     currentIndex = (currentIndex - 1 + items.length) % items.length;
//     updateGallery();
//     updateDotnav();
//   }

//   function updateGallery() {
//     const translateValue = -currentIndex * 100 + "%";
//     itemContainer.style.transform = "translateX(" + translateValue + ")";
//   }

//   function updateDotnav() {
//     const dotItems = Array.from(dotnav.children);

//     dotItems.forEach((dot, index) => {
//       dot.classList.toggle("current", index === currentIndex);
//     });
//   }

//   function togglePlayPause() {
//     isPlaying = !isPlaying;
//     playButton.classList.toggle("paused", !isPlaying);

//     if (isPlaying) {
//       playSlideshow();
//     } else {
//       pauseSlideshow();
//     }
//   }

//   function playSlideshow() {
//     intervalId = setInterval(nextSlide, 3000); // Change slide every 3 seconds
//   }

//   function pauseSlideshow() {
//     clearInterval(intervalId);
//   }

//   playButton.addEventListener("click", togglePlayPause);

//   // Set up initial slideshow
//   playSlideshow();

//   // Handle paddle navigation
//   document
//     .querySelector(".paddlenav-arrow-previous")
//     .addEventListener("click", prevSlide);
//   document
//     .querySelector(".paddlenav-arrow-next")
//     .addEventListener("click", nextSlide);

//   // Populate dotnav dynamically
//   for (let i = 0; i < items.length; i++) {
//     const dot = document.createElement("div");
//     dot.classList.add("dotnav-item");
//     dot.setAttribute("role", "presentation");
//     dot.setAttribute("aria-selected", i === 0 ? "true" : "false");
//     dot.addEventListener("click", () => {
//       currentIndex = i;
//       updateGallery();
//       updateDotnav();
//     });
//     dotnav.appendChild(dot);
//   }
// });

document.addEventListener("DOMContentLoaded", function () {
  const dotnavItems = document.querySelectorAll(".dotnav-item");
  const galleryItems = document.querySelectorAll(".gallery-item");
  const playButton = document.getElementById("playButton");

  let currentIndex = 0;
  let isPlaying = true;
  let intervalId;

  function showSlide(index) {
    currentIndex = index;
    updateGallery();
    updateDotnav();
  }

  function nextSlide() {
    currentIndex = (currentIndex + 1) % galleryItems.length;
    updateGallery();
    updateDotnav();
  }

  function prevSlide() {
    currentIndex =
      (currentIndex - 1 + galleryItems.length) % galleryItems.length;
    updateGallery();
    updateDotnav();
  }

  function updateGallery() {
    const translateValue = -currentIndex * 100 + "%";
    document.querySelector(".item-container").style.transform =
      "translateX(" + translateValue + ")";
  }

  function updateDotnav() {
    dotnavItems.forEach((dot, index) => {
      dot.classList.toggle("current", index === currentIndex);
    });
  }

  function togglePlayPause() {
    isPlaying = !isPlaying;
    playButton.classList.toggle("paused", !isPlaying);

    if (isPlaying) {
      playSlideshow();
    } else {
      pauseSlideshow();
    }
  }

  function playSlideshow() {
    intervalId = setInterval(nextSlide, 3000); // Change slide every 3 seconds
  }

  function pauseSlideshow() {
    clearInterval(intervalId);
  }

  playButton.addEventListener("click", togglePlayPause);

  // Handle dotnav navigation
  dotnavItems.forEach((dot, index) => {
    dot.addEventListener("click", () => {
      showSlide(index);
      pauseSlideshow(); // Pause slideshow when dot is clicked
    });
  });

  // Set up initial slideshow
  playSlideshow();

  // Handle paddle navigation
  document
    .querySelector(".paddlenav-arrow-previous")
    .addEventListener("click", () => {
      prevSlide();
      pauseSlideshow(); // Pause slideshow when paddle is clicked
    });
  document
    .querySelector(".paddlenav-arrow-next")
    .addEventListener("click", () => {
      nextSlide();
      pauseSlideshow(); // Pause slideshow when paddle is clicked
    });
});
