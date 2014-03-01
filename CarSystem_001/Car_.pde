
class Car {

  // Car position
  PVector position;
  //  change in position
  PVector velocity = new PVector(0, 0);
  // change in velocity
  PVector acceleration= new PVector(0, 0);

  // Radius of the Car
  float carRadius = 8;

  // car safe zone
  float safeZone;

  // repulse Constant
  float repulseC = 6;

  // variable for speed limit
  float speedLimit = 1;
  // Maximum steering force
  float steerLimit = 0.2;    
  // car color
  color carColor = color(250, 220, 0);

  // check if the car has arrived at destination
  boolean arrived = false;

  // check if the car had an accident
  boolean accidented = false;

  // origin
  PVector carOrigine;
  PVector carDestination;

  //Car Population 
  //int CarPopulation = 20;

  // constructor
  Car(PVector tempOrigine, PVector tempDestination) {

    position = tempOrigine;
    carDestination = tempDestination;
  }


  // update methode
  void update() {
    velocity.add(acceleration);
    // limit the velocity to the maximum speed alowd
    velocity.limit(speedLimit);
    // add the velocity to the position
    position.add(velocity);
    acceleration.mult(0);
  }


  void applyBehaviors(ArrayList<Car> Cars) {
    PVector separateForce = separate(Cars);
    //  PVector seekForce = seek(new PVector(mouseX,mouseY));
    separateForce.mult(2);
    //  seekForce.mult(1);
    applyForce(separateForce);
  }


  // apply Force methode
  void applyForce(PVector force) {
    acceleration.add(force);
  }

