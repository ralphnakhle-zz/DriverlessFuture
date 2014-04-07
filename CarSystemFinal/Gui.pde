// ----------------------------------------------------------------------
//  GUI class
// ----------------------------------------------------------------------

class GUI {

  int controlMargin = width-width/10+10;
  int carNumber = 40;
  float speedLimit = 3;
  float steeringLimit = 0.3;
  float alpha;
  String text;

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


    if (scenario == 'C') {
      rectMode(CENTER);
      fill(250, 200, 10, alpha);
      rect(width/2, height/1.32, width/2, height/7, 5);
      
      fill(0, alpha);
      text("City Traffic", width/2.1, height/1.4);
      text("The City traffic scenario illustrates the efficiency and security that a city with Driverless Cars ", width/3.2, height/ 1.35);
      text("and no traffic lights would benefit from. You can trigger the event to launch an Ambulance,", width/3.2, height/1.30);
      text("and see how cars react to it.", width/3.2, height/1.25);
      alpha -= 0.6;
    }  

    if (scenario == 'P') {
      //text = "Parking"
      rectMode(CENTER);
      fill(250, 200, 10, alpha);
      rect(width/2, height/1.32, width/2, height/7, 5);
      
      fill(0, alpha);
      text("Parking", width/2.1, height/1.4);
      text("In the Parking scenario, proximity of cars and automatic access and exit in parking lots can save us", width/3.2, height/ 1.35);
      text("a lot of space. By triggering the event button, the user can call his car from outside the parking.", width/3.2, height/1.30);
      text("Increasing the car population allows you to add more cars and see how they react. ", width/3.2, height/1.25);
      alpha -= 0.6;
    }  

    if (scenario == 'H') {
      //text = "Highway";
      rectMode(CENTER);
      fill(250, 200, 10, alpha);
      rect(width/2, height/1.32, width/2, height/7, 5);
      
      fill(0, alpha);
      text("Highway", width/2.1, height/1.4);
      text("The Highway scenario showcases the uniformity and time saving features that come with Driverless Cars.", width/3.2, height/ 1.35);
      text("Once the event trigger is activated, an accident will be simulated on the Highway, where ", width/3.2, height/1.30);
      text("you can see how cars react to it.", width/3.2, height/1.25);
      alpha -= 0.6;
    }  

    if (scenario == 'S') {      
      rectMode(CENTER);
      fill(250, 200, 10, alpha);
      rect(width/2, height/1.32, width/2, height/7, 5);
      
      fill(0, alpha);
      text("Shared Autos", width/2.1, height/1.4);
      text("The Shared Autos scenario illustrates a car system where Driverless Cars are not as much of a property,", width/3.5, height/ 1.35);
      text("but more of a shared commodity. By triggering the event, you simulate a car user that gets picked up by any", width/3.5, height/1.30);
      text("car and dropped off wherever he’s going. The car is then available to pick up any other passengers calling it.", width/3.5, height/1.25);
      alpha -= 0.6;

    }  

    fill(0, alpha);
    //text(text, width/2, height/2.7);
  }

  void activateToggle() {
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

    if (speedLimit >= 10) {
      speedLimit = 10;
    }

    if (speedLimit < 2) {
      speedLimit = 2;
    }

    if (mouseX >= controlMargin && mouseX <= controlMargin+26 && mouseY >= 551 && mouseY <= 577) {

      speedLimit -= 0.5;

      systemOfCars.setCarSpeedLimit(speedLimit);
      println(speedLimit);
    }

    if (mouseX >= controlMargin+40 && mouseX <= controlMargin+70 && mouseY >= 551 && mouseY <= 581) {

      speedLimit += 0.5;

      systemOfCars.setCarSpeedLimit(speedLimit);
      println(speedLimit);
    }
    //text(int(speedLimit)*9 + "/mph", controlMargin+40, 540);


    //--------------------------------------------------
    // Car Speed Toggle Setup
    //--------------------------------------------------

    if (steeringLimit >= 2) {
      steeringLimit = 2;
    }

    if (steeringLimit < 0.1) {
      steeringLimit = 0.1;
    }

    if (mouseX >= controlMargin && mouseX <= controlMargin+26 && mouseY >= 611 && mouseY <= 637) {

      steeringLimit -= 0.1;

      systemOfCars.setCarSteerLimit(steeringLimit);
      println(steeringLimit);
    }

    if (mouseX >= controlMargin+40 && mouseX <= controlMargin+70 && mouseY >= 611 && mouseY <= 641) {

      steeringLimit += 0.1;

      systemOfCars.setCarSteerLimit(steeringLimit);
      println(steeringLimit);
    }
    //text(int(steeringLimit*10), controlMargin+50, 600);
  }

  void mouseEvent() {
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

  void displayNumber() {
    fill(255);
    carNumber = systemOfCars.getCarPopulation();
    text(carNumber, controlMargin+65, 480);
    text(int(speedLimit)*9 + "/mph", controlMargin+40, 540);
    text(int(steeringLimit*10), controlMargin+50, 600);
  }
}

