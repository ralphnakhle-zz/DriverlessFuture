
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

    pedestrian = new Pedestrian (new PVector(width/2, height/2));

    accidentClass = new AccidentClass();

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
      //update position
      Cars.get(i).update();
      //display the car

      Cars.get(i).display();

      Cars.get(i).applyBehaviors(Cars);

      if (scenario == 'H') {

        Cars.get(i).applyAccidentBehaviors(Accident);
        accidentClass.displayAccident(randomX, randomY);
      }

      if (scenario == 'S') {

        if (pedestrian.pickedUp == false && pedestrian.canBePickedUp == true) {

          if (Cars.get(i).findTargetCarfromPedestrian(pedestrian) == true) { 
            tempCar = Cars.get(i);
            println("picked up");
          }
        }

        pedestrian.display();
      }
    }

    if (pedestrian.pickedUp==true && scenario=='S')
    {

      pedestrian.update(tempCar);
      tempCar.applyPedestrianBehaviors(pedestrian);

      float dist = PVector.dist(tempCar.carDestination, tempCar.position);

      println(dist);
      if (dist < 50) {
        println(pedestrian.canBePickedUp);
        pedestrian.reset();
      }
    }
  
  
  if (scenario == 'C') {
   if (Ambulances.size() >0) {
   for (int a = 0; a< Ambulances.size(); a++) {
   Ambulances.get(a).update();
   //display the car
   Ambulances.get(a).display();
   Ambulances.get(a).applyBehaviors(Ambulances);
   }
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
        print("add car");
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
      //println(northSouth);
    }

    if (carScenario == 'S') {

    }
  }

  void triggerPedestrian() {


    //      if (pedestrian.pickedUp == false && pedestrian.canBePickedUp == true) {
    //
    //        if (Cars.get(i).findTargetCarfromPedestrian(pedestrian) == true) { 
    //          tempCar = Cars.get(i);
    //          println("picked up");
    //        }
    //      }
    //
    //      pedestrian.display();



    if (pedestrian.pickedUp==true && scenario=='S')
    {

      pedestrian.update(tempCar);
      tempCar.applyPedestrianBehaviors(pedestrian);

      float dist = PVector.dist(tempCar.carDestination, tempCar.position);

      println(dist);
      if (dist < 50) {
        println(pedestrian.canBePickedUp);
        pedestrian.reset();
      }
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
      // println("Scenario : P");  
      break;

    case 'H':
      Cars.add(new HighwayCar());

      break;

    case 'S':
      Cars.add(new CityCar()); 
      break;

    default:             // Default executes if the case labels
      // println("Scenario : None");   
      break;
    }
  }
}

