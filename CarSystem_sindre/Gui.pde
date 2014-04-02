// ----------------------------------------------------------------------
//  GUI class
// ----------------------------------------------------------------------

class GUI {

  int controlMargin = width-width/10+10;
  int carNumber = 40;
  float speedLimit = 2.5;
  float steeringLimit = 0.3;

  // ----------------------------------------------------------------------
  //  GUI KNOBS
  // ----------------------------------------------------------------------
  // 
  GUI() {
  }

  void display() {
    rectMode(CORNER);
    strokeWeight(1);
    //Side bar display 
    noStroke();
    fill(50, 200);
    rect(width, 0, -width/10, height);

    //Header:
    fill(250, 200, 10, 250);
    rect(width, 0, -width/10, 30);
    fill(0);
    textSize(10);
    text("Driverless Future", controlMargin-5, 20);

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
  }

  void activateToggle() {
    //--------------------------------------------------
    // Car Population Toggle Setup
    //--------------------------------------------------


    if (mouseX >= controlMargin && mouseX <= controlMargin+26 && mouseY >= 491 && mouseY <= 517 && mousePressed) {
      if (carNumber>=4) {
        carNumber --;
        systemOfCars.setCarPopulation(0);
      }
    }

    if (mouseX >= controlMargin+40 && mouseX <= controlMargin+70 && mouseY >= 491 && mouseY <= 521 && mousePressed) {
      if (carNumber < 100) {
        carNumber++;
        systemOfCars.setCarPopulation(1);
      }
    }

    fill(255);
    textSize(10);
    text(carNumber, controlMargin+65, 480);

    //--------------------------------------------------
    // Car Speed Toggle Setup
    //--------------------------------------------------

    if (speedLimit >= 10) {
      speedLimit = 10;
    }

    if (speedLimit < 1) {
      speedLimit = 1;
    }

    if (mouseX >= controlMargin && mouseX <= controlMargin+26 && mouseY >= 551 && mouseY <= 577 && mousePressed) {

      speedLimit -= 0.2;

      systemOfCars.setCarSpeedLimit(speedLimit);
      println(speedLimit);
    }

    if (mouseX >= controlMargin+40 && mouseX <= controlMargin+70 && mouseY >= 551 && mouseY <= 581 && mousePressed) {

      speedLimit += 0.2;

      systemOfCars.setCarSpeedLimit(speedLimit);
      println(speedLimit);
    }
    text(int(speedLimit)*9 + "/mph", controlMargin+40, 540);


    //--------------------------------------------------
    // Car Speed Toggle Setup
    //--------------------------------------------------

    if (steeringLimit >= 2) {
      steeringLimit = 2;
    }

    if (steeringLimit < 0.1) {
      steeringLimit = 0.1;
    }

    if (mouseX >= controlMargin && mouseX <= controlMargin+26 && mouseY >= 611 && mouseY <= 637 && mousePressed) {

      steeringLimit -= 0.1;

      systemOfCars.setCarSteerLimit(steeringLimit);
      println(steeringLimit);
    }

    if (mouseX >= controlMargin+40 && mouseX <= controlMargin+70 && mouseY >= 611 && mouseY <= 641 && mousePressed) {

      steeringLimit += 0.1;

      systemOfCars.setCarSteerLimit(steeringLimit);
      println(steeringLimit);
    }
    text(int(steeringLimit*10), controlMargin+50, 600);
  }

  void mouseEvent() {
    // city traffic button
    if (mouseX >= controlMargin && mouseX <= controlMargin+50 && mouseY >= 50 && mouseY <= 110) {
      scenario = 'C';
      carNumber = 40;
    }
    // highway button
    if (mouseX >= controlMargin && mouseX <= controlMargin+50 && mouseY >= 140 && mouseY <= 190) {
      scenario = 'H';
      carNumber = 40;
    }
    // Parking button
    if (mouseX >= controlMargin && mouseX <= controlMargin+50 && mouseY >= 220 && mouseY <= 270) {
      scenario = 'P';
      carNumber = 40;
    }

    // Shared comodity button
    if (mouseX >= controlMargin && mouseX <= controlMargin+50 && mouseY >= 300 && mouseY <= 350) {
      //  scenario = 'S';
      carNumber = 40;
    }


    // event triger
    if (mouseX >= controlMargin && mouseX <= controlMargin+50 && mouseY >= 395 && mouseY <= 445) {

      systemOfCars.triggerEvent();
    }
  }
}

