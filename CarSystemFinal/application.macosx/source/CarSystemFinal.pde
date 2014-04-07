
class CarSystem 
{
  int CarPopulation;

  //List Array containing the cars
  ArrayList <Car> Cars;
  ArrayList <Car> Ambulances;
  PVector Accident;

  int testColor = 0;
  int accidentXposition = -10;
  char carScenario;
  int randomX;
  int randomY;

  // parking variables
  PVector parkPos;
  PVector parkStart;
  int parkingOffset = 40;

  ArrayList <ParkingSpot> parkingSystem;

  int carID = 0;

  boolean toggle = false;

  Car tempCar;

  Pedestrian pedestrian;

  AccidentClass accidentClass;

  // Constructor for the CarSystem class
  CarSystem(char scenario_) {
    //set variable Car population
    CarPopulation = 40;
    // initialize our array list of "Cars"
    Cars = new ArrayList<Car>();
    Ambulances = new ArrayList<Car>();
    Accident = new PVector(width/2, height/2);
    parkingSystem = new ArrayList<ParkingSpot>();
    pedestrian = new Pedestrian (new PVector(width/2+10, height/2));
    accidentClass = new AccidentClass();
    carScenario = scenario_;
  }

  //---------------------------------------------------------------
  // Initialize method to add the default number of cars
  //---------------------------------------------------------------

  void init() {

    PVector parkingPosition;
    for (int p = 0; p < 10; p ++) {
      for (int pR = 0; pR < 10; pR ++) {
        parkingPosition = new PVector(width /2+300 - 60*p, height/2-300+ pR*52);
        parkingSystem.add(new ParkingSpot(parkingPosition, false));
      }
    }

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
  // method to display our car system
  //---------------------------------------------------------------

  void run()
  {
    for (int i = 0; i< CarPopulation; i++) {

      if (scenario == 'P' && Cars.get(i).trash()) {
        Cars.remove(i);
        CarPopulation = Cars.size() ;
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

      if (scenario == 'H') {

        Cars.get(i).applyAccidentBehaviors(Accident);
        accidentClass.displayAccident(randomX, randomY);
      }
      // trigger condition
      if (scenario == 'S' && toggle == true) {

        if (pedestrian.pickedUp == false && pedestrian.canBePickedUp == true) {

          if (Cars.get(i).findTargetCarfromPedestrian(pedestrian) == true) { 
            tempCar = Cars.get(i);
            //println("picked up");
          }
        }
        pedestrian.display();
      }
    }

    if (pedestrian.pickedUp==true && scenario=='S')
    {

      pedestrian.update(tempCar);
      tempCar.applyPedestrianBehaviors(pedestrian);

      float dist = PVector.dist(tempCar.carPath.points.get(3), tempCar.position);

      println(dist);
      if (dist < 50) {
        println(pedestrian.canBePickedUp);

        pedestrian.canBePickedUp = true;
        //pedestrian.pickedUp=false;
        pedestrian.reset();
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

  void setCarPopulation(int incomingCarNumber)
  {
    if (incomingCarNumber ==1) {

      getCar();
      CarPopulation = Cars.size() ;
      println("ADD in class system carNumer::" + CarPopulation );
    }
    else if (incomingCarNumber == 0 ) {
      if (scenario == 'P') {
        triggerEvent();
        CarPopulation = Cars.size() ;
      }
      else {
        Cars.remove(CarPopulation-1);
        CarPopulation = Cars.size() ;
        println("REMOVE in class system carNumer::" + CarPopulation );
      }
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
      if (Ambulances.size()<1) {
        Ambulances.add(new EmergencyVehicle(1));
        // println("Ambulance!");
      }
    }


    if (carScenario == 'P') {
      boolean carLeft = false;
      int counter = 0;
      int randomCar ;
      int parkingId;
      while (carLeft == false) {
        randomCar = round(random(0, CarPopulation-1));
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
      testColor = 255;
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

