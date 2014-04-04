// a subclass of car for city cars
class EmergencyVehicle extends Car {

  int gridSize;

  EmergencyVehicle(int id) {
    super(id);

    steerLimit = 0.8;  
    easing = 0.3;
  }

  // update methode
  void update() {
    velocity.add(acceleration);

    velocity.mult(1.8);
    // limit the velocity to the maximum speed alowd
    velocity.limit(speedLimit*1.5);
    // add the velocity to the position
    position.add(velocity);
    // reset acceleration
    acceleration.mult(0);
  }



  // ----------------------------------------------------------------------
  //  Car display
  // ----------------------------------------------------------------------  
  void display() {
    fill(250, 230, 0);
    noStroke();
    int AmbSize = 9;
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
    randomX = gridSize* round(random(1, width/gridSize));
    randomY = gridSize* round(random(1, height/gridSize));

    tempDestination = new PVector(randomX, randomY);

    // create a path to follow
    carPath = new CarPath(lastDestination, tempDestination, 0);

    return tempDestination;
  }
}

