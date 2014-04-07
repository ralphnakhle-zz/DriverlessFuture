
// initializing control cp5
ControlP5 cp5;

int myColorBackground = color(0,0,0);
int knobValue = 100;

// defining knob variables - 
Knob KnobA;
Knob KnobB;
Knob KnobC;

//detrmining variables we can access from the main tab - color and size
void setup(int knobColor, int knobSize) {
  smooth();
  noStroke();
  
  cp5 = new ControlP5(this);
  
  KnobA = cp5.addKnob("knob")
               .setRange(0,255)
               .setValue(50)
               .setPosition(830,118)
               .setRadius(25)
               .setDragDirection(Knob.VERTICAL)
               .setViewStyle(2)
               ;
               
  KnobC = cp5.addKnob("knobC")
               .setRange(0,255)
               .setValue(50)
               .setPosition(770,118)
               .setRadius(25)
               .setDragDirection(Knob.VERTICAL)
               .setViewStyle(2)
               ;
                     
  KnobB = cp5.addKnob("knobValue")
               .setRange(0,255)
               .setValue(220)
               .setPosition(470,125)
               .setRadius(45)
               .setNumberOfTickMarks(10)
               .setTickMarkLength(4)
               .snapToTickMarks(true)
               .setColorForeground(color(255))
               .setColorBackground(color(40, 120, 50))
               .setColorActive(color(255,255,0))
               .setDragDirection(Knob.HORIZONTAL)
               ;
}

void draw (int Controll) {
  
  //GUI background
  fill(255);
  rect(110, 80, 784, 130, 7);
  
  // GUI Header
  fill(100);
  rect(110, 79, 784, 30, 7, 7, 0, 0);
  
  
  //fill(knobValue);
  //rect(0,height/2,width,height/2);
  //fill(myColorBackground);
  //rect(80,40,140,320); 
  
  
}

void knob(int theValue) {
  //myColorBackground = color(theValue);
  //println("a knob event. setting background to "+theValue);
}

void knobC(int theValue) {
  //myColorBackground = color(theValue);
  //println("a knob event. setting background to "+theValue);
}


void keyPressed() {
  switch(key) {
    case('1'):KnobA.setValue(180);break;
    case('2'):KnobB.setConstrained(false).hideTickMarks().snapToTickMarks(false);break;
    case('3'):KnobA.shuffle();KnobB.shuffle();break;
  }
}
