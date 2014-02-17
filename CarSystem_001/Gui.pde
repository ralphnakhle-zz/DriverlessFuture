// ----------------------------------------------------------------------
//  GUI class
// ----------------------------------------------------------------------

class GUI {



  //defining knob variable
  Knob CarsKnob;

  // ----------------------------------------------------------------------
  //  GUI KNOBS
  // ----------------------------------------------------------------------
  // Knob function from ControlP5 - All parameters of Knobs 
  GUI() {
    //CarsKnob parameters
    CarsKnob = cp5.addKnob("CarKnob")
      .setRange(20, 50)
        .setValue(20)
          .setPosition(820, 10)
            .setRadius(25)
              .setDragDirection(Knob.VERTICAL)
                .setViewStyle(2)
                  ;  

    CarsKnob = cp5.addKnob("SpeedKnob")
      .setRange(0.5, 3)
        .setValue(0.5)
          .setPosition(740, 10)
            .setRadius(25)
              .setDragDirection(Knob.VERTICAL)
                .setViewStyle(2)
                  ;

    CarsKnob = cp5.addKnob("SteeringKnob")
      .setRange(0.2, 3)
        .setValue(0.2)
          .setPosition(660, 10)
            .setRadius(25)
              .setDragDirection(Knob.VERTICAL)
                .setViewStyle(2)
                  ;

    CarsKnob = cp5.addKnob("RepulsionForce")
      .setRange(2, 10)
        .setValue(2)
          .setPosition(580, 10)
            .setRadius(25)
              .setDragDirection(Knob.VERTICAL)
                .setViewStyle(2)
                  ;
                  
  }
} 

