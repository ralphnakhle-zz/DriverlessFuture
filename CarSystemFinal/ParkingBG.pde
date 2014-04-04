// a class to generate and display the parking background
class ParkingBg {
  int parkingHeight = 520;
  int parkingWidth = 600;

  ParkingBg() {
  }

  void display() {
    fill(50, 50);
    rectMode(CENTER);
    rect(width/2+30, height/2, parkingWidth, parkingHeight);

    for (int r = 0; r<=10; r++) {
      strokeWeight(3);
      stroke(200, 20);
      line((width-parkingWidth)/2+30 + r*60, (height-parkingHeight)/2, (width-parkingWidth)/2+30 + r*60, (height-parkingHeight)/2+parkingHeight);
      strokeWeight(1.5);

      line((width-parkingWidth)/2+30, (height-parkingHeight)/2+r*52, (width-parkingWidth)/2+30+parkingWidth, (height-parkingHeight)/2+r*52);
    }
  }
}

