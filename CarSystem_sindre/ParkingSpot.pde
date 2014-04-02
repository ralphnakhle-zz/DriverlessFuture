class ParkingSpot {
  PVector position;
  boolean busy;

  ParkingSpot(PVector position_, boolean busy_) {

    position = position_;
    busy = busy;
  }


  PVector getParkingPosition() {
    return position;
  }


  boolean getParkingState() {
    return busy;
  }

  void useParking(boolean u) {
    busy = u;
  }
}

