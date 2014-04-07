
/*
 * Driverless Future
 *
 * (c) 2014 Sindre Ulvik Peladeau & Ralph Nakhle --
 * info @ www.sindreup.com and www.ralphnakhle.com
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 */


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
//size(displayWidth, 1035);
size(displayWidth, displayHeight);

//size(900, 700);
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
    background(10, 20, 20);

    parkingBg.display();
    systemOfCars.run();
    break;

  case 'H': 
      background(10, 10, 20);

    // Display the road
    highwayBg.display();
    systemOfCars.run();
    break;

  case 'S': 
  background(10, 15, 25);
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
  int controlMargin = width-width/10+60;

  if (mouseX >= controlMargin && mouseX <= controlMargin+50 && mouseY >= 50 && mouseY <= 340) {

    systemOfCars = new CarSystem(scenario);
    systemOfCars.init();
  }
  
}

