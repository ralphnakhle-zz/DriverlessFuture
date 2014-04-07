
// ----------------------------------------------------------------------
// GLOBAL VARIABLES
// ----------------------------------------------------------------------
// set the total numbers of Car 
int CarPopulation =20;

// Vector for origine
PVector origine;
// Vector for destination
PVector destination;

// keep track of number of accident
int accident = 0;


// array containing the Cars
Car[] CarArray = new Car[CarPopulation];

// ----------------------------------------------------------------------
//  FUNCTIONS
// ----------------------------------------------------------------------
void setup() {
  size(900, 700);

  // fill the Car array
  for (int i = 0; i < CarPopulation; i++) {
    // get random Origine
    origine = new PVector(random(0, width), random(0, height));
    // get random Destination
    destination =new PVector(random(0, width), random(0, height));

    // create new Car 
    CarArray[i] = new Car(origine, destination);
  }
}

void draw() {
  // draw the background
  background(20, 45, 55);

  for (int i = 0; i < CarArray.length; i++) {
    // check the collision between every Car
    for (int c = 0; c < CarArray.length; c++) {
      // dont check against itself
      if (i!=c) {
        CarArray[i].checkCollision(CarArray[c]);
      }
    }

    // seek target
    CarArray[i].applyForce(CarArray[i].seek());

    // update position
    CarArray[i].update();
    // display the Car
    CarArray[i].display();
  }
}

