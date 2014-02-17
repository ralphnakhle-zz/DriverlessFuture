
class Car {

  // Car position
  PVector position;
  //  change in position
  PVector velocity = new PVector(0, 0);
  // change in velocity
  PVector acceleration= new PVector(0, 0);

  // Radius of the Car
  float carRadius = 10;

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
    // draw body
    ellipse(position.x, position.y, carRadius*2, carRadius*2);
    fill(0);
    pushMatrix();
    //rotate(seek().x);
    //rotate(sin(seek().x));
    ellipse(position.x, position.y+seek().y, carRadius/2, carRadius/2);
    popMatrix();


    // safe zone
    fill(255, 10);
    ellipse(position.x, position.y, safeZone*2, safeZone*2);
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
  //  Interaction with other cars
  // ----------------------------------------------------------------------
  void checkCollision(Car other) {

    // get distances between the Cars
    PVector carVect = PVector.sub(other.position, position);

    // calculate magnitude of the vector separating the Cars
    float carDistance = carVect.mag();

    // check if two cars are touching
    if (carDistance < carRadius + other.carRadius) {
      accidented = true;
      acceleration.mult(0);
      velocity.mult(0);
      //accident ++;
      // println("number of accidents: " + accident);
    }

    // calculate the safe zone according to speed
    safeZone = velocity.mag()*40;
    safeZone = constrain(safeZone, carRadius*1.7, 80);
    // check if another car is in the safe zone
    if (carDistance < safeZone + other.safeZone) {

      // Calculate direction of repulseForce
      PVector repulseForce = PVector.sub(other.position, position);         
      // Distance between objects
      float distance = repulseForce.mag();
      // Limiting the distance to eliminate "extreme" results for very close or very far objects
      // distance = constrain(distance, carRadius+1, 50.0);    
      // Normalize vector 
      repulseForce.normalize();                                           
      // Calculate repulse Strength
      float strength = repulseC/distance; 

      // Get repulseForce vector --> magnitude * direction
      repulseForce.mult(-1*strength);    
      applyForce(repulseForce);

      if (debug) {
        stroke(0, 100, 200);
        line(position.x, position.y, other.position.x, other.position.y);
      }
    }
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

