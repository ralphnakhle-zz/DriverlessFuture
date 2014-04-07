// a Class to mange a system of cars 
class CarSystem 
{
  // the number of cars to display and run
  int CarPopulation;

  //List Array containing the cars
  ArrayList <Car> Cars;
  // Array list of ambulances
  ArrayList <Car> Ambulances;
  // position of accident for the highway scenario
  PVector Accident;

  int accidentXposition = -10;

  // a char to determine witch scenario is active
  char carScenario;

  // random position for the accident
  int randomX;
  int randomY;

  // parking variables
  // position of the parking
  PVector parkPos;
  // position where the parking cars enter the screen
  PVector parkStart;

  // an array list of parking spots
  ArrayList <ParkingSpot> parkingSystem;

  // id to assigne to cars to be able to check against other cars
  int carID = 0;

  boolean toggle = false;

  // a car that carry a pedestrian
  Car tempCar;

  // an instance of a pedestrian
  Pedestrian pedestrian;
  // an instance of an accident
  AccidentClass accidentClass;

  //---------------------------------------------------------------
  // Constructor for the CarSystem class
  //---------------------------------------------------------------

  CarSystem(char scenario_) {
    //set default number of  Cars to display
    CarPopulation = 40;
    // initialize our array list of "Cars"
    Cars = new ArrayList<Car>();
    // initialize the array of ambulances
    Ambulances = new ArrayList<Car>();

    // initialize the accident
    Accident = new PVector(0, 0);
    // initialise the parking system
    parkingSystem = new ArrayList<ParkingSpot>();
    // initialise the pedestrian
    pedestrian = new Pedestrian (new PVector(width/2+10, height/2));
    // initialize the accident class
    accidentClass = new AccidentClass();
    // get the scenario from the main code
    carScenario = scenario_;
  }

  //---------------------------------------------------------------
  // Initialize method to fill the car arraylist
  //---------------------------------------------------------------

  void init() {

    // initialize the parkingSystem 10 by 10 for 100 parking spots all availeble
    PVector parkingPosition;
    for (int p = 0; p < 10; p ++) {
      for (int pR = 0; pR < 10; pR ++) {
        parkingPosition = new PVector(width /2+300 - 60*p, height/2-300+ pR*52);
        parkingSystem.add(new ParkingSpot(parkingPosition, false));
      }
    }
    // fill the car array with new cars
    for (int i = 0; i < CarPopulation; i ++) {
      //create new car
      getCar();
    }
  }

  // Car Population accessor:
  int getCarPopulation () {
    return CarPopulation;
  }


  //---------------------------------------------------------------
  // method to run our car system
  //---------------------------------------------------------------

  void run()
  {
    // for every car in the car Population
    for (int i = 0; i< CarPopulation; i++) {
      // if in the parking scenario, check if the car should get trashed
      if (scenario == 'P' && Cars.get(i).trash()) {
        // remove the car for the arraylist
        Cars.remove(i);
        // reset the car population the the cars arraylist leght
        CarPopulation = Cars.size() ;
      }

      //update position of the car
      Cars.get(i).update();

      //display the car
      Cars.get(i).display();

      // if in the city scenario
      if (scenario == 'C') {
        // the cars check other cars and ambulances
        Cars.get(i).applyBehaviors(Cars, Ambulances);
      }
      else {     
        // the car check against other cars 
        Cars.get(i).applyBehaviors(Cars);
      }

      // if in the highway scenario
      if (scenario == 'H') {
        // check for accidents
        Cars.get(i).applyAccidentBehaviors(Accident);
        // display the accident
        accidentClass.displayAccident(randomX, randomY);
      }
      // if in the shared comodety scenario and event toggled
      if (scenario == 'S' && toggle == true) {
        // check if the pedestrian can be picked up
        if (pedestrian.pickedUp == false && pedestrian.canBePickedUp == true) {
          if (Cars.get(i).findTargetCarfromPedestrian(pedestrian) == true) { 
            tempCar = Cars.get(i);
          }
        }
        // display pedestrian
        pedestrian.display();
      }
    }
    // when the pedestrian is picked up
    if (pedestrian.pickedUp==true && scenario=='S')
    {
      // the pedestrian updates acording to the car
      pedestrian.update(tempCar);
      tempCar.applyPedestrianBehaviors(pedestrian);

      float dist = PVector.dist(tempCar.carPath.points.get(3), tempCar.position);

      // check if the car has almost arrived to destination 
      if (dist < 50) {
        // drop the pedestrian off
        pedestrian.canBePickedUp = true;
        pedestrian.reset();
      }
    }

    // if scenario is city traffic
    if (scenario == 'C') {
      /// ambulance run loop
      if (Ambulances.size() >0) {
        for (int a = 0; a< Ambulances.size(); a++) {
          // update the ambulance
          Ambulances.get(a).update();
          Ambulances.get(a).applyBehaviors(Cars);

          //display the ambulance
          Ambulances.get(a).display();
        }
      }
    }
  }

