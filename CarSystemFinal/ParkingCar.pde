// a subclass of car for parking cars
class ParkingCar extends Car {

  float parkingGrid = 40;
  float parkingWidth = width - 300;
  float parkingHeight = height - 200;
  PVector parkingPosition;
  int parkingId;

  // ----------------------------------------------------------------------
  //  parking car constructor
  // ----------------------------------------------------------------------
  ParkingCar(int id, PVector start, PVector parkingPosition_, int parkingId_ ) {
    super(id);
    // costum car size
    carRadius = 18;

    // give starting position for the car
    position = start.get();
    safeZone = 100;
    easing = 0.1;
    parked = false;
    parkingId = parkingId_;

    parkingPosition = parkingPosition_.get();

    carPath = new CarPath(position, parkingPosition, 30);
  }

  // a methode to get the parking ID 
  int getParkingId() {
    return parkingId;
  }

  // ----------------------------------------------------------------------
  //  costum update fonction
  // ----------------------------------------------------------------------
  void update() {
    //kill the cars in the top left corner
    if (position.x<50 &&position.y<80) {
      // remove car
      trashIt = true;
    }
    // if the car is not parked, update..
    if (!parked) {
      velocity.add(acceleration);
      // limit the velocity to the maximum speed alowd
      velocity.limit(speedLimit);
      // add the velocity to the position
      position.add(velocity);
      // reset acceleration
      acceleration.mult(0);
    }
    // if paked
    else if (parked) {
    }
  }


  // ----------------------------------------------------------------------
  // costum applyBehaviors for parking car
  // ----------------------------------------------------------------------

  void applyBehaviors(ArrayList<Car> Cars) {
    PVector separateForce = separate(Cars);
    // only follow path if the car is not parked
    if (!parked) {
      followPath();
    }
    applyForce(separateForce);
  }

  // ----------------------------------------------------------------------
  // costum path following
  // ----------------------------------------------------------------------
  void followPath() {
    // PVector for the desired position
    PVector desired;
    // A vector pointing from the position to the first point of the path
    desired = PVector.sub(carPath.points.get(pathIndex), position); 

    // if the car is close enought to the first point  and is still in the first section
    if (desired.mag()<20 && pathIndex == 1) {  
      pathIndex = 2;  
      desired = PVector.sub(carPath.points.get(pathIndex), position);
    }
    // if the car is close to the final target of the path
    if (desired.mag()<15 && pathIndex == 2) { 
      pathIndex = 3;  
      desired = PVector.sub(carPath.points.get(pathIndex), position);
    }
    if (desired.mag()<5 && pathIndex == 3) { 
      pathIndex = 1;  

      // if the car is in the exit lane
      if (position.y<80) {
        carPath = new CarPath(position, new PVector(0, 50), 0);
      }
      // else the car has arrived to his parking spot
      else {
        // parked and stop
        parked = true;
        velocity.mult(0);
      }
    }


    // Predict location 20 (arbitrary choice) frames ahead
    PVector predict = velocity.get();
    predict.normalize();
    predict.mult(20);
    PVector predictLoc = PVector.add(position, predict);
    // Look at the line segment
    PVector a = carPath.points.get(pathIndex-1);
    PVector b = carPath.points.get(pathIndex);

    // Get the normal point to that line
    PVector normalPoint = getNormalPoint(predictLoc, a, b);


    // Find target point a little further ahead of normal
    PVector dir = PVector.sub(b, a);
    dir.normalize();
    dir.mult(10);  // This could be based on velocity instead of just an arbitrary 10 pixels
    PVector target = PVector.add(normalPoint, dir);

    // How far away are we from the path?
    float distance = PVector.dist(predictLoc, normalPoint);

    seek(target);
  }


  // ----------------------------------------------------------------------
  // costum get destination for parking cars
  // ----------------------------------------------------------------------
  void getDestination( PVector lastDestination, PVector finalDestination) {
    parked = false;
    PVector tempDestination = finalDestination;

    // create a path to follow
    carPath = new CarPath(lastDestination, tempDestination, 0);
  }
  
  PVector getDestination( PVector lastDestination) {
    parked = false;
    PVector tempDestination = new PVector(0, 0);

    tempDestination = new PVector(lastDestination.x+30, 50);

    // create a path to follow
    carPath = new CarPath(lastDestination, tempDestination, 0);

    return tempDestination;
  }
}

