// a subclass of car for city cars
class CityCar extends Car {

  float gridSize;
  CityBg cityBg ;

  // ----------------------------------------------------------------------
  //  city car constructor
  // ----------------------------------------------------------------------
  CityCar(int id) {
    super(id);
    cityBg = new CityBg();
  }

  // ----------------------------------------------------------------------
  // apply behavior to interact with ambulances
  // ----------------------------------------------------------------------
  void applyBehaviors(ArrayList<Car> Cars, ArrayList<Car> Ambulance) {
    PVector separateForce = separate(Cars);
    PVector separateFromAmbulanceForce = separateFromAmbulance(Ambulance);

    followPath();
    applyForce(separateForce);
    applyForce(separateFromAmbulanceForce);
  }


  // ----------------------------------------------------------------------
  //  Interaction with ambulance
  // ----------------------------------------------------------------------
  // Separation
  // Method checks for nearby vehicles and steers away
  PVector separateFromAmbulance (ArrayList<Car> ambulance) {
    // calculate the safe zone
    safeZone = 80;
    PVector sForce = new PVector(0, 0);
    float multiplier;

    for (int a =0; a< ambulance.size(); a++) {

      // get the distance between the two cars
      float distance = PVector.dist(position, ambulance.get(a).position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)

      if (distance < safeZone) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, ambulance.get(a).position);
        // check if the other car is in front of this car
        diff.normalize();
        multiplier = 80/distance;
        constrain(multiplier, 0, 5);
        diff.mult(multiplier);
        // if the car is straight in front..
        sForce = diff.get();

        if (sForce.mag() > velocity.mag()) {
          sForce = velocity.get();
          sForce.mult(-1);
        }
      }
    }
    return sForce;
  }

  //---------------------------------------------------------------
  // method to create random origine and destinations for the cars
  //---------------------------------------------------------------

  PVector getDestination( PVector lastDestination) {
    PVector tempDestination = new PVector(0, 0);
    float randomX;
    float randomY;
    // gridSize = cityBg.getGridSize();
    gridSize = 180;
    randomX = gridSize* round(random(-1, width/gridSize)+1);
    randomY = gridSize* round(random(-1, height/gridSize)+1);

    tempDestination = new PVector(randomX, randomY);

    // create a path to follow
    carPath = new CarPath(lastDestination, tempDestination, 10);

    return tempDestination;
  }
}

