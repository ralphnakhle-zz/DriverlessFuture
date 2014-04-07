// a class to mange parking spots with states and position

class ParkingSpot {
  PVector position;
  boolean busy;

  ParkingSpot(PVector position_, boolean busy_) {

    position = position_;
    busy = busy;
  }

  // a methode to get the parking position
  PVector getParkingPosition() {
    return position;
  }

  // a methode to get the state of the parking, busy or not
  boolean getParkingState() {
    return busy;
  }
  // a methode to assigne a state to a parking spot
  void useParking(boolean u) {
    busy = u;
  }
}

