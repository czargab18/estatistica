/**
 * referência: https://codepen.io/micjamking/pen/ezMEMW
 * Time travelin'
 */
; (function (w, $) {
  'use strict';

  var

    /** 
     * Globals 
     */
    utils = w.utils,
    requestAnimationFrame = w.requestAnimationFrame,


    /** 
     * Canvas environment variables
     */
    $unitWrapper = $('.unit-wrapper')[0],
    context = $unitWrapper.getContext('2d'),
    center = new Ball(5, 'rgba(0,0,0,0)'),
    left = 0,
    top = 0,
    right = utils.screenSize().width,
    bottom = utils.screenSize().height,


    /** 
     * Particle settings
     */
    balls = [],
    numOfBalls = 320,
    colors = [
      '#5C4D91',
      '#332A53',
      '#F2CC76',
      '#1E1836'
    ],
    speed = 4,
    range = 0.01,
    trailLength = 88,


    /** 
     * Capture mouse behavior
     */
    isMouseDown,
    mouse = utils.captureMouse($unitWrapper);

  $unitWrapper.width = utils.screenSize().width;
  $unitWrapper.height = utils.screenSize().height;

  center.x = $unitWrapper.width / 2;
  center.y = $unitWrapper.height / 2;


  /**
   * Setup event listeners
   */
  if (utils.allowDeviceOrientation()) {
    window.addEventListener('deviceorientation', handleOrientation, true);
    document.addEventListener('touchend', mouseUpCallback);
    document.addEventListener('touchstart', mouseDownCallback);

  } else {

    document.addEventListener('mousemove', mouseMoveCallback);
    document.addEventListener('mousedown', mouseDownCallback);
    document.addEventListener('mouseup', mouseUpCallback);

  }


  /** 
   * Resize canvas to fullscreen
   */
  window.addEventListener('resize', windowResizeCallback);


  /** 
   * Window Resize Callback
   */
  function windowResizeCallback() {
    $unitWrapper.width = right = utils.screenSize().width;
    $unitWrapper.height = bottom = utils.screenSize().height;
    center.x = $unitWrapper.width / 2;
    center.y = $unitWrapper.height / 2;
  }


  /** 
   * Handle Device Orientation 
   *  - Tilt 90º > 0º to increase speed on mobile
   */
  function handleOrientation(event) {

    var x = event.gamma;
    var y = event.beta;

    if (x > 90) { x = 90 };
    if (x < 45) { x = 45 };

    if (y > 90) { y = 90 };
    if (y < 0) { y = 0 };

    var rangeX = (90 - Math.floor(Math.abs(x))) / 45;
    var rangeY = (90 - Math.floor(Math.abs(y))) / 90;

    // Do stuff with the new orientation data
    if (Math.floor(rangeY * 10) > 0) {
      speed = Math.floor(rangeY * 10) * 1.25;
    }

  }


  /**
   * Mouse move callback: 
   * - Set speed based on mouse position
   *
   * @param {Event} e - Event Object
   *
   */
  function mouseMoveCallback(e) {

    var halfScreenX = utils.screenSize().width / 2,
      halfScreenY = utils.screenSize().height / 2,
      vertical = Math.floor(Math.abs(((mouse.y - halfScreenY) / halfScreenY) * 10)),
      horizontal = Math.floor(Math.abs(((mouse.x - halfScreenX) / halfScreenX) * 10)),
      averageVelocity = Math.floor(Math.sqrt(horizontal * horizontal + vertical * vertical));

    if (averageVelocity > 0) {
      speed = averageVelocity * 0.5;
    }

  }


  /** 
   * Mouse Down callback: 
   * - Increment particles on press and hold
   *
   * @param {Event} e - Event Object
   *
   */
  function mouseDownCallback(e) {

    incrementParticles();
    var $console = $('.console')[0];
    $console.className = 'console hide';

  }


  /** 
   * Mouse Up callback:
   * - Reset particle count on press release
   *
   * @param {Event} e - Event Object
   *
   */
  function mouseUpCallback(e) {

    cancelAnimationFrame(isMouseDown);

  }


  /** 
   * Increment particles by calling particle generator
   */
  function incrementParticles() {

    // Call request animation frame recursively
    isMouseDown = requestAnimationFrame(incrementParticles);

    if (balls.length < 600) {
      var num = 5;
      generateParticles(balls, num);
    }

  }


  /** 
   * Generate ball coordinates and velocity (speed * direcrion)
   *
   * @param {Object} ball - Instance 2D Ball context
   *
   * @return {Object} ball - Updated instance of Ball
   */
  function generateVelocity(ball) {

    // Set starting position
    ball.x = utils.randInt(0, $unitWrapper.width);
    ball.y = utils.randInt(0, $unitWrapper.height);

    // Get distance to target
    var dx = ($unitWrapper.width / 2) - ball.x,
      dy = ($unitWrapper.height / 2) - ball.y,
      angle = Math.atan2(dy, dx);

    // Set velocity
    ball.vx = Math.cos(angle) * speed;
    ball.vy = Math.sin(angle) * speed;

    // Set aggregate velocity 
    ball.velocity = Math.sqrt(ball.vx * ball.vx + ball.vy * ball.vy);

    // Set opacity
    ball.opacity = 0;

    return ball;

  }


  /**
   * Detect boundaries of canvas
   *
   * @param {Object} ball - Instance 2D Ball context
   *
   * @return {Object} ball - Updated instance of Ball
   */
  function boundaryDetection(ball, index) {

    // Check if ball is outside 
    // boundary of canvas window
    // and reset position/velocity if so
    var bounds = center.getBounds();
    if (utils.containsPoint(bounds, ball.x, ball.y) ||
      ball.x + ball.radius < left ||
      ball.x - ball.radius > right ||
      ball.y + ball.radius < top ||
      ball.y - ball.radius > bottom) {

      if (index > numOfBalls) {

        balls.splice(index, 1);
        return null;

      } else {

        return generateVelocity(ball);

      }

    } else {

      return ball;

    }

  }


  /**
   * Draw ball motion
   *
   * @param {Object} ball - Instance 2D Ball context
   */
  function drawBall(ball, index) {

    // Move balls
    ball.x += ball.vx;
    ball.y += ball.vy;

    // Fade in from center
    if (ball.opacity < 1) {
      ball.opacity += ball.velocity * range;
    }

    // Reset ball velocity when it
    // reaches the edge of screen
    ball = boundaryDetection(ball, index);

    // draw ball to canvas
    if (ball) {
      ball.draw(context, utils);
    }

  }


  /**
   * Generate particles
   */
  function generateParticles(particles, num) {

    for (var i = 0; i < num; i++) {

      // Generate new Ball instance
      var particle = new Ball(

        // Random size from 1-4
        utils.randInt(1, 4),

        // Random color from colors array
        colors[utils.randInt(0, colors.length)]
      );

      // Set ball velocity
      particle = generateVelocity(particle);

      // Add ball to array
      particles.push(particle);

    }

    return particles;

  }

  generateParticles(balls, numOfBalls);


  /**
   * Animation loop
   */
  (function animate() {

    // Call request animation frame recursively
    requestAnimationFrame(animate, $unitWrapper);

    // Clear canvas every frame
    context.fillStyle = utils.colorToRGB('#000000', (100 - trailLength) / 100);
    context.fillRect(left, top, right, bottom);

    // do stuff...
    for (var i = 0; i < balls.length; i++) {
      drawBall(balls[i], i);
    }

  })();

})(
  window,
  document.querySelectorAll.bind(document)
);