document.addEventListener("DOMContentLoaded", function () {
  // Get the elements
  const gallery = document.getElementById("noticias");
  const playButton = document.getElementById("playButton");
  const playIcon = document.getElementById("playIcon");
  const pauseIcon = document.getElementById("pauseIcon");

  // Variable to keep track of the slideshow state
  let slideshowPlaying = false;

  // Function to toggle play/pause icons
  function togglePlayPauseIcons() {
    playIcon.style.display = slideshowPlaying ? "block" : "none";
    pauseIcon.style.display = slideshowPlaying ? "none" : "block";
  }

  // Function to start or pause the slideshow
  function toggleSlideshow() {
    slideshowPlaying = !slideshowPlaying;

    // Toggle play/pause icons
    togglePlayPauseIcons();

    if (slideshowPlaying) {
      // Start slideshow
      playButton.classList.remove("paused");
      playButton.setAttribute("aria-label", "pause Apple TV plus gallery");
      gallery.classList.add("autoplay");
    } else {
      // Pause slideshow
      playButton.classList.add("paused");
      playButton.setAttribute("aria-label", "play Apple TV plus gallery");
      gallery.classList.remove("autoplay");
    }
  }

  // Add click event listener to the play/pause button
  playButton.addEventListener("click", toggleSlideshow);

  // Initial setup for play/pause icons
  togglePlayPauseIcons();
});
