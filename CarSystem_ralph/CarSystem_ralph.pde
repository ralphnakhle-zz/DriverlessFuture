
class CarSystem 
{
  int CarPopulation;  

  //List Array containing the cars
  ArrayList <Car> Cars;

 

    // Constructor for the CarSystem class
  CarSystem() {
    //set variable Car population
    CarPopulation = 40;
    // initialize our array list of "Cars"
    Cars = new ArrayList<Car>();
  }

  //---------------------------------------------------------------
  // Initialize method to add the default number of cars
  //---------------------------------------------------------------

  void init() {
    for (int i = 0; i < CarPopulation; i ++) {
      //create new car
      Cars.add(new CityCar());
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
        Cars.add(new CityCar());
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
}

