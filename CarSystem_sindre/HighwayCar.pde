// a subclass of car for city cars
class HighwayCar extends Car {

  HighwayCar() {
    super();
  }

  //---------------------------------------------------------------
  // method to create random origine and destinations for the cars
  //---------------------------------------------------------------

  PVector getDestination( PVector lastDestination) {
    PVector tempDestination = new PVector(0, 0);
    float randomX;
    float randomY;
    int gridSize = 180;
    randomX = gridSize* round(random(-1, width/gridSize)+1);
    randomY = gridSize* round(random(-1, height/gridSize)+1);

    tempDestination = new PVector(randomX, randomY);

    // create a path to follow
    carPath = new CarPath(lastDestination, tempDestination, 10);

    return tempDestination;
  }
}

