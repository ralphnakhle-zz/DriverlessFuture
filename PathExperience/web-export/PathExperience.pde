
// starting code:
// Path Following
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code

// Via Reynolds: // http://www.red3d.com/cwr/steer/PathFollow.html

// A path object (series of connected points)
Path path;

// Two vehicles
Vehicle car1;
Vehicle car2;
Vehicle car3;

void setup() {
  size(900, 700);
  smooth();

  // Call a function to generate new Path object
  newPath();

  // Each vehicle has different maxspeed and maxsteer for demo purposes
  car1 = new Vehicle(new PVector(width/2, height/4), 5, 0.8, new PVector(width/2, height*.90));
  // car2 = new Vehicle(new PVector(width/2, height/3), 8, 0.9, new PVector(width, height*.75));
  // car3 = new Vehicle(new PVector(width/2, height/2), 5, 0.8, new PVector(width/2, height*.75));
}

void draw() {
  background(255);
  // Display the path
  path.display();
  // The boids follow the path
  car1.follow(path);
  // car2.follow(path);
  // car3.follow(path);

  car1.applyForce(car1.seekTarget());
  // car2.applyForce(car2.seekTarget());
  //car3.applyForce(car3.seekTarget());


  // Call the generic run method (update, borders, display, etc.)
  car1.run();
  // car2.run();
  // car3.run();

  // Instructions
  // fill(0);
  // text("Hit space bar to toggle debugging lines.\nClick the mouse to generate a new path.", 10, height-30);
}

void newPath() {
  // A path is a series of connected points
  // A more sophisticated path might be a curve
  // loopPath();

  gridPath(160);
}
// create grid patern
void gridPath(int spacer) {


  path = new Path();
  for ( int g = 0; g <width+spacer/spacer; g++) {
    path.addPoint(spacer*g, 0);
    path.addPoint(spacer*g, height);
    path.addPoint(spacer*(g+1), height);
  }
  for ( int g = 0; g <height+spacer/spacer; g++) {
    path.addPoint(0, spacer*g);
    path.addPoint(width, spacer*g);
    path.addPoint(width, spacer*(g+1));
  }
}
void loopPath() {

  int spacer = 50;
  path = new Path();
  path.addPoint(spacer, 240);
  path.addPoint(170, 200);
  path.addPoint(width-170, height-200);
  path.addPoint(width-spacer, height-240);
  path.addPoint(width-20, height/2);
  path.addPoint(width-spacer, 240);
  path.addPoint(width-170, 200);
  path.addPoint(170, height-200);
  path.addPoint(spacer, height-240);
  path.addPoint(20, height/2);
  path.addPoint(spacer, 240);
}

// Path Following
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code

class Path {

  // A Path is an arraylist of points (PVector objects)
  ArrayList<PVector> points;
  // A path has a radius, i.e how far is it ok for the boid to wander off
  float radius;

  Path() {
    // Arbitrary radius of 20
    radius = 5;
    points = new ArrayList<PVector>();
  }

  // Add a point to the path
  void addPoint(float x, float y) {
    PVector point = new PVector(x, y);
    points.add(point);
  }

  // Draw the path
  void display() {
    // Draw thick line for radius
    stroke(175);
    strokeWeight(radius*2);
    noFill();

    for (int v = 0; v < points.size()-1; v++ ) {
      line(points.get(v).x, points.get(v).y, points.get(v+1).x, points.get(v+1).y);
    }

    // Draw thin line for center of path
    stroke(0);
    strokeWeight(1);
    noFill();
    for (int v = 0; v < points.size()-1; v++ ) {
      line(points.get(v).x, points.get(v).y, points.get(v+1).x, points.get(v+1).y);
    }

  }
}


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
      }*/

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

  // ----------------------------------------------------------------------
  // ----------------------------------------------------------------------
  // ----------------------------------------------------------------------
  // ----------------------------------------------------------------------

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


