/**
 * Plasma effect derived from http://lodev.org/cgtutor/plasma.html
 *
 * With such a low resolution of LEDs, some of the effect is lost. A 256x256 array looks much nicer.
 */
class Plasma extends Effect {

  /**
    * Steps: 1 - 100 (fast - slow)
    * Saturation: 0 - 255
    * Brightness: 0 - 255
    * Zoom: 1 - 100 (low - high)
    */
  int _steps, _saturation, _brightness, _zoom;

  Plasma(int _millis, int st, int sa, int br, int z) {
    super(_millis);
    colorMode(HSB);
    if (st < 1 || st > 255) { st = 35; }
    if (z < 1 || z > 100) { z = 8; }
    _steps = st;
    _saturation = sa % 256;
    _brightness = br % 256;
    _zoom = z;
  }

  void update() {
    imageBuffer.beginDraw();
    imageBuffer.loadPixels();
    int x, y, hue;
    color c;
    for (int i = 0; i < imageBuffer.pixels.length; i++) {
      x = i % width;
      y = i / width;

      hue = int(128.0 + (128.0 * sin(x / 16.0)) +
                128.0 + (128.0 * sin(y / 32.0)) + 
                128.0 + (128.0 * sin(sqrt(((x - width / 2.0) * (x - width / 2.0) + (y - height / 2.0) * (y - height / 2.0))) / 2.0)) +
                128.0 + (128.0 * sin(sqrt((x * x + y * y)) / 2.0))) / _zoom;

      c = color((hue + millis() / _steps) % 256, _saturation, _brightness);
      imageBuffer.pixels[i] = c;
    }
    imageBuffer.updatePixels();
    imageBuffer.endDraw();
  }
}
