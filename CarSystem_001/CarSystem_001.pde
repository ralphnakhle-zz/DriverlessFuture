
class CarSystem 
{
  int CarPopulation;  

  //List Array containing the cars
  ArrayList <Car> Cars;

  // Vector for origine
  PVector origine;
  // Vector for destination
  PVector destination;

  // Constructor for the CarSystem class
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
      origine = getOrigine();
      // get random Destination
      destination =getDestination();

      //create new car
      Cars.add(new Car(origine, destination));
    }
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
    else{
      tempDestination = new PVector(10, random(0, height));
    }

    return tempDestination;
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
      Cars.get(i).follow(path);
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

    // get random Origine
    origine = getOrigine();
    // get random Destination
    destination =getDestination();

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
    for (int i = 0; i < CarPopulation; i ++) {
      Cars.get(i).setCarSteerLimit(SteerLimit);
    }
  }

  //---------------------------------------------------------------
  // method for setting up Repulsion force for all cars
  //---------------------------------------------------------------

  void setRepulsionLimit(float RepulsionLimit)
  {
    for (int i = 0; i < CarPopulation; i ++) {
      Cars.get(i).setRepulsionLimit(RepulsionLimit);
    }
  }
}

