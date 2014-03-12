
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

  // variable for speed limit
  float speedLimit = 3;

  // Maximum steering force
  float steerLimit = 0.3;  

  // car color
  color carColor = color(100);

  // check if the car had an accident
  boolean accidented = false;

  // origin
  PVector carOrigine;
  PVector carDestination;

  // car Angle
  float carAngle = velocity.heading2D() + PI/2;
  float targetCarAngle = 0;
  float easing = 0.2;




  // constructor
  Car() {
    position = getDestination();
    carDestination = getDestination();
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
    PVector seekForce = seekDestinationForce();
    separateForce.mult(2);

    applyForce(separateForce);
    applyForce(seekForce);
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
      strokeWeight(1);
      stroke(255, 60, 0, 150);
      line(position.x, position.y, carDestination.x, carDestination.y);
      // draw target lines and dot
      fill(255, 60, 0);
      ellipse(carDestination.x, carDestination.y, carRadius*0.5, carRadius*0.5);
    }
    // draw car

    fill(carColor);
    noStroke();

    carAngle = velocity.heading2D() + PI/2;

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
  //  Go towards destination code
  // ----------------------------------------------------------------------
  // A method that calculates a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  // Daniel Shiffman <http://www.shiffman.net>
  PVector seekDestinationForce() {
    PVector steer = new PVector(0, 0);
    // A vector pointing from the position to the target
    PVector desired = PVector.sub(carDestination, position); 
    PVector tempDesired;

    if (abs(desired.x)>= abs(desired.y)) {
      tempDesired = new PVector(desired.x, 0);
    }

    else {
      tempDesired = new PVector(0, desired.y);
    }
    // stroke(255);
    //line(position.x, position.y, tempDesired.x, tempDesired.y);
    // check it the car has arrived to destination
    if (desired.mag()<carRadius*3) {
      carDestination = getDestination();
    }

    // Normalize desired and scale to maximum speed
    tempDesired.normalize();
    tempDesired.mult(speedLimit);
    // Steering = Desired minus velocity
    steer = PVector.sub(tempDesired, velocity);
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
/*
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
*/
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
    if (worldRecord > p.radius/2) {
      PVector offset = new PVector(10, 10);
      String carDirection = getDirection(velocity.get());
      if (carDirection == "West" ||carDirection == "South" ) {
        target.sub(offset);
      }

      if (carDirection == "East" ||carDirection == "North" ) {
        target.add(offset);
      }

      seekPath(target);

      if (debug) {
        stroke(200);
        line(target.x, target.y, position.x, position.y);
      }
    }
  }

  // find the direction the car is going
  String getDirection(PVector currentVelocity) {

    String direction = "?";
    float currentAngle = abs(currentVelocity.heading());
    if (currentAngle > 0 - HALF_PI/2 && currentAngle <= HALF_PI/2 ) {
      direction = "East" ;
    }
    else if (currentAngle > HALF_PI/2 && currentAngle <= PI-HALF_PI/2) {
      direction = "South" ;
    }
    else if (currentAngle > PI-HALF_PI/2 || currentAngle <= 0-PI+HALF_PI/2) {
      direction = "West" ;
    }
    else if (currentAngle < 0-(HALF_PI/2) && currentAngle > 0- PI+HALF_PI/2) {
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

  // used for the path following code
  void seekPath(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // If the magnitude of desired equals 0, skip out of here
    if (desired.mag() == 0) return;

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(speedLimit);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(steerLimit*3);  // Limit to maximum steering force
    applyForce(steer);
  }


  // ----------------------------------------------------------------------
  //  Interaction with other cars
  // ----------------------------------------------------------------------
  // Separation
  // Method checks for nearby vehicles and steers away
  PVector separate (ArrayList<Car> cars) {
    // calculate the safe zone according to speed
    safeZone = 25;

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
  // method to create random origine and destinations for the cars
  //---------------------------------------------------------------
  int selector = 0;


  PVector getDestination() {

    PVector tempDestination = new PVector(0, 0);
    float randomP;
    // select a random option 
    selector = int(random(0, 4));

    //Destination North
    if (selector ==0) {
      randomP = gridSize* round(random(width/gridSize));
      tempDestination = new PVector(randomP, 10);
    }
    //Destination east
    else if (selector ==1) {
      randomP = gridSize* round(random(height/gridSize));

      tempDestination = new PVector(width-10, randomP);
    }
    //Destination south
    else if (selector ==2) {
      randomP = gridSize* round(random(width/gridSize));

      tempDestination = new PVector(randomP, height-10);
    }
    //Destination west
    else {
      randomP = gridSize* round(random(height/gridSize));
      tempDestination = new PVector(10, randomP);
    }

    return tempDestination;
  }
}

