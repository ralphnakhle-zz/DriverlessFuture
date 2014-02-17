//importing controll P5 Library
import controlP5.*;
ControlP5 cp5;

// ----------------------------------------------------------------------
// GLOBAL VARIABLES
// ----------------------------------------------------------------------
// set the total numbers of Car 

// keep track of number of accident
int accident = 0;


CarSystem systemOfCars = new CarSystem();

// Using this variable to toggle between drawing the lines or not
boolean debug = true;

// ----------------------------------------------------------------------
//  FUNCTIONS
// ----------------------------------------------------------------------
void setup() {
  cp5 = new ControlP5(this);
  gui = new GUI();
  size(900, 700);
  systemOfCars.init();

}

// ----------------------------------------------------------------------
//  GUI FUNCTIONS 
// ----------------------------------------------------------------------



// Initializing gui
GUI gui;

void CarKnob(int CarNumber) {
  if (CarNumber > 50){
   CarNumber = 50; 
  }
  systemOfCars.setCarPopulation(CarNumber); 
}

void SpeedKnob(float CarSpeed) {
  systemOfCars.setCarSpeedLimit(CarSpeed);
}

void SteeringKnob(float CarSteer) {
  systemOfCars.setCarSteerLimit(CarSteer);
}

void RepulsionForce(int RepulsionForce) {
  systemOfCars.setRepulsionLimit(RepulsionForce);
}

// ----------------------------------------------------------------------
//  DRAW FUNCTION
// ----------------------------------------------------------------------

void draw() {

  // draw the background
  background(20, 45, 55);
  

  // draw the Gui bar
  fill(255, 50);
  rect(0, 0, width, 80);
  
  // Call all functions related to Cars
  systemOfCars.checkCarCollisionInSystem();
  systemOfCars.applyForces();
  systemOfCars.run();
  fill(255);
text("Press space bar to enable and disable toggle lines", 20, height-20);
}

// press space bar to able and disable collision and target lines.
public void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
}