  // display the Car
  void display() {
    // draw target lines and dot
    fill(255, 60, 0);
    ellipse(carDestination.x, carDestination.y, carRadius*0.5, carRadius*0.5);
    if (debug) {
      stroke(255, 60, 0);
      line(position.x, position.y, carDestination.x, carDestination.y);
    }
    // draw car
    noStroke();
    // chose the color for the car
    if (accidented) {
      fill(255, 60, 0);
    }
    else if (arrived) {
      fill(20, 205, 100);
    }
    else {
      fill(carColor);
    }

    ellipse(position.x, position.y, carRadius*2, carRadius*2);

    if (debug) {
      // safe zone
      fill(255, 10);
      ellipse(position.x, position.y, safeZone*2, safeZone*2);
    }
  }
  // used for the path following code
  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  void seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // If the magnitude of desired equals 0, skip out of here
    // (We could optimize this to check if x and y are 0 to avoid mag() square root
    if (desired.mag() == 0) return;

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(speedLimit);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(steerLimit*2);  // Limit to maximum steering force
    applyForce(steer);
  }

  // ----------------------------------------------------------------------
  //  Go towards destination code
  // ----------------------------------------------------------------------
  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  // Daniel Shiffman <http://www.shiffman.net>
  PVector seek() {
    PVector steer = new PVector(0, 0);
    // A vector pointing from the position to the target
    PVector desired = PVector.sub(carDestination, position); 

    // check it the car has arrived to destination
    if (desired.mag()<carRadius) {
      arrived = true;
      // restet the speed
      steer.mult(0);
      velocity.mult(0);
      acceleration.mult(0);
    }

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(speedLimit);
    // Steering = Desired minus velocity
    steer = PVector.sub(desired, velocity);
    // Limit to maximum steering force
    steer.limit(steerLimit);

    // return steer Force
    return steer;
  }

  // ----------------------------------------------------------------------
  //  Path Folowing
  // ----------------------------------------------------------------------
  // This function implements Craig Reynolds' path following algorithm
  // http://www.red3d.com/cwr/steer/PathFollow.html
  void follow(Path p) {

    // Predict position 25 (arbitrary choice) frames ahead
    PVector predict = velocity.get();
    predict.normalize();
    predict.mult(20);
    PVector predictLoc = PVector.add(position, predict);

    // Now we must find the normal to the path from the predicted position
    // We look at the normal for each line segment and pick out the closest one
    PVector normal = null;
    PVector target = null;
    float worldRecord = 1000000;  // Start with a very high record distance that can easily be beaten

    // Loop through all points of the path
    for (int i = 0; i < p.points.size()-1; i++) {

      // Look at a line segment
      PVector a = p.points.get(i);
      PVector b = p.points.get(i+1);

      // Get the normal point to that line
      PVector normalPoint = getNormalPoint(predictLoc, a, b);

      // Look at the direction of the line segment so we can seek a little bit ahead of the normal
      PVector pathDirection = PVector.sub(b, a);
      pathDirection.normalize();

      // check for out of segment normalPoint
      String generalDirection = getDirection(pathDirection);
      if (generalDirection == "East") {
        if (normalPoint.x < a.x ) {
          normalPoint = a.get();
        }
        if (normalPoint.x > b.x ) {
          normalPoint = b.get();
        }
      }
      if (generalDirection == "West") {
        if (normalPoint.x < b.x ) {
          normalPoint = b.get();
        }
        if (normalPoint.x > a.x ) {
          normalPoint = a.get();
        }
      }
      if (generalDirection == "North") {
        if (normalPoint.y > b.y ) {
          normalPoint = b.get();
        }
        if (normalPoint.y < a.y ) {
          normalPoint = a.get();
        }
      }  
      if (generalDirection == "South") {
        if (normalPoint.y > a.y ) {
          normalPoint = a.get();
        }
        if (normalPoint.y < b.y ) {
          normalPoint = b.get();
        }
      }

      // How far away are we from the path?
      float distance = PVector.dist(predictLoc, normalPoint);

      // Did we beat the record and find the closest line segment?
      if (distance < worldRecord) {
        worldRecord = distance;
        // If so the target we want to steer towards is the normal
        normal = normalPoint;
        target = normalPoint.get();
        target.add(pathDirection);
      }
    }

    // Only if the distance is greater than the path's radius do we bother to steer
    if (worldRecord > p.radius) {
      seek(target);
    }
  }

  // find the direction the car is going
  String getDirection(PVector currentVelocity) {

    String direction = "?";
    float currentAngle = abs(currentVelocity.heading());
    if (currentAngle < TWO_PI-HALF_PI/2 || currentVelocity.heading() <= HALF_PI/2) {
      direction = "East" ;
    }
    if (currentAngle > HALF_PI/2 && currentVelocity.heading() <= PI-HALF_PI/2) {
      direction = "South" ;
    }
    if (currentAngle > PI-HALF_PI/2 && currentVelocity.heading() <= PI+HALF_PI/2) {
      direction = "West" ;
    }
    if (currentAngle > PI+HALF_PI/2 && currentVelocity.heading() <= TWO_PI-HALF_PI/2) {
      direction = "North" ;
    }

    return direction ;
  }


  // A function to get the normal point from a point (p) to a line segment (a-b)
  // This function could be optimized to make fewer new Vector objects
  PVector getNormalPoint(PVector p, PVector a, PVector b) {
    // Vector from a to p
    PVector ap = PVector.sub(p, a);
    // Vector from a to b
    PVector ab = PVector.sub(b, a);
    ab.normalize(); // Normalize the line
    // Project vector "diff" onto line by using the dot product
    ab.mult(ap.dot(ab));
    PVector normalPoint = PVector.add(a, ab);
    return normalPoint;
  }

  // ----------------------------------------------------------------------
  //  Interaction with other cars
  // ----------------------------------------------------------------------
  // Separation
  // Method checks for nearby vehicles and steers away
  PVector separate (ArrayList<Car> cars) {
    // calculate the safe zone according to speed
    safeZone = velocity.mag()*40;

    PVector sum = new PVector();
    int count = 0;
    // For every boid in the system, check if it's too close
    for (Car other : cars) {
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)
      if ((d > 0) && (d < safeZone)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        diff.div(d);        // Weight by distance
        sum.add(diff);
        count++;            // Keep track of how many
      }
    }
    // Average -- divide by how many
    if (count > 0) {
      sum.div(count);
      // Our desired vector is the average scaled to maximum speed
      sum.normalize();
      sum.mult(speedLimit);
      // Implement Reynolds: Steering = Desired - Velocity
      sum.sub(velocity);
      sum.limit(steerLimit);
    }
    return sum;
  }




  //---------------------------------------------------------------
  // Functions for mapping Speed, Steering and Repulsion forces to the knob values.
  //---------------------------------------------------------------

  void setCarSpeedLimit(float incomingCarSpeedLimit)
  {
    speedLimit = incomingCarSpeedLimit;
  }

  void setCarSteerLimit(float incomingCarSteerLimit)
  {
    steerLimit = incomingCarSteerLimit;
  }

  void setRepulsionLimit(float incomingRepulsionForce) {
    repulseC = incomingRepulsionForce;
  }
}

