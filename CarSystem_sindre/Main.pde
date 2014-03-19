

// ----------------------------------------------------------------------
// GLOBAL VARIABLES
// ----------------------------------------------------------------------

CarSystem systemOfCars;

// A path object (series of connected points)
CityBg cityBg ;

GUI gui ;

// Using this variable to toggle between drawing the lines or not
boolean debug = false;

int gridSize = 180;


// ----------------------------------------------------------------------
//  FUNCTIONS
// ----------------------------------------------------------------------
void setup() {
  size(900, 700);
  //initialize Gui 
  gui = new GUI();

  cityBg = new CityBg(20);
  // Call a function to generate new Path object
  cityBg.newGrid(gridSize);

  systemOfCars = new CarSystem();
  systemOfCars.init();
}


// ----------------------------------------------------------------------
//  DRAW FUNCTION
// ----------------------------------------------------------------------

void draw() {

  // draw the background
  background(0, 10, 10);
  // Display the road
  cityBg.display();

  // Call all functions related to Cars
  systemOfCars.run();

  //display Gui
  gui.display();
  gui.activateToggle();
}


// press space bar to able and disable collision and target lines.
public void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
}

