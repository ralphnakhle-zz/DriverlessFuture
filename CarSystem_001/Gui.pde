// ----------------------------------------------------------------------
//  GUI class
// ----------------------------------------------------------------------

class GUI {

  int controlMargin = width-width/10+10;
  int carNumber = 40;

  // ----------------------------------------------------------------------
  //  GUI KNOBS
  // ----------------------------------------------------------------------
  // 
  GUI() {
  }

  void display() {


    //Side bar display 
    noStroke();
    fill(100, 100, 100, 200);
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
    
    
    if(carNumber >= 60){
     carNumber = 60; 
    }
    
    if(carNumber < 3){
     carNumber = 4; 
    }
    
    if (mouseX >= controlMargin && mouseX <= controlMargin+26 && mouseY >= 491 && mouseY <= 517 && mousePressed) {
        
      carNumber --;
        
      systemOfCars.setCarPopulation(carNumber);
      println(carNumber);
    }

    if (mouseX >= controlMargin+40 && mouseX <= controlMargin+70 && mouseY >= 491 && mouseY <= 517 && mousePressed) {
      carNumber++;
    
      systemOfCars.setCarPopulation(carNumber);
      println(carNumber);
    }
    
    fill(255);
    textSize(10);
    text(carNumber, controlMargin+65, 480);
  }
}

