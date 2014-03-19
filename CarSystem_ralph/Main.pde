

// ----------------------------------------------------------------------
// GLOBAL VARIABLES
// ----------------------------------------------------------------------

CarSystem systemOfCars;

// A path object (series of connected points)
CityBg cityBg ;

HighwayBg highwayBg;

GUI gui ;

// Using this variable to toggle between drawing the lines or not
boolean debug = false;

//int gridSize = 600;
int gridSize = 1;
char scenario;

// ----------------------------------------------------------------------
//  FUNCTIONS
// ----------------------------------------------------------------------
void setup() {
  size(900, 700);
  scenario = 'C';
  //initialize Gui 
  gui = new GUI();

  cityBg = new CityBg(20,180);
  highwayBg = new HighwayBg(40);
  
  // Call a function to generate new Path object
  

  systemOfCars = new CarSystem();
  systemOfCars.init();
}


// ----------------------------------------------------------------------
//  DRAW FUNCTION
// ----------------------------------------------------------------------

void draw() {

  // draw the background
  background(0, 10, 10);




  switch(scenario) {
  case 'C': 
   
    // Display the road
    cityBg.display();

    // Call all functions related to Cars
    systemOfCars.run();

    println("Scenario : C");  // Does not execute
    break;

  case 'P': 
    println("Scenario : P");  // Does not execute
    break;

  case 'H': 
    // Display the road
    highwayBg.display();
    println("Scenario : H");  // Does not execute
    break;

  case 'S': 
    println("Scenario : S");  // Does not execute
    break;

  default:             // Default executes if the case labels
    println("Scenario : None");   // don't match the switch parameter
    break;
  }




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

void mouseClicked() {  
  gui.mouseClicked();
}

