int max_iteration = 150;
float xMin = -2.5;
float xMax = 1;
float yMin = -1.5;
float yMax = 1.5;
float startMouseX, startMouseY;
float startXMin, startXMax, startYMin, startYMax;

void setup() {
  size(1050, 900);
  colorMode(HSB, 200);
  noLoop();
}

void draw() {
  loadPixels();

  for (int y = 0; y < height; y++) {
    float c_y = map(y, 0, height, yMin, yMax);

    for (int x = 0; x < width; x++) {
      float c_x = map(x, 0, width, xMin, xMax);

      float re = 0;
      float im = 0;
      int iteration = 0;

      while (re * re + im * im <= 4 && iteration < max_iteration) {
        float square = (re * re - im * im) + c_x;
        im = (2 * re * im) + c_y;
        re = square;
        iteration++;
      }

      int pixCol = x + y * width;

      if (iteration == max_iteration) {
        pixels[pixCol] = color(0);
      }
      else {
        float hue = map(iteration, 0, max_iteration, 0, 255);
        pixels[pixCol] = color(hue, 255, 255);
      }
    }
  }
  updatePixels();
}

void keyPressed() {
  float zoom;
  if (key == 'w') {
    zoom = 1 - 0.1;
  }
  else if (key == 's') {
    zoom = 1 + 0.1;
  }
  else {
    return;
  }

// w/s zoom in/out
  float xMap = map(mouseX, 0, width, xMin, xMax);
  float yMap = map(mouseY, 0, height, yMin, yMax);
  
  xMin = xMap - (xMap - xMin) * zoom;
  xMax = xMap + (xMax - xMap) * zoom;
  yMin = yMap - (yMap - yMin) * zoom;
  yMax = yMap + (yMax - yMap) * zoom;
  
  redraw();
}

// following allows for mouse panning
void mousePressed() {
  startMouseX = mouseX;
  startMouseY = mouseY;

  startXMin = xMin;
  startXMax = xMax;
  startYMin = yMin;
  startYMax = yMax;
}

void mouseDragged() {
  float dx = mouseX - startMouseX;
  float dy = mouseY - startMouseY;

  float rangeX = startXMax - startXMin;
  float rangeY = startYMax - startYMin;

  float moveRe = -dx / width  * rangeX;
  float moveIm = -dy / height * rangeY;

  xMin = startXMin + moveRe;
  xMax = startXMax + moveRe;
  yMin = startYMin + moveIm;
  yMax = startYMax + moveIm;

  redraw();
}
