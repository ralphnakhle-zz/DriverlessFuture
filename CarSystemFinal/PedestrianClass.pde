// a class to manage pedestrian for scenario shared autos
class Pedestrian {
// pedestrian class vriables
// initializing location of pedestrian
  PVector location;
  // boolean for determining whether pedestrian was picked up
  boolean pickedUp = false;
  PVector velocity;
  // boolean for knowing when pedestrian is released
  boolean canBePickedUp = true;
  // alpha value for pedestrian display
  float alpha = 255;

// constructor
  Pedestrian (PVector location_) { 

    location = location_;
    velocity = new PVector (0, 0);
  }
// display function
  void display() {
    int size = 8;
    rectMode(CENTER);


    fill(0, 200, 140, alpha-254);
    ellipse(location.x, location.y, size*8, size*8);
    fill(0, 255, 120, alpha);
    ellipse(location.x, location.y, size, size);
    if (alpha <= 200) {
      alpha -= 0.1;
      println(alpha);
    }
  }

// method for associating pedestrian location parameters and velocity to cars velocity. 
  void setPickedUp (boolean pickedUp_, PVector velFromCar ) {
    pickedUp = pickedUp_;
    velocity = velFromCar.get();
    velocity.normalize();
    velocity.mult(0.01);
  }

  // update car location
  void update(Car car) {

    location.x = car.position.x;
    location.y = car.position.y;
    //}
  }
// reset booleans to retrigger pedestrian
  void reset () {
    pickedUp =false;
    canBePickedUp = false;
    alpha = 200;
  }
}


