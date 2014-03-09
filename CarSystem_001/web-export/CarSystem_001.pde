
class CarSystem 
{
  int CarPopulation;  

  //List Array containing the cars
  ArrayList <Car> Cars;

  // Vector for origine
  PVector origine;
  // Vector for destination
  PVector destination;

  Path systemPath ;
  // Constructor for the CarSystem class
  CarSystem(Path tempPath) {
    //set variable Car population
    CarPopulation = 30;
    systemPath = tempPath;
    // initialize our array list of "Cars"
    Cars = new ArrayList<Car>();
  }

  //---------------------------------------------------------------
  // Initialize method to add the default number of cars
  //---------------------------------------------------------------

  void init() {
    for (int i = 0; i < CarPopulation; i ++) {
      //create new car
      Cars.add(new Car());
    }
  }


 
  //---------------------------------------------------------------
  // method to display our car system
  //---------------------------------------------------------------

  void run()
  {
    for (int i = 0; i< CarPopulation; i++) {
      //update position
      Cars.get(i).update();
      //display the car
      Cars.get(i).display();

      Cars.get(i).applyBehaviors(Cars);

      Cars.get(i).follow(systemPath);
    }
  }
}


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
  float speedLimit = 3;

  // Maximum steering force
  float steerLimit = 0.3;  

  // car color
  color carColor = color(250, 220, 0);

  // check if the car had an accident
  boolean accidented = false;

  // origin
  PVector carOrigine;
  PVector carDestination;



  // constructor
  Car() {
    position = getOrigine();
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

    if (debug) {
      stroke(255, 60, 0);
      line(position.x, position.y, carDestination.x, carDestination.y);
      // draw target lines and dot
      fill(255, 60, 0);
      ellipse(carDestination.x, carDestination.y, carRadius*0.5, carRadius*0.5);
    }
    // draw car

    fill(carColor);
    noStroke();
    // Draw a triangle rotated in the direction of velocity
    float theta = velocity.heading2D() + PI/2;

    pushMatrix();
    translate(position.x, position.y);
    rotate(theta);
    beginShape();
    rectMode(CENTER);
    rect(0, 0, carRadius, carRadius*2);
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
    if (worldRecord > p.radius-carRadius) {
      seekPath(target);
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
    steer.limit(steerLimit*2);  // Limit to maximum steering force
    applyForce(steer);
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
  // method to create random origine and destinations for the cars
  //---------------------------------------------------------------
  int selector = 0;

  PVector getOrigine() {

    PVector tempOrigine = new PVector(0, 0);

    // select a random option 
    selector = int(random(0, 4));

    //Origine North
    if (selector ==0) {
      tempOrigine = new PVector(random(0, width), 10);
    }
    //Origine east
    else if (selector ==1) {
      tempOrigine = new PVector(width-10, random(0, height));
    }
    //Origine south
    else if (selector ==2) {
      tempOrigine = new PVector(random(0, width), height-10);
    }
    //Origine west
    else {
      tempOrigine = new PVector(10, random(0, height));
    }

    return tempOrigine;
  }
  PVector getDestination() {

    PVector tempDestination = new PVector(0, 0);

    // select a random option 
    selector = int(random(0, 4));

    //Destination North
    if (selector ==0) {
      tempDestination = new PVector(random(0, width), 10);
    }
    //Destination east
    else if (selector ==1) {
      tempDestination = new PVector(width-10, random(0, height));
    }
    //Destination south
    else if (selector ==2) {
      tempDestination = new PVector(random(0, width), height-10);
    }
    //Destination west
    else {
      tempDestination = new PVector(10, random(0, height));
    }

    return tempDestination;
  }
}

// ----------------------------------------------------------------------
//  GUI class
// ----------------------------------------------------------------------

class GUI {


  // ----------------------------------------------------------------------
  //  GUI KNOBS
  // ----------------------------------------------------------------------
  // Knob function from ControlP5 - All parameters of Knobs 
  GUI() {
             ;
                  
  }
} 



// ----------------------------------------------------------------------
// GLOBAL VARIABLES
// ----------------------------------------------------------------------

CarSystem systemOfCars;

// A path object (series of connected points)
Path path ;

// Using this variable to toggle between drawing the lines or not
boolean debug = false;

// ----------------------------------------------------------------------
//  FUNCTIONS
// ----------------------------------------------------------------------
void setup() {
  size(900, 700);


  // Call a function to generate new Path object
  newPath(180);
  systemOfCars = new CarSystem(path);
  systemOfCars.init();
}

// ----------------------------------------------------------------------
//  GUI FUNCTIONS 
// ----------------------------------------------------------------------

// ----------------------------------------------------------------------
//  DRAW FUNCTION
// ----------------------------------------------------------------------

void draw() {

  // draw the background
  background(0, 25, 35);
  // Display the road
  path.display();

  // Call all functions related to Cars
  systemOfCars.run();

  // draw the Gui bar
  rectMode(CORNER);
  fill(0, 150);
  noStroke();
 // rect(0, 0, width, 80);
 
  // text
  fill(255);
  //text("Press space bar to enable and disable toggle lines", 20, 20);
}
// creates a grid of point for the path class
void newPath(int spacer) {

  path = new Path();
 // path.addPoint(0, 0);
 // path.addPoint(height, height);
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

// press space bar to able and disable collision and target lines.
public void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
}

//Based on Path Following
// by Daniel Shiffman <http://www.shiffman.net>
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
    stroke(100, 120, 130);
    strokeWeight(radius*2+2);
    noFill();

    for (int v = 0; v < points.size()-1; v++ ) {
      line(points.get(v).x, points.get(v).y, points.get(v+1).x, points.get(v+1).y);
    }
    stroke(10, 30, 55);
    strokeWeight(radius*2);
    noFill();

    for (int v = 0; v < points.size()-1; v++ ) {
      line(points.get(v).x, points.get(v).y, points.get(v+1).x, points.get(v+1).y);
    }
    strokeWeight(1);
  }
}


