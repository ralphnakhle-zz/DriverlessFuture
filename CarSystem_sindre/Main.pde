

// ----------------------------------------------------------------------
// GLOBAL VARIABLES
// ----------------------------------------------------------------------

CarSystem systemOfCars;

CityBg cityBg ;

ParkingBg parkingBg;

HighwayBg highwayBg;

GUI gui ;

// Using this variable to toggle between drawing the lines or not
boolean debug = false;


char scenario;

// ----------------------------------------------------------------------
//  FUNCTIONS
// ----------------------------------------------------------------------
void setup() {
  frameRate(24);
  // canvas size HD
  size(1200, 700);
  // default scenario
  scenario = 'C';
  //initialize Gui 
  gui = new GUI();

  cityBg = new CityBg();
  highwayBg = new HighwayBg(40);
  parkingBg = new ParkingBg();

  // create a system of cars
  systemOfCars = new CarSystem(scenario);
  // initialise the system of cars
  systemOfCars.init();
}


// ----------------------------------------------------------------------
//  DRAW FUNCTION
// ----------------------------------------------------------------------

void draw() {

  // draw the background
  background(0, 10, 10);

  // display the right background
  switch(scenario) {
  case 'C': 
    // Display the road
    cityBg.display();
    systemOfCars.run();
    cityBg.displayBuildings();

    break;

  case 'P': 
    // println("Scenario : P");  
    parkingBg.display();
    systemOfCars.run();

    break;

  case 'H': 
    // Display the road
    highwayBg.display();
    systemOfCars.run();

    break;

  case 'S': 
    break;

  default:             
    break;
  }


  // run the car system
  // systemOfCars.run();
  //display Gui
  gui.display();
}


// press space bar to able and disable collision and target lines.
public void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
}

void mouseClicked() {  
  gui.activateToggle();
  gui.mouseEvent();
  int controlMargin = width-width/10+10;

  if (mouseX >= controlMargin && mouseX <= controlMargin+50 && mouseY >= 50 && mouseY <= 340) {

    systemOfCars = new CarSystem(scenario);
    systemOfCars.init();
  }
}

