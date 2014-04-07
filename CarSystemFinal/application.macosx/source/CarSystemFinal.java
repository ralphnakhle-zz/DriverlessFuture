import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class CarSystemFinal extends PApplet {


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

  public void init() {

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
  public int getCarPopulation () {
    return CarPopulation;
  }


  //---------------------------------------------------------------
  // method to display our car system
  //---------------------------------------------------------------

  public void run()
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

  public void setCarPopulation(int incomingCarNumber)
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

  public void setCarSpeedLimit(float carSpeedLimit)
  {
    for (int i = 0; i < CarPopulation; i ++) {
      Cars.get(i).setCarSpeedLimit(carSpeedLimit);
    }
  }


  //---------------------------------------------------------------
  // method for setting up Steering limit for all cars
  //---------------------------------------------------------------

  public void setCarSteerLimit(float SteerLimit)
  {
    for (int i = 0; i < CarPopulation; i ++) {
      Cars.get(i).setCarSteerLimit(SteerLimit);
    }
  }

  //---------------------------------------------------------------
  // method for trigger event 
  //---------------------------------------------------------------
  public void triggerEvent() {
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

      int Yoffset = PApplet.parseInt(random(0, 4));
      int northSouth = (int)random(-2, 3);
      if (northSouth == 0 ) {
        northSouth=-1;
      }
      if (northSouth == 2 ) {
        northSouth = 1;
      }


      randomX = PApplet.parseInt(random(0, width));

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
  public void getCar() {
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


class AccidentClass {
  
  AccidentClass() {
  
  }
  
  //Method displaying accident 
  public void displayAccident(int randomX, int randomY) {
  
    fill(255, 165, 0);
    int cone = 7;
    triangle(randomX-cone,randomY+cone,randomX+cone,randomY+cone,randomX,randomY-cone*2);
    ellipse(randomX,randomY+cone,cone*3,cone/1.5f);
    fill(255);
        ellipse(randomX,randomY,cone*1.5f,cone/2);

    //ellipse(randomX, randomY, 20, 20);
  }
}

//Based on Path Following
// by Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code

class CarPath {

  // A Road is an arraylist of points (PVector objects)
  ArrayList<PVector> points;
  // A Road has a radius, i.e how far is it ok for the boid to wander off
  float radius;
  PVector start;
  PVector end;
  int offsetDistance;
  CarPath(PVector start_, PVector end_, int offsetDistance_) {

    points = new ArrayList<PVector>();
    start = start_.get();
    end = end_.get();
    offsetDistance = offsetDistance_;
    generatePath();
    
  }
  public int getSize() {
    int size = points.size();
    return size;
  }
  public void generatePath() {
    PVector offset = new PVector(0, 0);
    // end without offset
    PVector realEnd = end.get();

    if (end.x>start.x) {
      offset.add(new PVector(0, offsetDistance));
    }
    else if (end.x<start.x) {
      offset.add(new PVector(0, -offsetDistance));
    }
    if (end.y>=start.y) {
      offset.add(new PVector(-offsetDistance, 0));
    }
    else if (end.y<start.y) {
      offset.add(new PVector(offsetDistance, 0));
    }
    // println("offset: "+ offset.x + ", " + offset.y);

    start.add(offset);
    end.add(offset);

    PVector middle = new PVector(end.x, start.y);

    points.add(start);
    points.add(middle);
    points.add(end);
    points.add(realEnd);
  }
}


abstract class Car {

  // Car position
  PVector position;

  //  change in position
  PVector velocity = new PVector(0, 0);
  // change in velocity
  PVector acceleration= new PVector(0, 0);

  // Radius of the Car
  float carRadius = 6;

  // car safe zone
  float safeZone;

  // variable for speed limit
  float speedLimit = 3;

  // Maximum steering force
  float steerLimit = 0.3f;  

  // car color
  int carColor = color(60, 155, 216);

  // car target and origine
  PVector carDestination;

  // car Angle
  float carAngle = velocity.heading2D() + PI/2;
  float targetCarAngle = 0;
  float easing = 0.2f;

  //car path
  CarPath carPath;
  int pathIndex = 1;

  boolean parked = false;
  boolean trashIt = false;


  int carID;



  // constructor
  Car(int id) {
    // give starting position for the car
    position = getDestination(new PVector(0, 0));
    // get a first destination for the car
    carDestination = getDestination(position);

    safeZone = 100;

    carID = id;
  }

  public int getParkingId() {
    return 0 ;
  }

  // update methode
  public void update() {
    velocity.add(acceleration);
    // limit the velocity to the maximum speed alowd
    velocity.limit(speedLimit);
    // add the velocity to the position
    position.add(velocity);
    // reset acceleration
    acceleration.mult(0);
  }


  public void applyBehaviors(ArrayList<Car> Cars) {
    PVector separateForce = separate(Cars);

    followPath();
    applyForce(separateForce);
  }

  public void applyBehaviors(ArrayList<Car> Cars, ArrayList<Car> Amb) {
  }


  public void applyPedestrianBehaviors(Pedestrian pedestrian) {
    PVector separateForce = separateFromPedestrian(pedestrian);   
    followPath();
    applyForce(separateForce);
  }

  // apply Force methode
  public void applyForce(PVector force) {
    acceleration.add(force);
  }

  // a methode to remove unwatned cars
  public boolean trash() {
    if (trashIt) {
      return true;
    }
    else { 
      return false;
    }
  }

  // ----------------------------------------------------------------------
  //  Car display
  // ----------------------------------------------------------------------  
  public void display() {
    // draw debuging info
    if (debug) {
      stroke(255, 60, 0, 80);

      strokeWeight(1);
      for (int v = 0; v < carPath.getSize()-1; v++ ) {
        line(carPath.points.get(v).x, carPath.points.get(v).y, carPath.points.get(v+1).x, carPath.points.get(v+1).y);
      }
    }
    // draw car

    fill(carColor);
    noStroke();

    if (velocity.mag()<=0) {
      carAngle = 0;
    }
    else {
      carAngle = velocity.heading() + PI/2;
    }

    float dir = (carAngle - targetCarAngle) / TWO_PI;
    dir -= round( dir );
    dir *= TWO_PI;

    targetCarAngle += dir * easing;


    pushMatrix();
    translate(position.x, position.y);
    rotate(targetCarAngle);
    beginShape();
    rectMode(CENTER);
    //rect(0, carRadius/2, carRadius, carRadius*2);
    //fill(200);
    
    if (velocity.mag() < speedLimit/2) {
      fill(200);
    }
    else {      
      fill(200);
    if (frameCount % 2== 0) {
      fill(150);
    }
    }
    ellipse(carRadius/2.5f, carRadius, carRadius/2, carRadius/2 );
    ellipse(-carRadius/2.5f, carRadius, carRadius/2, carRadius/2 );
    ellipse(-carRadius/3, -carRadius/3, carRadius/2, carRadius/2 );
    ellipse(carRadius/3, -carRadius/3, carRadius/2, carRadius/2 );
    fill(carColor);
    ellipse(0, carRadius/2, carRadius*1.2f, carRadius*2.5f );
    //fill(60, 200, 255);
    //ellipse(0, -carRadius/10, carRadius*1, carRadius*0.8 );
    if (velocity.mag() < speedLimit/2) {
      fill(255, 50, 0);
    }
    else {      
      fill(255, 150, 150);
    }
    ellipse(-carRadius/4, carRadius*1.5f, carRadius/2.5f, carRadius/2.5f);
    ellipse(carRadius/4, carRadius*1.5f, carRadius/2.5f, carRadius/2.5f);
    fill(255);
    //ellipse(0, 0-carRadius/2, carRadius/1.2, carRadius/2);
    endShape(CLOSE);
    popMatrix();
  }



  // ----------------------------------------------------------------------
  //  Go towards destination code & Path following
  // ----------------------------------------------------------------------
  // A method that calculates a steering force towards a target and following a path

  public void followPath() {
    // PVector for the desired position
    PVector desired;
    // A vector pointing from the position to the first point of the path
    desired = PVector.sub(carPath.points.get(pathIndex), position); 

    // if the car is close enought to the first point  and is still in the first section
    if (desired.mag()<30 && pathIndex == 1) {  
      pathIndex = 2;  
      desired = PVector.sub(carPath.points.get(pathIndex), position);
    }
    // if the car is close to the final target of the path
    if (desired.mag()<30 && pathIndex == 2) { 
      // generate new destination, send the real end as a starting point 
      getDestination(carPath.points.get(3));
      // reset the path index to 1
      pathIndex = 1;
    }

    // Predict location 20 (arbitrary choice) frames ahead
    PVector predict = velocity.get();
    predict.normalize();
    predict.mult(20);
    PVector predictLoc = PVector.add(position, predict);
    // Look at the line segment
    PVector a = carPath.points.get(pathIndex-1);
    PVector b = carPath.points.get(pathIndex);

    // Get the normal point to that line
    PVector normalPoint = getNormalPoint(predictLoc, a, b);


    // Find target point a little further ahead of normal
    PVector dir = PVector.sub(b, a);
    dir.normalize();
    dir.mult(10);  // This could be based on velocity instead of just an arbitrary 10 pixels
    PVector target = PVector.add(normalPoint, dir);

    // How far away are we from the path?
    float distance = PVector.dist(predictLoc, normalPoint);

    seek(target);
  }



  // A function to get the normal point from a point (p) to a line segment (a-b)
  // This function could be optimized to make fewer new Vector objects
  public PVector getNormalPoint(PVector p, PVector a, PVector b) {
    // Vector from a to p
    PVector ap = PVector.sub(p, a);
    // Vector from a to b
    PVector ab = PVector.sub(b, a);
    ab.normalize(); // Normalize the line
    // Project vector "diff" onto line by using the dot product
    ab.mult(ap.dot(ab));
    PVector normalPoint = PVector.add(a, ab);
    return normalPoint;
  }

  // used for the path following code
  public void seek(PVector target) {
    PVector desired = PVector.sub(target, position);  // A vector pointing from the position to the target
    // If the magnitude of desired equals 0, skip out of here
    if (desired.mag() == 0) return;

    // Normalize desired and scale to maximum speed
    desired.normalize();
    desired.mult(speedLimit);
    // Steering = Desired minus Velocity
    PVector steer = PVector.sub(desired, velocity);
    steer.limit(steerLimit);  // Limit to maximum steering force
    applyForce(steer);
  }


  // ----------------------------------------------------------------------
  //  Interaction with other cars
  // ----------------------------------------------------------------------
  // Separation
  // Method checks for nearby vehicles and steers away
  public PVector separate (ArrayList<Car> cars) {

    float safeAngle = PI/6;
    PVector sForce = new PVector(0, 0);


    // For every boid in the system, check if it's too close
    for (Car other : cars) {
      // get the distance between the two cars
      float distance = PVector.dist(position, other.position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)

      if (carID != other.carID && (distance < safeZone)) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, other.position);


        float mainCarAngle = velocity.heading()+PI;
        float otherCarAngle = diff.heading();
        float multiplier;
        // convert car angle 
        mainCarAngle = map(mainCarAngle, -PI, PI, 0, TWO_PI);
        otherCarAngle = map(otherCarAngle, -PI, PI, 0, TWO_PI);

        diff.normalize();
        diff.div(8);

        // check if the other car is in front of this car
        if (otherCarAngle < mainCarAngle+safeAngle &&  otherCarAngle > mainCarAngle-safeAngle) {
          multiplier = 100/distance;
          constrain(multiplier, 0, 15);
          diff.mult(multiplier);

          // graphical debuging
          if (debug) {
            fill(100, 30);
            noStroke();
            arc(position.x, position.y, safeZone*2, safeZone*2, mainCarAngle-safeAngle, mainCarAngle+safeAngle, PIE);
          }
        }
        sForce = diff.get();
        if (sForce.mag() > velocity.mag()) {
          sForce = velocity.get();
          sForce.mult(-1);
        }
      }
    }


    return sForce;
  }



  public boolean findTargetCarfromPedestrian(Pedestrian p) {
    safeZone = 10;
    float safeAngle = PI/6;
    PVector sForce = new PVector(0, 0);
    float distance = PVector.dist(position, p.location);

    if (distance < safeZone) {

      p.setPickedUp(true, velocity);
      velocity.mult(0);
      return true;
    }
    return false;
  }

  // ----------------------------------------------------------------------
  //  Interaction with Pedestrian
  // ----------------------------------------------------------------------
  // Separation
  // Method checks for nearby vehicles and steers away
  public PVector separateFromPedestrian (Pedestrian pedestrian) {
    PVector sForce = new PVector(0, 0);
    PVector diff = PVector.sub(position, pedestrian.location);

    if (pedestrian.location == position) {
    }
    return sForce;
  }





  //---------------------------------------------------------------
  // method to create random origine and destinations for the accident
  //---------------------------------------------------------------

  public void applyAccidentBehaviors(PVector Accident) {
  } 


  //---------------------------------------------------------------
  // method to create random origine and destinations for the cars
  //---------------------------------------------------------------

  public abstract PVector getDestination( PVector lastDestination); 

  public void getDestination( PVector lastDestination, PVector finalDestination) {
  }

  //----------------------------------------------------------------------
  // method to set car speed limit - so it can be accessed from the Car System then the Gui - 
  //----------------------------------------------------------------------

  public void setCarSpeedLimit(float incomingCarSpeedLimit)
  {
    speedLimit = incomingCarSpeedLimit;
  }

  //----------------------------------------------------------------------
  // method to set car steering limit - so it can be accessed from the Car System then the Gui
  //----------------------------------------------------------------------

  public void setCarSteerLimit(float incomingCarSteerLimit)
  {
    steerLimit = incomingCarSteerLimit;
  }
}

class CityBg {

  // A Road is an arraylist of points (PVector objects)
  ArrayList<PVector> points;
  // A Road has a radius, i.e how far is it ok for the boid to wander off
  float roadWidth;
  int grid;

  CityBg() {
    //  radius of 20
    roadWidth = 20;
    points = new ArrayList<PVector>();
    grid = 180;
  }

  public float getGridSize() {
    return grid;
  }


  // Draw the Road
  public void display() {
    // Draw Roads

    rectMode(CENTER);
    stroke(50);
    strokeWeight(2);
    fill(0);
    for (int bv = 0; bv < width/grid; bv++ ) {
      for (int bh = 0; bh < height/grid+1; bh++ ) {
        rect(grid*bv+grid/2, grid*bh + grid/2, grid-roadWidth*2, grid-roadWidth*2);
      }
    }

    /// draw dot grid
    strokeWeight(2);
    stroke(255, 50);
    for ( int h = 0; h< width/roadWidth; h++) {
      for ( int v = 0; v< height/roadWidth; v++) {
        point(roadWidth*h, roadWidth*v);
      }
    }

    // draw buildings
   // displayBuildings();
  }


  public void displayBuildings() {
    int buildingN = 10;
    float buildingSize = grid*0.5f;
    float offsetX=0;
    float offsetY=0;
    float buildingHeight;

    for (int bv = 0; bv < buildingN; bv++ ) {
      for (int bh = 0; bh < buildingN-1; bh++ ) {
        // randomSeed(1000);
        buildingHeight = 0.15f;
        rectMode(CENTER);
        noStroke();
        fill(25, 180);
        offsetX = (grid*bv-width/2)*buildingHeight;
        offsetY = (grid*bh-height/2)*buildingHeight;

        rect(grid*bv+grid/2, grid*bh+ grid/2, buildingSize, buildingSize);
        beginShape();
        vertex(grid*bv+grid/2-buildingSize/2, grid*bh+grid/2-buildingSize/2);
        vertex(grid*bv+grid/2-buildingSize/2+offsetX, grid*bh+grid/2-buildingSize/2+offsetY);

        vertex(grid*bv+grid/2+buildingSize/2+offsetX, grid*bh+grid/2+buildingSize/2+offsetY);
        vertex(grid*bv+grid/2+buildingSize/2, grid*bh+grid/2+buildingSize/2);
        endShape(CLOSE);

        beginShape();
        vertex(grid*bv+grid/2+buildingSize/2, grid*bh+grid/2-buildingSize/2);
        vertex(grid*bv+grid/2+buildingSize/2+offsetX, grid*bh+grid/2-buildingSize/2+offsetY);

        vertex(grid*bv+grid/2-buildingSize/2+offsetX, grid*bh+grid/2+buildingSize/2+offsetY);
        vertex(grid*bv+grid/2-buildingSize/2, grid*bh+grid/2+buildingSize/2);
        endShape(CLOSE);
        stroke(60);
        //strokeWeight(1.5);
        noStroke();
        fill(50, 180);
        rect(grid*bv+grid/2+offsetX, grid*bh+ grid/2+offsetY, buildingSize, buildingSize);
      }
    }
  }
}

// a subclass of car for city cars
class CityCar extends Car {

  float gridSize;
  CityBg cityBg ;


  CityCar(int id) {
    super(id);
    cityBg = new CityBg();
  }

  public void applyBehaviors(ArrayList<Car> Cars, ArrayList<Car> Ambulance) {
    PVector separateForce = separate(Cars);
    PVector separateFromAmbulanceForce = separateFromAmbulance(Ambulance);

    followPath();
    applyForce(separateForce);
    applyForce(separateFromAmbulanceForce);
  }


  // ----------------------------------------------------------------------
  //  Interaction with ambulance
  // ----------------------------------------------------------------------
  // Separation
  // Method checks for nearby vehicles and steers away
  public PVector separateFromAmbulance (ArrayList<Car> ambulance) {
    // calculate the safe zone
    safeZone = 80;
    PVector sForce = new PVector(0, 0);
    float multiplier;

    for (int a =0; a< ambulance.size(); a++) {

      // get the distance between the two cars
      float distance = PVector.dist(position, ambulance.get(a).position);
      // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)

      if (distance < safeZone) {
        // Calculate vector pointing away from neighbor
        PVector diff = PVector.sub(position, ambulance.get(a).position);
        // check if the other car is in front of this car
        diff.normalize();
        multiplier = 80/distance;
        constrain(multiplier, 0, 5);
        diff.mult(multiplier);
        // if the car is straight in front..
        sForce = diff.get();
        
        if (sForce.mag() > velocity.mag()) {
          sForce = velocity.get();
          sForce.mult(-1);
        }
      }
    }
    return sForce;
  }

  //---------------------------------------------------------------
  // method to create random origine and destinations for the cars
  //---------------------------------------------------------------

  public PVector getDestination( PVector lastDestination) {
    PVector tempDestination = new PVector(0, 0);
    float randomX;
    float randomY;
    // gridSize = cityBg.getGridSize();
    gridSize = 180;
    randomX = gridSize* round(random(-1, width/gridSize)+1);
    randomY = gridSize* round(random(-1, height/gridSize)+1);

    tempDestination = new PVector(randomX, randomY);

    // create a path to follow
    carPath = new CarPath(lastDestination, tempDestination, 10);

    return tempDestination;
  }
}

// a subclass of car for city cars
class EmergencyVehicle extends Car {

  int gridSize;

  EmergencyVehicle(int id) {
    super(id);

    steerLimit = 0.8f;  
    easing = 0.3f;
  }

  // update methode
  public void update() {
    velocity.add(acceleration);

    velocity.mult(1.8f);
    // limit the velocity to the maximum speed alowd
    velocity.limit(speedLimit*1.5f);
    // add the velocity to the position
    position.add(velocity);
    // reset acceleration
    acceleration.mult(0);
    
    carRadius = 10;
  }



  // ----------------------------------------------------------------------
  //  Car display
  // ----------------------------------------------------------------------  
  public void display() {
    fill(250, 230, 0);
    noStroke();
    int AmbSize = 9;
    carAngle = velocity.heading() + PI/2;

    float dir = (carAngle - targetCarAngle) / TWO_PI;
    dir -= round( dir );
    dir *= TWO_PI;

    targetCarAngle += dir * easing;

   pushMatrix();
    translate(position.x, position.y);
    rotate(targetCarAngle);
    beginShape();
    rectMode(CENTER);
    //rect(0, carRadius/2, carRadius, carRadius*2);
    //fill(200);
    
    if (velocity.mag() < speedLimit/2) {
      fill(200);
    }
    else {      
      fill(200);
    if (frameCount % 2== 0) {
      fill(150);
    }
    }
    ellipse(carRadius/2.5f, carRadius, carRadius/2, carRadius/2 );
    ellipse(-carRadius/2.5f, carRadius, carRadius/2, carRadius/2 );
    ellipse(-carRadius/3, -carRadius/3, carRadius/2, carRadius/2 );
    ellipse(carRadius/3, -carRadius/3, carRadius/2, carRadius/2 );
    fill(250, 230, 0);
    ellipse(0, carRadius/2, carRadius*1.2f, carRadius*2.5f );
    //fill(60, 200, 255);
    //ellipse(0, -carRadius/10, carRadius*1, carRadius*0.8 );
    if (velocity.mag() < speedLimit/2) {
      fill(255, 50, 0);
    }
    else {      
      fill(255, 150, 150);
    }
    ellipse(-carRadius/4, carRadius*1.5f, carRadius/2.5f, carRadius/2.5f);
    ellipse(carRadius/4, carRadius*1.5f, carRadius/2.5f, carRadius/2.5f);
    fill(255);
    //ellipse(0, 0-carRadius/2, carRadius/1.2, carRadius/2);
    // blinking red cross
    fill(250, 150, 0);
    if (frameCount % 4== 0) {
      fill(250, 50, 0);
    }
    rect(0, AmbSize/2, AmbSize/1.5f, AmbSize/4);
    rect(0, AmbSize/2, AmbSize/4, AmbSize/1.5f);
    endShape(CLOSE);
    popMatrix();
  }

  //---------------------------------------------------------------
  // method to create random origine and destinations for the cars
  //---------------------------------------------------------------

  public PVector getDestination( PVector lastDestination) {
    PVector tempDestination = new PVector(0, 0);
    float randomX;
    float randomY;
    gridSize = 180;
    randomX = gridSize* round(random(1, width/gridSize));
    randomY = gridSize* round(random(1, height/gridSize));

    tempDestination = new PVector(randomX, randomY);

    // create a path to follow
    carPath = new CarPath(lastDestination, tempDestination, 0);

    return tempDestination;
  }
}

// ----------------------------------------------------------------------
//  GUI class
// ----------------------------------------------------------------------

class GUI {

  int controlMargin = width-width/10+60;
  int carNumber = 40;
  float speedLimit = 3;
  float steeringLimit = 0.3f;
  float alpha;
  String text;

  // ----------------------------------------------------------------------
  //  GUI KNOBS
  // ----------------------------------------------------------------------
  // 
  GUI() {
  }

  public void display() {
    rectMode(CORNER);
    strokeWeight(1);
    //Side bar display 
    noStroke();
    fill(50, 200);
    rect(width, 0, -width/12, height);

    //Header:
    fill(250, 200, 10, 250);
    rect(width, 0, -width/12, 30);
    fill(0);
    textSize(10);
    text("Driverless Future", controlMargin, 20);

    // City Traffic Tab / Button
    textSize(12);
    fill(255, 200);
    text("City Traffic", controlMargin, 50);
    rect(controlMargin, 60, 50, 50, 7 );

    // HighWay Tab / Button
    text("Highway", controlMargin, 130);
    rect(controlMargin, 140, 50, 50, 7 );

    // Parking Tab / Button
    text("Parking", controlMargin, 210);
    rect(controlMargin, 220, 50, 50, 7 );

    // Shared Autos Tab / Button
    text("Shared Autos", controlMargin, 290);
    rect(controlMargin, 300, 50, 50, 7);

    //Midline gui stroke
    stroke(0);
    line (controlMargin-10, 360, controlMargin+100, 360);

    // Event Trigger Button
    noStroke();
    text("Event Trigger", controlMargin, 385);
    fill(255, 0, 0, 80);
    rect(controlMargin, 395, 50, 50, 7);

    //Midline gui stroke
    stroke(0);
    line (controlMargin-10, 455, controlMargin+100, 455);

    //fixed Controls:
    //Car Population----
    noStroke();
    fill(255, 200);
    text("Population", controlMargin, 480); 
    //Plus minus rectangles
    fill(255, 200);
    rect(controlMargin, 491, 26, 26, 4);
    rect(controlMargin+40, 489, 30, 30, 4);

    //Speed----
    noStroke();
    text("Speed", controlMargin, 540); 
    //Plus minus rectangles
    rect(controlMargin, 551, 26, 26, 4);
    rect(controlMargin+40, 549, 30, 30, 4);

    //Steering----
    noStroke();
    text("Steering", controlMargin, 600); 
    //Plus minus rectangles
    rect(controlMargin, 611, 26, 26, 4);
    rect(controlMargin+40, 609, 30, 30, 4);
    textSize(16);
    int offset = 50;

    if (scenario == 'C') {
      rectMode(CENTER);
      fill(250, 200, 10, alpha);
      rect(width/2, height/1.32f+offset, width/2, height/7, 5);

      fill(0, alpha);
      text("City Traffic", width/2.1f, height/1.4f+offset);
      text("The City traffic scenario illustrates the efficiency and security that a city with Driverless Cars ", width/3.2f, height/ 1.35f+offset);
      text("and no traffic lights would benefit from. You can trigger the event to launch an Ambulance,", width/3.2f, height/1.30f+offset);
      text("and see how cars react to it.", width/3.2f, height/1.25f+offset);
      alpha -= 0.4f;
    }  

    if (scenario == 'P') {
      //text = "Parking"
      rectMode(CENTER);
      fill(250, 200, 10, alpha);
      rect(width/2, height/1.32f+offset, width/2, height/7, 5);

      fill(0, alpha);
      text("Parking", width/2.1f, height/1.4f+offset);
      text("In the Parking scenario, proximity of cars and automatic access and exit in parking lots can save us", width/3.2f, height/ 1.35f+offset);
      text("a lot of space. By triggering the event button, the user can call his car from outside the parking.", width/3.2f, height/1.30f+offset);
      text("Increasing the car population allows you to add more cars and see how they react. ", width/3.2f, height/1.25f+offset);
      alpha -= 0.4f;
    }  

    if (scenario == 'H') {
      //text = "Highway";
      rectMode(CENTER);
      fill(250, 200, 10, alpha);
      rect(width/2, height/1.32f+offset, width/2, height/7, 5);

      fill(0, alpha);
      text("Highway", width/2.1f, height/1.4f+offset);
      text("The Highway scenario showcases the uniformity and time saving features that come with Driverless Cars.", width/3.2f, height/ 1.35f+offset);
      text("Once the event trigger is activated, a hazard will be simulated on the Highway, where ", width/3.2f, height/1.30f+offset);
      text("you can see how cars react to it.", width/3.2f, height/1.25f+offset);
      alpha -= 0.4f;
    }  

    if (scenario == 'S') {      
      rectMode(CENTER);
      fill(250, 200, 10, alpha);
      rect(width/2, height/1.32f+offset, width/2, height/7, 5);

      fill(0, alpha);
      text("Shared Autos", width/2.1f, height/1.4f+offset);
      text("The Shared Autos scenario illustrates a car system where Driverless Cars are not as much of a property,", width/3.5f, height/ 1.35f+offset);
      text("but more of a shared commodity. By triggering the event, you simulate a car user that gets picked up by any", width/3.5f, height/1.30f+offset);
      text("car and dropped off wherever he\u2019s going. The car is then available to pick up any other passengers calling it.", width/3.5f, height/1.25f+offset);
      alpha -= 0.4f;
    }  

    fill(0, alpha);
    //text(text, width/2, height/2.7);
  }

  public void activateToggle() {
    //--------------------------------------------------
    // Car Population Toggle Setup
    //--------------------------------------------------

    if (mouseX >= controlMargin && mouseX <= controlMargin+26 && mouseY >= 491 && mouseY <= 517 ) {
      if (systemOfCars.getCarPopulation()>=4) {
        // carNumber --;
        systemOfCars.setCarPopulation(0);
      }
    }

    if (mouseX >= controlMargin+40 && mouseX <= controlMargin+70 && mouseY >= 491 && mouseY <= 521) {
      if (systemOfCars.getCarPopulation() < 100) {
        //carNumber++;
        systemOfCars.setCarPopulation(1);
      }
    }

    //--------------------------------------------------
    // Car Speed Toggle Setup
    //--------------------------------------------------

    if (speedLimit >= 4.5f) {
      speedLimit = 4.5f;
    }
    if (scenario == 'P' && speedLimit >= 2.5f) {
      speedLimit = 2.5f;
    }

    if (speedLimit < 1) {
      speedLimit = 1;
    }

    if (mouseX >= controlMargin && mouseX <= controlMargin+26 && mouseY >= 551 && mouseY <= 577) {

      speedLimit -= 0.5f;

      systemOfCars.setCarSpeedLimit(speedLimit);
      println(speedLimit);
    }

    if (mouseX >= controlMargin+40 && mouseX <= controlMargin+70 && mouseY >= 551 && mouseY <= 581) {

      speedLimit += 0.5f;

      systemOfCars.setCarSpeedLimit(speedLimit);
      println(speedLimit);
    }


    //--------------------------------------------------
    // Car Steer Toggle Setup
    //--------------------------------------------------

    if (steeringLimit >= 1.5f) {
      steeringLimit = 1.5f;
    }

    if (steeringLimit < 0.5f) {
      steeringLimit = 0.5f;
    }

    if (mouseX >= controlMargin && mouseX <= controlMargin+26 && mouseY >= 611 && mouseY <= 637) {

      steeringLimit -= 0.1f;

      systemOfCars.setCarSteerLimit(steeringLimit);
      println(steeringLimit);
    }

    if (mouseX >= controlMargin+40 && mouseX <= controlMargin+70 && mouseY >= 611 && mouseY <= 641) {

      steeringLimit += 0.1f;

      systemOfCars.setCarSteerLimit(steeringLimit);
      println(steeringLimit);
    }
    //text(int(steeringLimit*10), controlMargin+50, 600);
  }

  public void mouseEvent() {
    // City traffic button
    if (mouseX >= controlMargin && mouseX <= controlMargin+50 && mouseY >= 50 && mouseY <= 110) {
      scenario = 'C';
      alpha = 255;
      carNumber = 40;
    }
    // Highway button
    if (mouseX >= controlMargin && mouseX <= controlMargin+50 && mouseY >= 140 && mouseY <= 190) {
      scenario = 'H';
      alpha = 255;
      carNumber = 40;
    }
    // Parking button
    if (mouseX >= controlMargin && mouseX <= controlMargin+50 && mouseY >= 220 && mouseY <= 270) {
      alpha = 255;
      scenario = 'P';
      carNumber = 40;
    }

    // Shared comodity button
    if (mouseX >= controlMargin && mouseX <= controlMargin+50 && mouseY >= 300 && mouseY <= 350) {
      scenario = 'S';
      alpha = 255;
      carNumber = 40;
    }


    // event triger
    if (mouseX >= controlMargin && mouseX <= controlMargin+50 && mouseY >= 395 && mouseY <= 445) {
      systemOfCars.triggerEvent();
    }
  }

  public void displayNumber() {
    textSize(12);
    fill(255);
    carNumber = systemOfCars.getCarPopulation();
    text(carNumber, controlMargin+65, 480);
    text(PApplet.parseInt(speedLimit*9) + "/mph", controlMargin+40, 540);
    text(PApplet.parseInt(steeringLimit*10), controlMargin+50, 600);
  }
}

//Based on Path Following
// by Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code

class HighwayBg {

  // A Road is an arraylist of points (PVector objects)
  ArrayList<PVector> points;
  // A Road has a radius, i.e how far is it ok for the boid to wander off
  float radius;

  HighwayBg(float r) {
    // Arbitrary radius of 20
    radius = r;
    points = new ArrayList<PVector>();
    newGrid(0);
  }

  // Add a point to the Road
  public void addPoint(float x, float y) {
    PVector point = new PVector(x, y);
    points.add(point);
  }
  // creates a grid of points for the road
  public void newGrid(int spacer) {

 addPoint(0,height/2);
 addPoint(width,height/2);
   
  }
  // Draw the Road
  public void display() {
    // Draw Roads
    stroke(255, 50);
    strokeWeight(20);
    noFill();
    
    //center line
    line(0, height/2, width, height/2);
    
    //bottom line
    line(0, height/2+200, width, height/2+200);
    
    //top line
    line(0, height/2-200, width, height/2-200);
    
    strokeWeight(2);
    for (int i = 0; i < width+20; i = i + 45){
      rectMode(CENTER);
      
      // south lanes
     rect (i, height/2 + 60, 20, 3);
     rect (i, height/2 + 100, 20, 3);
     rect (i, height/2 + 140, 20, 3);
      
      //north lanes
      
     rect (i, height/2 - 60, 20, 3);
     rect (i, height/2 - 100, 20, 3);
     rect (i, height/2 - 140, 20, 3);
      
    }

    
      }
    }
  


// a subclass of car for city cars
class HighwayCar extends Car {
  boolean directionRight = false;
  

  HighwayCar(int id) {
    super(id);
    carRadius = 8;
  }
  
   public void applyBehaviors(ArrayList<Car> Cars) {
    PVector separateForce = separate(Cars);
    separateForce.mult(0.3f);
    followPath();
    applyForce(separateForce);
  }

  public void applyAccidentBehaviors(PVector Accident) {
    PVector separateForce = separateFromAccident(Accident);
    separateForce.mult(0.6f);
    followPath();
    applyForce(separateForce);
  }
  
  // ----------------------------------------------------------------------
  //  Interaction with Accident
  // ----------------------------------------------------------------------
  // Separation
  // Method checks for nearby vehicles and steers away
  public PVector separateFromAccident (PVector accident) {
    // calculate the safe zone
    safeZone = 60;
    float safeAngle = PI/6;
    PVector sForce = new PVector(0, 0);

    // get the distance between the two cars
    float distance = PVector.dist(position, accident);
    // If the distance is greater than 0 and less than an arbitrary amount (0 when you are yourself)

    if (distance < safeZone) {
      // Calculate vector pointing away from neighbor
      PVector diff = PVector.sub(position, accident);



      // check if the other car is in front of this car

      diff.normalize();
      // if the car is straight in front..

      sForce = diff.get();
    }

  return sForce;
}

  //---------------------------------------------------------------
  // method to create random origine and destinations for the cars
  //---------------------------------------------------------------

  public PVector getDestination( PVector lastDestination) {
    //gridSize = width;
    PVector tempDestination = new PVector(0, 0);
    float destinationX;
    float destinationY;
    
    //directionRight = !directionRight;

    
    for(int i = 0; i < gui.carNumber+1; i ++) {
     int randomizeSide = PApplet.parseInt(random(0, 2)); 
     if ( randomizeSide == 0 ){
      directionRight = false;
     } else {
       directionRight = true;
     }
    }
    
    if (directionRight) {
      
      destinationX = (-300)+60*round(random(1, 4));
      destinationY = height/2+40*round(random(1, 4));
      
    }
    else {    
      destinationX = (width+300)-60*round(random(1, 4));
      destinationY = height/2-40*round(random(1, 4));
      
    }
    gridSize = 1;
    
    tempDestination = new PVector(destinationX, destinationY);

    // create a path to follow
    carPath = new CarPath(lastDestination, tempDestination, 0);

    return tempDestination;
  }
}



// ----------------------------------------------------------------------
// GLOBAL VARIABLES
// ----------------------------------------------------------------------

CarSystem systemOfCars;

CityBg cityBg ;

ParkingBg parkingBg;

HighwayBg highwayBg;

GUI gui ;

// Using this variable to toggle between drawing the lines or not
boolean debug = false;
char scenario;
//verify if needed
int gridSize = 1;
int cityGridSize = 180;

// ----------------------------------------------------------------------
//  FUNCTIONS
// ----------------------------------------------------------------------
public void setup() {
//size(displayWidth, 1035);
size(displayWidth, displayHeight);

//size(900, 700);
  scenario = 'C';
  //initialize Gui 
  gui = new GUI();

  cityBg = new CityBg();
  highwayBg = new HighwayBg(40);
  parkingBg = new ParkingBg();

  systemOfCars = new CarSystem(scenario);
  systemOfCars.init();
  frameRate(30);
}


// ----------------------------------------------------------------------
//  DRAW FUNCTION
// ----------------------------------------------------------------------

public void draw() {

  // draw the background
  background(0, 10, 10);

  // display the right background
  switch(scenario) {
  case 'C': 
    // Display the road
    cityBg.display();
    systemOfCars.run();
    cityBg.displayBuildings();
    break;

  case 'P': 
    background(10, 20, 20);

    parkingBg.display();
    systemOfCars.run();
    break;

  case 'H': 
      background(10, 10, 20);

    // Display the road
    highwayBg.display();
    systemOfCars.run();
    break;

  case 'S': 
  background(10, 15, 25);
    cityBg.display();
    systemOfCars.run();
    cityBg.displayBuildings();
    break;

  default:             
    break;
  }


  //display Gui
  gui.display();
  gui.displayNumber();

}


// press space bar to able and disable collision and target lines.
public void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
}

public void mouseReleased() {  
  gui.mouseEvent();
  gui.activateToggle();
  int controlMargin = width-width/10+60;

  if (mouseX >= controlMargin && mouseX <= controlMargin+50 && mouseY >= 50 && mouseY <= 340) {

    systemOfCars = new CarSystem(scenario);
    systemOfCars.init();
  }
  
}

// a class to generate and display the parking background
class ParkingBg {
  int parkingHeight = 520;
  int parkingWidth = 600;

  ParkingBg() {
  }

  public void display() {
    fill(50, 50);
    rectMode(CENTER);
    rect(width/2+30, height/2-52, parkingWidth, parkingHeight);

    for (int r = 0; r<=10; r++) {
      strokeWeight(3);
      stroke(200, 60);
      line((width-parkingWidth)/2+30 + r*60, (height-parkingHeight)/2-52, (width-parkingWidth)/2+30 + r*60, (height-parkingHeight)/2+parkingHeight-52);
      strokeWeight(1.5f);

      line((width-parkingWidth)/2+30, (height-parkingHeight)/2+r*52-52, (width-parkingWidth)/2+30+parkingWidth, (height-parkingHeight)/2+r*52-52);
    }
  }
}

// a subclass of car for parking cars
class ParkingCar extends Car {

  float parkingGrid = 40;
  float parkingWidth = width - 300;
  float parkingHeight = height - 200;
  PVector parkingPosition;
  int parkingId;


  ParkingCar(int id, PVector start, PVector parkingPosition_, int parkingId_ ) {
    super(id);
    carRadius = 18;

    // give starting position for the car
    position = start.get();
    safeZone = 100;
    easing = 0.1f;
    parked = false;
    parkingId = parkingId_;

    parkingPosition = parkingPosition_.get();

    carPath = new CarPath(position, parkingPosition, 30);
  }

  public int getParkingId() {
    return parkingId;
  }

  // update methode
  public void update() {
    //kill the cars in the top left corner
    if (position.x<50 &&position.y<80) {
      // remove car
      println("remove this car");
      trashIt = true;
    }
    if (!parked) {
      velocity.add(acceleration);
      // limit the velocity to the maximum speed alowd
      velocity.limit(speedLimit);
      // add the velocity to the position
      position.add(velocity);
      // reset acceleration
      acceleration.mult(0);
    }
    else if (parked) {
    }
  }




  public void applyBehaviors(ArrayList<Car> Cars) {
    PVector separateForce = separate(Cars);
    if (!parked) {
      followPath();
    }
    applyForce(separateForce);
  }


  public void followPath() {
    // PVector for the desired position
    PVector desired;
    // A vector pointing from the position to the first point of the path
    desired = PVector.sub(carPath.points.get(pathIndex), position); 

    // if the car is close enought to the first point  and is still in the first section
    if (desired.mag()<20 && pathIndex == 1) {  
      pathIndex = 2;  
      desired = PVector.sub(carPath.points.get(pathIndex), position);
    }
    // if the car is close to the final target of the path
    if (desired.mag()<15 && pathIndex == 2) { 
      pathIndex = 3;  
      desired = PVector.sub(carPath.points.get(pathIndex), position);
    }
    if (desired.mag()<5 && pathIndex == 3) { 
      pathIndex = 1;  

      // if the car is in the exit lane
      if (position.y<80) {
        carPath = new CarPath(position, new PVector(0, 50), 0);
      }
      // else the car has arrived to his parking spot
      else {
        // parked and stop
        parked = true;
        velocity.mult(0);
      }
    }


    // Predict location 20 (arbitrary choice) frames ahead
    PVector predict = velocity.get();
    predict.normalize();
    predict.mult(20);
    PVector predictLoc = PVector.add(position, predict);
    // Look at the line segment
    PVector a = carPath.points.get(pathIndex-1);
    PVector b = carPath.points.get(pathIndex);

    // Get the normal point to that line
    PVector normalPoint = getNormalPoint(predictLoc, a, b);


    // Find target point a little further ahead of normal
    PVector dir = PVector.sub(b, a);
    dir.normalize();
    dir.mult(10);  // This could be based on velocity instead of just an arbitrary 10 pixels
    PVector target = PVector.add(normalPoint, dir);

    // How far away are we from the path?
    float distance = PVector.dist(predictLoc, normalPoint);

    seek(target);
  }

  public void getDestination( PVector lastDestination, PVector finalDestination) {
    parked = false;
    PVector tempDestination = finalDestination;

    // create a path to follow
    carPath = new CarPath(lastDestination, tempDestination, 0);
  }
  public PVector getDestination( PVector lastDestination) {
    parked = false;
    PVector tempDestination = new PVector(0, 0);


    tempDestination = new PVector(lastDestination.x+30, 50);

    // create a path to follow
    carPath = new CarPath(lastDestination, tempDestination, 0);

    return tempDestination;
  }
}

// a class to mange parking spots with states and position

class ParkingSpot {
  PVector position;
  boolean busy;

  ParkingSpot(PVector position_, boolean busy_) {

    position = position_;
    busy = busy;
  }

  // a methode to get the parking position
  public PVector getParkingPosition() {
    return position;
  }

  // a methode to get the state of the parking, busy or not
  public boolean getParkingState() {
    return busy;
  }
  // a methode to assigne a state to a parking spot
  public void useParking(boolean u) {
    busy = u;
  }
}


class Pedestrian {

  PVector location;
  boolean pickedUp = false;
  PVector velocity;
  boolean canBePickedUp = true;
  float alpha = 255;


  Pedestrian (PVector location_) { 

    location = location_;
    velocity = new PVector (0, 0);
  }

  public void display() {
    int size = 8;
    rectMode(CENTER);


    fill(0, 200, 140, alpha-254);
    ellipse(location.x, location.y, size*8, size*8);
    fill(0, 255, 120, alpha);
    ellipse(location.x, location.y, size, size);
    if (alpha <= 200) {
      alpha -= 0.1f;
      println(alpha);
    }
  }


  public void setPickedUp (boolean pickedUp_, PVector velFromCar ) {
    pickedUp = pickedUp_;
    velocity = velFromCar.get();
    velocity.normalize();
    velocity.mult(0.01f);
  }


  public void update(Car car) {

    location.x = car.position.x;
    location.y = car.position.y;
    //}
  }

  public void reset () {
    pickedUp =false;
    canBePickedUp = false;
    alpha = 200;
  }
}


  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "--full-screen", "--bgcolor=#666666", "--stop-color=#cccccc", "CarSystemFinal" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
