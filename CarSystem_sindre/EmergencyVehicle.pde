// a subclass of car for city cars
class EmergencyVehicle extends Car {

  int gridSize;

  EmergencyVehicle(int id) {
    super(id);
  }

  // ----------------------------------------------------------------------
  //  Car display
  // ----------------------------------------------------------------------  
  void display() {
    fill(250, 230, 0);
    noStroke();
    int AmbSize = 10;
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
    rect(0, AmbSize/2, AmbSize, AmbSize*2);
    if (velocity.mag() < speedLimit/2) {
      fill(255, 0, 0);
    }
    else {      
      fill(255, 150, 150);
    }
    rect(0, AmbSize*1.25, AmbSize, AmbSize/3);
    fill(255);
    rect(0, 0-AmbSize/2, AmbSize, AmbSize/3);
    // blinking red cross
    fill(250, 150, 0);
    if (frameCount % 4== 0) {
      fill(250, 50, 0);
    }
    rect(0, AmbSize/2, AmbSize/1.5, AmbSize/4);
    rect(0, AmbSize/2, AmbSize/4, AmbSize/1.5);

    endShape(CLOSE);
    popMatrix();
  }

  //---------------------------------------------------------------
  // method to create random origine and destinations for the cars
  //---------------------------------------------------------------

  PVector getDestination( PVector lastDestination) {
    PVector tempDestination = new PVector(0, 0);
    float randomX;
    float randomY;
    gridSize = 180;
    randomX = gridSize* round(random(-1, width/gridSize)+1);
    randomY = gridSize* round(random(-1, height/gridSize)+1);

    tempDestination = new PVector(randomX, randomY);

    // create a path to follow
    carPath = new CarPath(lastDestination, tempDestination, 0);

    return tempDestination;
  }


  // used for the path following code
  void seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // If the magnitude of desired equals 0, skip out of here
    if (desired.mag() == 0) return;

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(speedLimit*4);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(steerLimit*2);  // Limit to maximum steering force
    applyForce(steer);
  }
}

