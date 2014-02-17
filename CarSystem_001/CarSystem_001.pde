 
 class CarSystem 
{
  int CarPopulation;  

  //List Array containing the cars
  ArrayList <Car> Cars;

  // Vector for origine
  PVector origine;
  // Vector for destination
  PVector destination;

  CarSystem() {
    //set variable Car population
    CarPopulation = 20;

    // initialize our array list of "Cars"
    Cars = new ArrayList<Car>();
  }

  //---------------------------------------------------------------
  // Initialize method to add the default number of cars
  //---------------------------------------------------------------

  void init() {

    for (int i = 0; i < CarPopulation; i ++) {
      // get random Origine
      origine = new PVector(random(0, width), random(0, height));
      // get random Destination
      destination =new PVector(random(0, width), random(0, height)); 

      //create new car
      Cars.add(new Car(origine, destination));
    }
  }

  //---------------------------------------------------------------
  // method to check if cars are colliding
  //---------------------------------------------------------------

  void checkCarCollisionInSystem() {

    for (int i = 0; i < CarPopulation; i++ ) {
      for (int c = 0; c < CarPopulation; c++) {
        if (i!=c) {
          Cars.get(i).checkCollision(Cars.get(c));
        }
      }
    }
  }

  //---------------------------------------------------------------
  // method to apply forces to car system
  //---------------------------------------------------------------

  void applyForces()
  {
    for (int i = 0; i < CarPopulation; i++) {
      Cars.get(i).applyForce(Cars.get(i).seek());
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
    }
  }

  //---------------------------------------------------------------
  // Method to setting car population number with knob
  //---------------------------------------------------------------

  void setCarPopulation(int incomingCarNumber)
  {
    int diference = incomingCarNumber - CarPopulation;

    origine = new PVector(random(0, width), random(0, height));
    destination =new PVector(random(0, width), random(0, height));

    if (diference > 0)
    {
      for (int i = CarPopulation; i < incomingCarNumber; i++) {
        Cars.add(new Car(origine, destination));
      }
      CarPopulation = incomingCarNumber;
      println("ADD in class system carNumer::" + CarPopulation );
    }
    else if (diference < 0) {
      for (int i = CarPopulation-1; i > incomingCarNumber; i--) {
        Cars.remove(i);
      }
      CarPopulation = incomingCarNumber;
      println("REMOVE in class system carNumer::" + CarPopulation );
    }
  }


  //---------------------------------------------------------------
  // method for setting up speed limit for all cars
  //---------------------------------------------------------------

  void setCarSpeedLimit(float carSpeedLimit)
  {
    for (int i = 0; i < CarPopulation; i ++) {
      Cars.get(i).setCarSpeedLimit(carSpeedLimit);
    }
  }
  
  //---------------------------------------------------------------
  // method for setting up Steering limit for all cars
  //---------------------------------------------------------------
  
  void setCarSteerLimit(float SteerLimit)
  {
   for (int i = 0; i < CarPopulation; i ++){
    Cars.get(i).setCarSteerLimit(SteerLimit);
   }
  }
  
  //---------------------------------------------------------------
  // method for setting up Repulsion force for all cars
  //---------------------------------------------------------------
  
  void setRepulsionLimit(float RepulsionLimit)
  {
   for (int i = 0; i < CarPopulation; i ++){
    Cars.get(i).setRepulsionLimit(RepulsionLimit);
   }
  }
  
}

