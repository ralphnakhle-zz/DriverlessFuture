// a subclass of car for city cars
class HighwayCar extends Car {
  boolean directionRight = false;
  

  HighwayCar() {
    super();
    carRadius = 8;
  }
  
   void applyBehaviors(ArrayList<Car> Cars) {
    PVector separateForce = separate(Cars);
    separateForce.mult(0.3);
    followPath();
    applyForce(separateForce);
  }

  

  //---------------------------------------------------------------
  // method to create random origine and destinations for the cars
  //---------------------------------------------------------------

  PVector getDestination( PVector lastDestination) {
    //gridSize = width;
    PVector tempDestination = new PVector(0, 0);
    float destinationX;
    float destinationY;
    
    //directionRight = !directionRight;

    
    for(int i = 0; i < gui.carNumber+1; i ++) {
     int randomizeSide = int(random(0, 2)); 
     if ( randomizeSide == 0 ){
      directionRight = false;
     } else {
       directionRight = true;
     }
    }
    
    if (directionRight) {
      
      destinationX = (-300)+60*round(random(1, 4));
      destinationY = height/2+40*round(random(1, 4));
      
    }
    else {    
      destinationX = (width+300)-60*round(random(1, 4));
      destinationY = height/2-40*round(random(1, 4));
      
    }
    gridSize = 1;
    
    tempDestination = new PVector(destinationX, destinationY);

    // create a path to follow
    carPath = new CarPath(lastDestination, tempDestination, 0);

    return tempDestination;
  }
}

