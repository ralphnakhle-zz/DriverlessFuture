
class CarSystem 
{
  int CarPopulation;  

  //List Array containing the cars
  ArrayList <Car> Cars;

  // Vector for origine
  PVector origine;
  // Vector for destination
  PVector destination;

  Path systemPath ;
  // Constructor for the CarSystem class
  CarSystem(Path tempPath) {
    //set variable Car population
    CarPopulation = 30;
    systemPath = tempPath;
    // initialize our array list of "Cars"
    Cars = new ArrayList<Car>();
  }

  //---------------------------------------------------------------
  // Initialize method to add the default number of cars
  //---------------------------------------------------------------

  void init() {
    for (int i = 0; i < CarPopulation; i ++) {
      //create new car
      Cars.add(new Car());
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

      Cars.get(i).follow(systemPath);
    }
  }
}

