
class CarSystem 
{
  int CarPopulation;  

  //List Array containing the cars
  ArrayList <Car> Cars;
  ArrayList <Car> Ambulances;
  char carScenario;

  // parking variables
  PVector parkPos;
  PVector parkStart;
  // int parkingIndex = 0;
  int parkingOffset = 40;

  ArrayList <ParkingSpot> parkingSystem;

  int carID = 0;

  // Constructor for the CarSystem class
  CarSystem(char scenario_) {
    //set variable Car population
    CarPopulation = 40;
    // initialize our array list of "Cars"
    Cars = new ArrayList<Car>();
    Ambulances = new ArrayList<Car>();
    parkingSystem = new ArrayList<ParkingSpot>();
    carScenario = scenario_;
  }

  //---------------------------------------------------------------
  // Initialize method to add the default number of cars
  //---------------------------------------------------------------

  void init() {
    PVector parkingPosition;
    for (int p = 0; p < 10; p ++) {
      for (int pR = 0; pR < 10; pR ++) {
        parkingPosition = new PVector(width /2+300 - 60*p, 120+ pR*50);
        parkingSystem.add(new ParkingSpot(parkingPosition, false));
      }
    }

    for (int i = 0; i < CarPopulation; i ++) {
      //create new car
      getCar();
    }
  }

  //---------------------------------------------------------------
  // method to display our car system
  //---------------------------------------------------------------

  void run()
  {
    for (int i = 0; i< CarPopulation; i++) {
      if (scenario == 'P' && Cars.get(i).trash()) {
        Cars.remove(i);
        CarPopulation = Cars.size() ;
        //parkingIndex--;
      }
      //update position
      Cars.get(i).update();
      //display the car

      Cars.get(i).display();
      if (scenario == 'C') {
        Cars.get(i).applyBehaviors(Cars, Ambulances);
      }

      else {      
        Cars.get(i).applyBehaviors(Cars);
      }
    }

    if (scenario == 'C') {
      /// ambulance run loop
      if (Ambulances.size() >0) {
        for (int a = 0; a< Ambulances.size(); a++) {
          Ambulances.get(a).update();
          //display the car
          Ambulances.get(a).display();
          Ambulances.get(a).applyBehaviors(Cars);
          //  Ambulances.get(a).applyBehaviors(Cars);
        }
      }
    }
  }
  //---------------------------------------------------------------
  // Method to setting car population number Gui buttons
  //---------------------------------------------------------------

  void setCarPopulation(int incomingCarNumber) {

    if (incomingCarNumber ==1) {

      getCar();
      CarPopulation = Cars.size() ;
      println("ADD in class system carNumer::" + CarPopulation );
    }
    else if (incomingCarNumber == 0 ) {
      if (scenario == 'P') {
        triggerEvent();
      }
      else {
        Cars.remove(CarPopulation-1);
        CarPopulation = Cars.size() ;
        println("REMOVE in class system carNumer::" + CarPopulation );
      }
    }
  }


  int getCarPopulation() {
    return CarPopulation;
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
  // method for trigger event 
  //---------------------------------------------------------------
  void triggerEvent() {
    if (carScenario == 'C') {
      if (Ambulances.size()<1) {
        Ambulances.add(new EmergencyVehicle(1));
        // println("Ambulance!");
      }
    }

    if (carScenario == 'P') {
      boolean carLeft = false;
      int counter = 0;
      int randomCar ;
      while (carLeft == false) {
        randomCar = round(random(0, CarPopulation-1));
        counter ++;
        // check if the car is parked
        if (Cars.get(randomCar).parked == true) {
          // give that car a new destination 
          Cars.get(randomCar).getDestination(Cars.get(randomCar).position);
          // make the parking spot not busy
          parkingSystem.get(randomCar).useParking(false);
          // exit the while loop
          carLeft = true;
          println("found a car");
        }
        // if no cars match after 300 times, exit the while loop
        if (counter>300) {          
          carLeft = true;
          println("no cars");
        }
      }
    }

    if (carScenario == 'H') {
      println("Accident!");
    }
  }
  //---------------------------------------------------------------
  // select the car depending on the scenario
  //---------------------------------------------------------------
  void getCar() {
    switch(scenario) {
    case 'C': 
      Cars.add(new CityCar(carID));
      carID ++;
      break;

    case 'P': 
      boolean foundSpot = false;
      int pakingCounter = 0;
      float lastCarX;

      if (Cars.size()>0) {
        // last car position

        lastCarX = Cars.get(Cars.size()-1).position.x;
        if (lastCarX>0) { 
          lastCarX = 0;
        }
        // define where the cars come in 
        parkStart = new PVector(lastCarX-100, height-100);
      }
      else {
        parkStart = new PVector(0, height-100);
      }
      // while loop to find an empty parking spot
      while (foundSpot == false) {
        // if the parking spot is not busy
        if (parkingSystem.get(pakingCounter).getParkingState() == false) {
          // get the parking spots position
          parkPos = parkingSystem.get(pakingCounter).getParkingPosition();
          // and a new car and assigne a parking spot to him
          Cars.add(new ParkingCar(carID, parkStart, parkPos));
          // make that parking spot busy
          parkingSystem.get(pakingCounter).useParking(true);
          // increment the car ID
          carID ++;
          // exit the while loop
          foundSpot = true;
        }

        // if all the parking spots are full, exit the while loop
        else if (pakingCounter> CarPopulation) {
          foundSpot = true;
          //println("parking is full!");
        }
        // increment the parking Counter
        pakingCounter ++;
      }

      break;

    case 'H': 
      Cars.add(new CityCar(carID));
      carID ++;

      break;

    case 'S': 
      // println("Scenario : S"); 
      break;

    default:             // Default executes if the case labels
      // println("Scenario : None");   
      break;
    }
  }
}

