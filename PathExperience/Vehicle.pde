// Path Following
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code

// Vehicle class

class Vehicle {

  // All the usual stuff
  PVector position;
  PVector velocity;
  PVector acceleration;
  PVector carDestination;
  float r;
  float maxsteer;    // Maximum steering force
  float maxspeed;    // Maximum speed



    // Constructor initialize all values
  Vehicle( PVector l, float ms, float mf, PVector t) {
    position = l.get();
    carDestination = t;
    r = 4.0;
    maxspeed = ms;
    maxsteer = mf;
    acceleration = new PVector(0, 0);
    velocity = new PVector(maxspeed, 0);
  }
  // Main "run" function
  public void run() {
    update();
    borders();
    render();
  }

  // ----------------------------------------------------------------------
  //  Go towards destination code
  // ----------------------------------------------------------------------
  // A method that calculates a steering force towards a target

  PVector seekTarget() {
    PVector steer = new PVector(0, 0);

    // A vector pointing from the position to the target
    PVector desired = PVector.sub(carDestination, position); 

    PVector tempTarget;
    if (desired.x > desired.y) {
      tempTarget = new PVector(carDestination.x, position.y);
    }
    else {
      tempTarget = new PVector(position.x, carDestination.y);
    }

    // Normalize desired and scale to maximum speed
    tempTarget.normalize();
    tempTarget.mult(maxspeed);
    // Steering = Desired minus velocity
    steer = PVector.sub(tempTarget, velocity);
    // Limit to maximum steering force
    steer.limit(maxsteer*.5);

    // return steer Force
    return steer;
  }


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


  // Method to update position
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    position.add(velocity);
    // Reset accelertion to 0 each cycle
    acceleration.mult(0);
  }

  void applyForce(PVector force) {
    // We could add mass here if we want A = F / M
    acceleration.add(force);
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

  // A method that calculates and applies a steering force towards a target
  // STEER = DESIRED MINUS VELOCITY
  void seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target

    // If the magnitude of desired equals 0, skip out of here
    // (We could optimize this to check if x and y are 0 to avoid mag() square root
    if (desired.mag() == 0) return;

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxsteer);  // Limit to maximum steering force
    applyForce(steer);
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    fill(175);
    stroke(0);
    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape(PConstants.TRIANGLES);
    vertex(0, -r*2);
    vertex(-r, r*2);
    vertex(r, r*2);
    endShape();
    popMatrix();
  }

  // Wraparound
  void borders() {
    if (position.x < -r) position.x = width+r;
    //if (position.y < -r) position.y = height+r;
    if (position.x > width+r) position.x = -r;
    //if (position.y > height+r) position.y = -r;
  }
}

