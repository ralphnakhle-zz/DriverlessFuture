

// ----------------------------------------------------------------------
// GLOBAL VARIABLES
// ----------------------------------------------------------------------

CarSystem systemOfCars;

// A path object (series of connected points)
Path path ;

// Using this variable to toggle between drawing the lines or not
boolean debug = false;

// ----------------------------------------------------------------------
//  FUNCTIONS
// ----------------------------------------------------------------------
void setup() {
  size(900, 700);


  // Call a function to generate new Path object
  newPath(180);
  systemOfCars = new CarSystem(path);
  systemOfCars.init();
}

// ----------------------------------------------------------------------
//  GUI FUNCTIONS 
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
//  DRAW FUNCTION
// ----------------------------------------------------------------------

void draw() {

  // draw the background
  background(0,10,10);
  // Display the road
  path.display();

  // Call all functions related to Cars
  systemOfCars.run();

  // draw the Gui bar
  rectMode(CORNER);
  fill(0, 150);
  noStroke();
 // rect(0, 0, width, 80);
 
  // text
  fill(255);
  //text("Press space bar to enable and disable toggle lines", 20, 20);
}
// creates a grid of point for the path class
void newPath(int spacer) {

  path = new Path();
 // path.addPoint(0, 0);
 // path.addPoint(height, height);
  for ( int g = 0; g <width+spacer/spacer; g++) {
    path.addPoint(spacer*g, 0);
    path.addPoint(spacer*g, height);
    path.addPoint(spacer*(g+1), height);
  }
  for ( int g = 0; g <height+spacer/spacer; g++) {
    path.addPoint(0, spacer*g);
    path.addPoint(width, spacer*g);
    path.addPoint(width, spacer*(g+1));
  }
}

// press space bar to able and disable collision and target lines.
public void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
}

