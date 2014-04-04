

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
//verify if needed
int gridSize = 1;
int cityGridSize = 180;

// ----------------------------------------------------------------------
//  FUNCTIONS
// ----------------------------------------------------------------------
void setup() {
//size(displayWidth, displayHeight);
size(900, 700);
  scenario = 'C';
  //initialize Gui 
  gui = new GUI();

  cityBg = new CityBg();
  highwayBg = new HighwayBg(40);
  parkingBg = new ParkingBg();

  systemOfCars = new CarSystem(scenario);
  systemOfCars.init();
  frameRate(30);
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
    parkingBg.display();
    systemOfCars.run();
    break;

  case 'H': 
    // Display the road
    highwayBg.display();
    systemOfCars.run();
    break;

  case 'S': 
  background(25, 10, 10);
    cityBg.display();
    systemOfCars.run();
    cityBg.displayBuildings();
    break;

  default:             
    break;
  }


  //display Gui
  gui.display();
  gui.displayNumber();

}


// press space bar to able and disable collision and target lines.
public void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
}

void mouseReleased() {  
  gui.mouseEvent();
  gui.activateToggle();
  int controlMargin = width-width/10+10;

  if (mouseX >= controlMargin && mouseX <= controlMargin+50 && mouseY >= 50 && mouseY <= 340) {

    systemOfCars = new CarSystem(scenario);
    systemOfCars.init();
  }
  
}

