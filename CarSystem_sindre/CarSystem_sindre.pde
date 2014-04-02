
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
  int parkingIndex = 0;
  int parkedCars = 0;
  int parkingOffset = 40;

  ArrayList <ParkingSpot> parkingSpots;

  // Constructor for the CarSystem class
  CarSystem(char scenario_) {
    //set variable Car population
    CarPopulation = 40;
    // initialize our array list of "Cars"
    Cars = new ArrayList<Car>();
    Ambulances = new ArrayList<Car>();
    parkingSpots = new ArrayList<ParkingSpot>();
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
        parkingSpots.add(new ParkingSpot(parkingPosition, false));
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
      //update position
      Cars.get(i).update();
      //display the car

      Cars.get(i).display();

      Cars.get(i).applyBehaviors(Cars);
    }

    if (Ambulances.size() >0) {
      for (int a = 0; a< Ambulances.size(); a++) {
        Ambulances.get(a).update();
        //display the car
        Ambulances.get(a).display();
        Ambulances.get(a).applyBehaviors(Ambulances);
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
    else if (incomingCarNumber == 0) {
      Cars.remove(CarPopulation-1);
      CarPopulation = Cars.size() ;
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
  // method for trigger event 
  //---------------------------------------------------------------
  void triggerEvent() {
    if (carScenario == 'C') {
      println("Ambulance!");
      Ambulances.add(new EmergencyVehicle());
    }

    if (carScenario == 'P') {

      int randomCar = round(random(0, CarPopulation-1));
      if (Cars.get(randomCar).parked == true) {
        Cars.get(randomCar).getDestination(Cars.get(randomCar).position);
        parkingSpots.get(randomCar).useParking(true);
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
      Cars.add(new CityCar());
      break;

    case 'P': 
      // define where the cars come in 
      parkStart = new PVector(0-parkingIndex*80, height-50);

      if (parkingSpots.get(parkingIndex).getParkingState() == false) {
        parkPos = parkingSpots.get(parkingIndex).getParkingPosition();
      }

      Cars.add(new ParkingCar(parkStart, parkPos));
      parkingSpots.get(parkingIndex).useParking(true);

      if (parkingIndex < CarPopulation) {
        parkingIndex ++;
      }

      break;

    case 'H': 
      Cars.add(new CityCar());

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

