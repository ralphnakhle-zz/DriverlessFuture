
abstract class Car {

  // Car position
  PVector position;

  //  change in position
  PVector velocity = new PVector(0, 0);
  // change in velocity
  PVector acceleration= new PVector(0, 0);

  // Radius of the Car
  float carRadius = 6;

  // car safe zone
  float safeZone;

  // variable for speed limit
  float speedLimit = 3;

  // Maximum steering force
  float steerLimit = 0.3;  

  // car color
  color carColor = color(100);


  // car target and origine
  PVector carDestination;

  // car Angle
  float carAngle = velocity.heading2D() + PI/2;
  float targetCarAngle = 0;
  float easing = 0.2;

  //car path
  CarPath carPath;
  int pathIndex = 1;



  // constructor
  Car() {
    // give starting position for the car
    position = getDestination(new PVector(0, 0));
    // get a first destination for the car
    carDestination = getDestination(position);
  }

  // update methode
  void update() {
    velocity.add(acceleration);
    // limit the velocity to the maximum speed alowd
    velocity.limit(speedLimit);
    // add the velocity to the position
    position.add(velocity);
    // reset acceleration
    acceleration.mult(0);
  }


  void applyBehaviors(ArrayList<Car> Cars) {
    PVector separateForce = separate(Cars);
    separateForce.mult(1.6);
    followPath();
    applyForce(separateForce);
  }


  // apply Force methode
  void applyForce(PVector force) {
    acceleration.add(force);
  }


  // ----------------------------------------------------------------------
  //  Car display
  // ----------------------------------------------------------------------  
  void display() {
    // draw debuging info
    if (debug) {
      stroke(255, 60, 0, 80);

      strokeWeight(3);
      for (int v = 0; v < carPath.getSize()-1; v++ ) {
        line(carPath.points.get(v).x, carPath.points.get(v).y, carPath.points.get(v+1).x, carPath.points.get(v+1).y);
      }
    }
    // draw car

    fill(carColor);
    noStroke();

    carAngle = velocity.heading() + PI/2;

    float dir = (carAngle - targetCarAngle) / TWO_PI;
    dir -= round( dir );
    dir *= TWO_PI;

    targetCarAngle += dir * easing;


    pushMatrix();
    translate(position.x, position.y);
    rotate(targetCarAngle);
    beginShape();
    rectMode(CENTER);
    rect(0, carRadius/2, carRadius, carRadius*2);
    if (velocity.mag() < speedLimit/2) {
      fill(255, 0, 0);
    }
    else {      
      fill(255, 150, 150);
    }
    rect(0, carRadius*1.25, carRadius, carRadius/3);
    fill(255);
    rect(0, 0-carRadius/2, carRadius, carRadius/3);
    endShape(CLOSE);
    popMatrix();
  }



  // ----------------------------------------------------------------------
  //  Go towards destination code & Path following
  // ----------------------------------------------------------------------
  // A method that calculates a steering force towards a target and following a path

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
    if (desired.mag()<30 && pathIndex == 2) { 
      // generate new destination, send the real end as a starting point 
      getDestination(carPath.points.get(3));
      // reset the path index to 1
      pathIndex = 1;
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

  // used for the path following code
  void seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // If the magnitude of desired equals 0, skip out of here
    if (desired.mag() == 0) return;

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(speedLimit);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(steerLimit);  // Limit to maximum steering force
    applyForce(steer);
  }


  // ----------------------------------------------------------------------
  //  Interaction with other cars
  // ----------------------------------------------------------------------
  // Separation
  // Method checks for nearby vehicles and steers away
  PVector separate (ArrayList<Car> cars) {
    // calculate the safe zone
    safeZone = 60;
    float safeAngle = 60;
    PVector sum = new PVector();


    int count = 0;
    // For every boid in the system, check if it's too close
    for (Car other : cars) {
      // get the distance between the two cars
      float d = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)

      if ((d > 0) && (d < safeZone)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);
        diff.normalize();
        float mainCarAngle = velocity.heading()+ PI/2;
        // convert car angle to degree
        mainCarAngle = map(mainCarAngle, -PI, PI, 0, 360);


       // if (diff.heading()+ PI/2 < mainCarAngle+safeAngle && diff.heading()+ PI/2 > mainCarAngle-safeAngle) {
          diff.div(d);        // Weight by distance
          sum.add(diff);
          count++;            // Keep track of how many
      //  }
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
      sum.limit(steerLimit/2);
    }
    return sum;
  }


  //---------------------------------------------------------------
  // method to create random origine and destinations for the cars
  //---------------------------------------------------------------

  abstract PVector getDestination( PVector lastDestination); 

  //----------------------------------------------------------------------
  // method to set car speed limit - so it can be accessed from the Car System then the Gui - 
  //----------------------------------------------------------------------

  void setCarSpeedLimit(float incomingCarSpeedLimit)
  {
    speedLimit = incomingCarSpeedLimit;
  }

  //----------------------------------------------------------------------
  // method to set car steering limit - so it can be accessed from the Car System then the Gui
  //----------------------------------------------------------------------

  void setCarSteerLimit(float incomingCarSteerLimit)
  {
    steerLimit = incomingCarSteerLimit;
  }
}

