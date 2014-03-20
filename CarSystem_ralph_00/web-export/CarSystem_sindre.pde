
class CarSystem 
{
  int CarPopulation;  

  //List Array containing the cars
  ArrayList <Car> Cars;

  // Vector for origine
  PVector origine;
  // Vector for destination
  PVector destination;

  Road systemRoad ;
  // Constructor for the CarSystem class
  CarSystem(Road tempRoad) {
    //set variable Car population
    CarPopulation = 40;
    systemRoad = tempRoad;
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

    //  Cars.get(i).follow();
    }
  }
}

/*
class button {

  int x;
  int y;
  int size;
  boolean pressed;
  boolean over;
  boolean locked;


  button(int xT, int yT, int sizeT, boolean pressedT) {
    xT = x;  
    yT = y;
    sizeT = size;
    pressedT = pressed;
  }

  boolean state() 
  {
    if (mouseX > x && mouseX < x+size && mouseY > y && mouseY < y+size) 
    {
      if (mousePressed)
      {
        pressed = true;
        return true;
      }
      else {
        pressed = false;
        return false;
      }
      return pressed;
    }
  }

  
}*/

//Based on Path Following
// by Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code

class CarPath {

  // A Road is an arraylist of points (PVector objects)
  ArrayList<PVector> points;
  // A Road has a radius, i.e how far is it ok for the boid to wander off
  float radius;
  PVector start;
  PVector end;