  //---------------------------------------------------------------
  // Method to setting car population , used by the gui
  //---------------------------------------------------------------

  void setCarPopulation(int incomingCarNumber)
  {
    // if it recives 1, increase the car number
    if (incomingCarNumber ==1) {
      // add a car to the arraylist
      getCar();
      // update the car population 
      CarPopulation = Cars.size() ;
    }
    // if it recives 0, decrease the car population
    else if (incomingCarNumber == 0 ) {
      // if in the parking scenario, trigger event to make a car leave the parking
      if (scenario == 'P') {
        triggerEvent();
        CarPopulation = Cars.size() ;
      }
      // in all other scenario, 
      else {
        // remove the last car from the arraylist
        Cars.remove(CarPopulation-1);
        // update the car population 
        CarPopulation = Cars.size() ;
      }
    }
  }


  //---------------------------------------------------------------
  // method for setting up speed limit for all cars, used by the gui
  //---------------------------------------------------------------

  void setCarSpeedLimit(float carSpeedLimit)
  {
    // for every car, set the speed to the new speed
    for (int i = 0; i < CarPopulation; i ++) {
      Cars.get(i).setCarSpeedLimit(carSpeedLimit);
    }
  }


  //---------------------------------------------------------------
  // method for setting up Steering limit for all cars, used by the gui
  //---------------------------------------------------------------

  void setCarSteerLimit(float SteerLimit)
  {
    // for every car, set the steer limit to the new steer limit
    for (int i = 0; i < CarPopulation; i ++) {
      Cars.get(i).setCarSteerLimit(SteerLimit);
    }
  }

  //---------------------------------------------------------------
  // method for trigger specific event for each scenario , used by the gui
  //---------------------------------------------------------------
  void triggerEvent() {
    // for the city scenario
    if (carScenario == 'C') {
      // if there is les than 2 ambulances
      if (Ambulances.size()<2) {
        // add an ambulance
        Ambulances.add(new EmergencyVehicle(1));
      }
    }

    // for the parking scenario
    if (carScenario == 'P') {
      // boolean to know if a car has left, used to exit the while loop
      boolean carLeft = false;
      // counter for the while loop
      int counter = 0;
      // an  int to select a random car
      int randomCar;
      // int to send a parking ID to the car so it knows whitch parking spot it is on
      int parkingId;

      // while loop to search for a car
      while (carLeft == false) {
        // select a random number
        randomCar = round(random(0, CarPopulation-1));
        // increment the car
        counter ++;
        // check if the car is parked
        if (Cars.get(randomCar).parked == true) {
          // give that car a new destination 
          Cars.get(randomCar).getDestination(Cars.get(randomCar).position);

          parkingId = Cars.get(randomCar).getParkingId();
          // make the parking spot not busy
          parkingSystem.get(parkingId).useParking(false);
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

      int Yoffset = int(random(0, 4));
      int northSouth = (int)random(-2, 3);
      if (northSouth == 0 ) {
        northSouth=-1;
      }
      if (northSouth == 2 ) {
        northSouth = 1;
      }


      randomX = int(random(0, width));

      randomY = height/2 + northSouth*(60+40*Yoffset);
      Accident = new PVector(randomX, randomY);
    }

    if (carScenario == 'S') {
      toggle = true;
      if (toggle = true) {
        int offset = 15;
        int randomize = (int)random(0, 2);
        int mult = 0;
        if (randomize == 0 ) {
          mult = -1;
        }
        if (randomize == 1 ) {
          mult = 1;
        }
        randomX = cityGridSize* round(random(-1, width/cityGridSize)+1)+mult*offset;
        randomY = cityGridSize* round(random(-1, height/cityGridSize)+1)+mult*offset;
        pedestrian = new Pedestrian (new PVector(randomX, randomY));
      }
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
      int parkingCounter = 0;
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
        if (parkingSystem.get(parkingCounter).getParkingState() == false) {
          // get the parking spots position
          parkPos = parkingSystem.get(parkingCounter).getParkingPosition();
          // and a new car and assigne a parking spot to him
          Cars.add(new ParkingCar(carID, parkStart, parkPos, parkingCounter));
          // make that parking spot busy
          parkingSystem.get(parkingCounter).useParking(true);
          // increment the car ID
          carID ++;
          // exit the while loop
          foundSpot = true;
        }

        // if all the parking spots are full, exit the while loop
        else if (parkingCounter> CarPopulation) {
          foundSpot = true;
          //println("parking is full!");
        }
        // increment the parking Counter
        parkingCounter ++;
      }

      break;

    case 'H': 
      Cars.add(new HighwayCar(carID));
      carID ++;

      break;

    case 'S':
      Cars.add(new CityCar(carID));
      carID ++; 
      break;

    default:             // Default executes if the case labels
      // println("Scenario : None");   
      break;
    }
  }
}

