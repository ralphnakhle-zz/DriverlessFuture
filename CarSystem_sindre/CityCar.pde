// a subclass of car for city cars
class CityCar extends Car {

  CityCar() {
    super();

  }

  //---------------------------------------------------------------
  // method to create random origine and destinations for the cars
  //---------------------------------------------------------------

  PVector getDestination( PVector lastDestination) {
    PVector tempDestination = new PVector(0, 0);
    float randomX;
    float randomY;

    randomX = cityGridSize* round(random(-1, width/cityGridSize)+1);
    randomY = cityGridSize* round(random(-1, height/cityGridSize)+1);

    tempDestination = new PVector(randomX, randomY);

    // create a path to follow
    carPath = new CarPath(lastDestination, tempDestination, 10);

    return tempDestination;
  }
}

