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
      stroke(200,50);
      line((width-parkingWidth)/2+30 + r*60, (height-parkingHeight)/2, (width-parkingWidth)/2+30 + r*60, (height-parkingHeight)/2+parkingHeight);
    }
  }
}