  CarPath(PVector start_, PVector end_) {
    // Arbitrary radius of 20
    radius = 20;
    points = new ArrayList<PVector>();
    start = start_.get();
    end = end_.get();
    generatePath();
  }
  int getSize() {
    int size = points.size();
    return size;
  }
  void generatePath() {
    PVector offset = new PVector(0, 0);
    int offsetDistance = 10;
    // end without offset
    PVector realEnd = end.get();

    if (end.x>start.x) {
      offset.add(new PVector(0, offsetDistance));
    }
    else if (end.x<start.x) {
      offset.add(new PVector(0, -offsetDistance));
    }
    if (end.y>=start.y) {
      offset.add(new PVector(-offsetDistance, 0));
    }
    else if (end.y<start.y) {
      offset.add(new PVector(offsetDistance, 0));
    }
    // println("offset: "+ offset.x + ", " + offset.y);

    start.add(offset);
    end.add(offset);

    PVector middle = new PVector(end.x, start.y);

    points.add(start);
    points.add(middle);
    points.add(end);
    points.add(realEnd);
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
  float carRadius = 6;

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
    separateForce.mult(1.5);
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
  //  Go towards destination code & Path following
  // ----------------------------------------------------------------------
  // A method that calculates a steering force towards a target and following a path

  void followPath() {

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

  PVector getDestination( PVector lastDestination) {

    PVector tempDestination = new PVector(0, 0);
    float randomX;
    float randomY;

    randomX = gridSize* round(random(width/gridSize));
    randomY = gridSize* round(random(height/gridSize));

    tempDestination = new PVector(randomX, randomY);

    // create a path to follow
    carPath = new CarPath(lastDestination, tempDestination);

    return tempDestination;
  }
}

// ----------------------------------------------------------------------
//  GUI class
// ----------------------------------------------------------------------
/*
class GUI {

  int controlMargin = width-width/10+10;
  int carNumber = 40;
  float speedLimit = 3;
  float steeringLimit = 0.3;

  // ----------------------------------------------------------------------
  //  GUI KNOBS
  // ----------------------------------------------------------------------
  // 
  GUI() {
///<<<<<<< HEAD
             
                  
//=======
//>>>>>>> FETCH_HEAD
  }

  void display() {


    //Side bar display 
    noStroke();
    fill(100, 100, 100, 200);
    rect(width, 0, -width/10, height);

    //Header:
    fill(250, 200, 10, 250);
    rect(width, 0, -width/10, 30);
    fill(0);
    textSize(10);
    text("Driverless Future", controlMargin-5, 20);

    // City Traffic Tab / Button
    textSize(12);
    fill(255, 200);
    text("City Traffic", controlMargin, 50);
    rect(controlMargin, 60, 50, 50, 7 );

    // HighWay Tab / Button
    text("Highway", controlMargin, 130);
    rect(controlMargin, 140, 50, 50, 7 );

    // Parking Tab / Button
    text("Parking", controlMargin, 210);
    rect(controlMargin, 220, 50, 50, 7 );

    // Shared Autos Tab / Button
    text("Shared Autos", controlMargin, 290);
    rect(controlMargin, 300, 50, 50, 7);

    //Midline gui stroke
    stroke(0);
    line (controlMargin-10, 360, controlMargin+100, 360);

    // Event Trigger Button
    noStroke();
    text("Event Trigger", controlMargin, 385);
    fill(255, 0, 0, 80);
    rect(controlMargin, 395, 50, 50, 7);

    //Midline gui stroke
    stroke(0);
    line (controlMargin-10, 455, controlMargin+100, 455);

    //fixed Controls:
    //Car Population----
    noStroke();
    fill(255, 200);
    text("Population", controlMargin, 480); 
    //Plus minus rectangles
    fill(255, 200);
    rect(controlMargin, 491, 26, 26, 4);
    rect(controlMargin+40, 489, 30, 30, 4);

    //Speed----
    noStroke();
    text("Speed", controlMargin, 540); 
    //Plus minus rectangles
    rect(controlMargin, 551, 26, 26, 4);
    rect(controlMargin+40, 549, 30, 30, 4);

    //Steering----
    noStroke();
    text("Steering", controlMargin, 600); 
    //Plus minus rectangles
    rect(controlMargin, 611, 26, 26, 4);
    rect(controlMargin+40, 609, 30, 30, 4);
  }

  void activateToggle() {
    //--------------------------------------------------
    // Car Population Toggle Setup
    //--------------------------------------------------

    if (carNumber >= 60) {
      carNumber = 60;
    }

    if (carNumber < 3) {
      carNumber = 4;
    }

    if (mouseX >= controlMargin && mouseX <= controlMargin+26 && mouseY >= 491 && mouseY <= 517 && mousePressed) {

      carNumber --;

    //  systemOfCars.setCarPopulation(carNumber);
      println(carNumber);
    }

    if (mouseX >= controlMargin+40 && mouseX <= controlMargin+70 && mouseY >= 491 && mouseY <= 521 && mousePressed) {
      carNumber++;

     // systemOfCars.setCarPopulation(carNumber);
      println(carNumber);
    }

    fill(255);
    textSize(10);
    text(carNumber, controlMargin+65, 480);

    //--------------------------------------------------
    // Car Speed Toggle Setup
    //--------------------------------------------------

      if (speedLimit >= 10) {
      speedLimit = 10;
    }

    if (speedLimit < 2) {
      speedLimit = 2;
    }

      if (mouseX >= controlMargin && mouseX <= controlMargin+26 && mouseY >= 551 && mouseY <= 577 && mousePressed) {

        speedLimit -= 0.5;

     //   systemOfCars.setCarSpeedLimit(speedLimit);
        println(speedLimit);
      }

    if (mouseX >= controlMargin+40 && mouseX <= controlMargin+70 && mouseY >= 551 && mouseY <= 581 && mousePressed) {
      
      speedLimit += 0.5;

      systemOfCars.setCarSpeedLimit(speedLimit);
      println(speedLimit);
    }
    text(int(speedLimit)*9 + "/mph", controlMargin+40, 540);
  
  
  //--------------------------------------------------
    // Car Speed Toggle Setup
    //--------------------------------------------------

      if (steeringLimit >= 2) {
      steeringLimit = 2;
    }

    if (steeringLimit < 0.1) {
      steeringLimit = 0.1;
    }

      if (mouseX >= controlMargin && mouseX <= controlMargin+26 && mouseY >= 611 && mouseY <= 637 && mousePressed) {

        steeringLimit -= 0.1;

        systemOfCars.setCarSteerLimit(steeringLimit);
        println(steeringLimit);
      }

    if (mouseX >= controlMargin+40 && mouseX <= controlMargin+70 && mouseY >= 611 && mouseY <= 641 && mousePressed) {
      
      steeringLimit += 0.1;

      systemOfCars.setCarSteerLimit(steeringLimit);
      println(steeringLimit);
    }
    text(int(steeringLimit*10), controlMargin+50, 600);
  }
  
  
}
*/


// ----------------------------------------------------------------------
// GLOBAL VARIABLES
// ----------------------------------------------------------------------

CarSystem systemOfCars;

// A path object (series of connected points)
Road road ;

// Using this variable to toggle between drawing the lines or not
boolean debug = false;

int gridSize = 170;

// ----------------------------------------------------------------------
//  FUNCTIONS
// ----------------------------------------------------------------------
void setup() {
  size(900, 700);


  // Call a function to generate new Path object
  newPath(gridSize);
  systemOfCars = new CarSystem(road);
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
  background(0,10,10);
  // Display the road
  road.display();

  // Call all functions related to Cars
  systemOfCars.run();


}
// creates a grid of point for the path class
void newPath(int spacer) {

  road = new Road();
 // path.addPoint(0, 0);
 // path.addPoint(height, height);
  for ( int g = 0; g <width+spacer/spacer; g++) {
    road.addPoint(spacer*g, 0);
    road.addPoint(spacer*g, height);
    road.addPoint(spacer*(g+1), height);
  }
  for ( int g = 0; g <height+spacer/spacer; g++) {
    road.addPoint(0, spacer*g);
    road.addPoint(width, spacer*g);
    road.addPoint(width, spacer*(g+1));
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

class Road {

  // A Road is an arraylist of points (PVector objects)
  ArrayList<PVector> points;
  // A Road has a radius, i.e how far is it ok for the boid to wander off
  float radius;

  Road() {
    // Arbitrary radius of 20
    radius = 20;
    points = new ArrayList<PVector>();
  }

  // Add a point to the Road
  void addPoint(float x, float y) {
    PVector point = new PVector(x, y);
    points.add(point);
  }

  // Draw the Road
  void display() {
    // Draw Roads
    stroke(255, 50);
    strokeWeight(radius*2+2);
    noFill();

    for (int v = 0; v < points.size()-1; v++ ) {
      line(points.get(v).x, points.get(v).y, points.get(v+1).x, points.get(v+1).y);
    }
    stroke(10, 20, 20);
    strokeWeight(radius*2);
    noFill();

    for (int v = 0; v < points.size()-1; v++ ) {
      line(points.get(v).x, points.get(v).y, points.get(v+1).x, points.get(v+1).y);
    }
    // draw buildings
    /* int buildingN = 5;
     for (int bv = 1; bv < buildingN; bv++ ) {
     for (int bh = 1; bh < buildingN-1; bh++ ) {
     
     float buildingSize = gridSize*0.6;
     float offset=0;
     rectMode(CENTER);
     noStroke();
     fill(15, 15, 30);
     rect(gridSize*bv-gridSize/2, gridSize*bh- gridSize/2, buildingSize, buildingSize);
     fill(15, 20, 50);
     offset= 15;
     //  rect(gridSize*bv-gridSize/2+offset, gridSize*bh- gridSize/2+offset, buildingSize, buildingSize);
     }
     }
     */
    /// draw dot grid
    strokeWeight(2);
    stroke(255, 50);
    for ( int h = 0; h< width/radius; h++) {
      for ( int v = 0; v< height/radius; v++) {
        point(radius*h, radius*v);
      }
    }
  }
}


