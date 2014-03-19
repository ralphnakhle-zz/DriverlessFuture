

// ----------------------------------------------------------------------
// GLOBAL VARIABLES
// ----------------------------------------------------------------------

CarSystem systemOfCars;

// A path object (series of connected points)
Road road ;

// Using this variable to toggle between drawing the lines or not
boolean debug = false;

int gridSize = 180;

// ----------------------------------------------------------------------
//  FUNCTIONS
// ----------------------------------------------------------------------
void setup() {
  size(900, 700);


  // Call a function to generate new Path object
  newRoad(gridSize);
  systemOfCars = new CarSystem(road);
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
  road.display();

  // Call all functions related to Cars
  systemOfCars.run();


}
// creates a grid of point for the road class
void newRoad(int spacer) {

  road = new Road();
 // path.addPoint(0, 0);
 // path.addPoint(height, height);
  for ( int g = 0; g <width+spacer/spacer; g++) {
    road.addPoint(spacer*g, 0);
    road.addPoint(spacer*g, height);
    road.addPoint(spacer*(g+1), height);
  }
  for ( int g = 0; g <height+spacer/spacer; g++) {
    road.addPoint(0, spacer*g);
    road.addPoint(width, spacer*g);
    road.addPoint(width, spacer*(g+1));
  }
}

// press space bar to able and disable collision and target lines.
public void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
}

