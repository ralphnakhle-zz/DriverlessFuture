// a subclass of car for parking cars
class ParkingCar extends Car {

  float parkingGrid = 40;
  float parkingWidth = width - 300;
  float parkingHeight = height - 200;
  boolean parked = false;
  PVector parkingPosition;

  ParkingCar(PVector start, PVector parkingPosition_) {
    carRadius = 18;
    parkingPosition = parkingPosition_;
    // give starting position for the car
    position = start;

    safeZone = 100;

    carPath = new CarPath(position, parkingPosition, 0);
  }

  // update methode
  void update() {
    if (!parked) {
      velocity.add(acceleration);
      // limit the velocity to the maximum speed alowd
      velocity.limit(speedLimit);
      // add the velocity to the position
      position.add(velocity);
      // reset acceleration
      acceleration.mult(0);
    }
  }


  void followPath() {
    // PVector for the desired position
    PVector desired;
    // A vector pointing from the position to the first point of the path
    desired = PVector.sub(carPath.points.get(pathIndex), position); 

    // if the car is close enought to the first point  and is still in the first section
    if (desired.mag()<30 && pathIndex == 1) {  
      pathIndex = 2;  
      desired = PVector.sub(carPath.points.get(pathIndex), position);
    }
    // if the car is close to the final target of the path
    if (desired.mag()<10 && pathIndex == 2) { 
      parked = true;
      velocity.mult(0);
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


  PVector getDestination( PVector lastDestination) {
    return null;
  }
}

