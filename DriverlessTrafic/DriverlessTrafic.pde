
import controlP5.*;

//image variable for importing iPad png
PImage img;

void setup() {
  setup (0, 0);

  size(1004, 750);
  img = loadImage("ipad.png");
}

void draw() {
  
  image(img, 0, 0);
  draw(0);
}
