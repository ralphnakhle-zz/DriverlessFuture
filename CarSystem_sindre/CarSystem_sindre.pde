
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

  // Constructor for the CarSystem class
  CarSystem(char scenario_) {
    //set variable Car population
    CarPopulation = 40;
    // initialize our array list of "Cars"
    Cars = new ArrayList<Car>();
    Ambulances = new ArrayList<Car>();
    carScenario = scenario_;
  }

  //---------------------------------------------------------------
  // Initialize method to add the default number of cars
  //---------------------------------------------------------------

  void init() {
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

  void setCarPopulation(int incomingCarNumber)
  {
    int diference = incomingCarNumber - CarPopulation;

    if (diference > 0)
    {
      for (int i = CarPopulation; i < incomingCarNumber; i++) {
        getCar();
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
  // method for trigger event 
  //---------------------------------------------------------------
  void triggerEvent() {
    if (carScenario == 'C') {
      println("Ambulance!");
      Ambulances.add(new EmergencyVehicle());
    }

    if (carScenario == 'P') {
      int randomCar = round(random(0, CarPopulation-1));
      Cars.get(randomCar).getDestination(Cars.get(randomCar).position);
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
      parkStart = new PVector(0-parkingIndex*80, height-50);

      if (parkedCars < 10) { 
        parkPos = new PVector(width/2+300-parkingOffset, 120+parkedCars*50);
        parkedCars ++;
      }
      else {
        parkingOffset+=100;
        parkedCars = 0;
        parkPos = new PVector(width/2+300-parkingOffset, 120+parkedCars*50);
        parkedCars ++;
      }

      Cars.add(new ParkingCar(parkStart, parkPos));

      if (parkingIndex <= CarPopulation) {
        parkingIndex ++;
      }
      else {
        parkingIndex = 0;
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

