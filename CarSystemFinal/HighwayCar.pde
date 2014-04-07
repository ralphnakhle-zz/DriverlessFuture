// a subclass of car for highway cars
class HighwayCar extends Car {
  //boolean to switch car directions. 
  boolean directionRight = false;
  
  // highway car constructor that takes in car id
  HighwayCar(int id) {
    super(id);
    //overriding car radius to make them a little larger
    carRadius = 8;
  }
    
    // method taking in new car arraylist to seperate cars from each other and applyForce
   void applyBehaviors(ArrayList<Car> Cars) {
     // new sepereate force parameters overriden
    PVector separateForce = separate(Cars);
    separateForce.mult(0.3);
    // assining path following to highway cars
    followPath();
    // apply forces to highway cars
    applyForce(separateForce);
  }
  
  // method to assign accident behaviour to array of cars when close to Orange Cone (Accident)
  void applyAccidentBehaviors(PVector Accident) {
    PVector separateForce = separateFromAccident(Accident);
    separateForce.mult(0.6);
    followPath();
    applyForce(separateForce);
  }
  
  // ----------------------------------------------------------------------
  //  Interaction with Accident
  // ----------------------------------------------------------------------
  // Separation
  // Method checks for nearby vehicles and steers away
  PVector separateFromAccident (PVector accident) {
    // calculate the safe zone
    safeZone = 60;
    //calcualte safe angle
    float safeAngle = PI/6;
    // initialize new sForce
    PVector sForce = new PVector(0, 0);

    // get the distance between the two cars
    float distance = PVector.dist(position, accident);
    // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)

    if (distance < safeZone) {
      // Calculate vector pointing away from neighbor
      PVector diff = PVector.sub(position, accident);

      // check if the other car is in front of this car
      diff.normalize();
      // if the car is straight in front..
      sForce = diff.get();
    }

  return sForce;
}

  //---------------------------------------------------------------
  // method to create random origine and destinations for the cars
  //---------------------------------------------------------------

  PVector getDestination( PVector lastDestination) {
    //gridSize = width;
    PVector tempDestination = new PVector(0, 0);
    float destinationX;
    float destinationY;
    
    // randomize cars have the be triggered "equally" on the left or right
    for(int i = 0; i < gui.carNumber+1; i ++) {
     int randomizeSide = int(random(0, 2)); 
     if ( randomizeSide == 0 ){
      directionRight = false;
     } else {
       directionRight = true;
     }
    }
    
    // conditions for car position initiation - based on left or right start
    if (directionRight) {
      
      destinationX = (-300)+60*round(random(1, 4));
      destinationY = height/2+40*round(random(1, 4));
      
    }
    else {    
      destinationX = (width+300)-60*round(random(1, 4));
      destinationY = height/2-40*round(random(1, 4));
      
    }
    gridSize = 1;
    
    // temp destination
    tempDestination = new PVector(destinationX, destinationY);

    // create a path to follow
    carPath = new CarPath(lastDestination, tempDestination, 0);

    return tempDestination;
  }
}

