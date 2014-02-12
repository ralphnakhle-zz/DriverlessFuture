// Path Following
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code

// Via Reynolds: // http://www.red3d.com/cwr/steer/PathFollow.html

// Using this variable to decide whether to draw all the stuff
boolean debug = false;

// A path object (series of connected points)
Path path;

// Two vehicles
Vehicle car1;
Vehicle car2;

void setup() {
  size(800, 600);
  smooth();

  // Call a function to generate new Path object
  newPath();

  // Each vehicle has different maxspeed and maxforce for demo purposes
  car1 = new Vehicle(new PVector(0, height/2), 8, 0.8);
  car2 = new Vehicle(new PVector(0, height/2-10), 4, 0.6);
}

void draw() {
  background(255);
  // Display the path
  path.display();
  // The boids follow the path
  car1.follow(path);
  car2.follow(path);
  // Call the generic run method (update, borders, display, etc.)
  car1.run();
  car2.run();

  // Instructions
  fill(0);
  text("Hit space bar to toggle debugging lines.\nClick the mouse to generate a new path.", 10, height-30);
}

void newPath() {
  // A path is a series of connected points
  // A more sophisticated path might be a curve
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

public void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
}

public void mousePressed() {
  newPath();
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
    radius = 20;
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
  PVector location;
  PVector velocity;
  PVector acceleration;
  float r;
  float maxforce;    // Maximum steering force
  float maxspeed;    // Maximum speed



    // Constructor initialize all values
  Vehicle( PVector l, float ms, float mf) {
    location = l.get();
    r = 4.0;
    maxspeed = ms;
    maxforce = mf;
    acceleration = new PVector(0, 0);
    velocity = new PVector(maxspeed, 0);
  }

  // Main "run" function
  public void run() {
    update();
    borders();
    render();
  }


  // This function implements Craig Reynolds' path following algorithm
  // http://www.red3d.com/cwr/steer/PathFollow.html
  void follow(Path p) {

    // Predict location 25 (arbitrary choice) frames ahead
    PVector predict = velocity.get();
    predict.normalize();
    predict.mult(25);
    PVector predictLoc = PVector.add(location, predict);

    String direction = getDirection(velocity);


    // Now we must find the normal to the path from the predicted location
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


      ///////////////////////////////////////////////////////////////////////////////////////////////
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
        if (normalPoint.y < b.y ) {
          normalPoint = b.get();
        }
        if (normalPoint.y > a.y ) {
          normalPoint = a.get();
        }
      }  
      if (generalDirection == "South") {
        if (normalPoint.y < a.y ) {
          normalPoint = a.get();
        }
        if (normalPoint.y > b.y ) {

          normalPoint = b.get();
        }
      }
      /////////////////////////////////////////////////////////////////////////////////////////////////////////



      // How far away are we from the path?
      float distance = PVector.dist(predictLoc, normalPoint);


      // Did we beat the record and find the closest line segment?
      if (distance < worldRecord) {
        worldRecord = distance;
        // If so the target we want to steer towards is the normal
        normal = normalPoint;


        // This is an oversimplification
        // Should be based on distance to path & velocity
        pathDirection.mult(15);
        if (direction == "West" || direction == "North") {
          pathDirection.mult(-1);
        }
        target = normalPoint.get();
        target.add(pathDirection);
      }
    }

    // Only if the distance is greater than the path's radius do we bother to steer
    if (worldRecord > p.radius) {
      seek(target);
    }


    // Draw the debugging stuff
    if (debug) {
      // Draw predicted future location
      stroke(0);
      fill(0);
      line(location.x, location.y, predictLoc.x, predictLoc.y);
      ellipse(predictLoc.x, predictLoc.y, 4, 4);

      // Draw normal location
      stroke(0);
      fill(0);
      ellipse(normal.x, normal.y, 4, 4);
      // Draw actual target (red if steering towards it)
      line(predictLoc.x, predictLoc.y, normal.x, normal.y);
      if (worldRecord > p.radius) fill(255, 0, 0);
      noStroke();
      ellipse(target.x, target.y, 8, 8);
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


  // Method to update location
  void update() {
    // Update velocity
    velocity.add(acceleration);
    // Limit speed
    velocity.limit(maxspeed);
    location.add(velocity);
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
    PVector desired = PVector.sub(target, location);  // A vector pointing from the location to the target

    // If the magnitude of desired equals 0, skip out of here
    // (We could optimize this to check if x and y are 0 to avoid mag() square root
    if (desired.mag() == 0) return;

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(maxspeed);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(maxforce);  // Limit to maximum steering force

      applyForce(steer);
  }

  void render() {
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + radians(90);
    fill(175);
    stroke(0);
    pushMatrix();
    translate(location.x, location.y);
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
    if (location.x < -r) location.x = width+r;
    //if (location.y < -r) location.y = height+r;
    if (location.x > width+r) location.x = -r;
    //if (location.y > height+r) location.y = -r;
  }
}


