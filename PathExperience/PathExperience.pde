// Path Following
// Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code

// Via Reynolds: // http://www.red3d.com/cwr/steer/PathFollow.html

// Using this variable to decide whether to draw all the stuff
boolean debug = false;

// A path object (series of connected points)
Path path;

// Two vehicles
Vehicle car1;
Vehicle car2;
Vehicle car3;

void setup() {
  size(900, 700);
  smooth();

  // Call a function to generate new Path object
  newPath();

  // Each vehicle has different maxspeed and maxsteer for demo purposes
  car1 = new Vehicle(new PVector(0, height/4), 5, 0.8, new PVector(width, height*.90));
  car2 = new Vehicle(new PVector(0, height/3), 8, 0.9, new PVector(width, height*.75));
  car3 = new Vehicle(new PVector(0, height/2), 5, 0.8);
}

void draw() {
  background(255);
  // Display the path
  path.display();
  // The boids follow the path
  car1.follow(path);
  car2.follow(path);
  //car3.follow(path);

  car1.applyForce(car1.seekTarget());
  car2.applyForce(car2.seekTarget());


  // Call the generic run method (update, borders, display, etc.)
  car1.run();
  car2.run();
  // car3.run();

  // Instructions
  // fill(0);
  // text("Hit space bar to toggle debugging lines.\nClick the mouse to generate a new path.", 10, height-30);
}

void newPath() {
  // A path is a series of connected points
  // A more sophisticated path might be a curve
  //loopPath();

  gridPath(160);
}
// create grid patern
void gridPath(int spacer) {


  path = new Path();
  for ( int g = 0; g <width+spacer/spacer; g++) {
    path.addPoint(spacer*g, 0-50);
    path.addPoint(spacer*g, height+50);
    path.addPoint(spacer*(g+1), height+50);
  }
  for ( int g = 0; g <height+spacer/spacer; g++) {
    path.addPoint(0-50, spacer*g);
    path.addPoint(width+50, spacer*g);
    path.addPoint(width+50, spacer*(g+1));
  }
}
void loopPath() {

  int spacer = 50;
  path = new Path();
  path.addPoint(spacer, 240);
  path.addPoint(170, 200);
  path.addPoint(width-170, height-200);
  path.addPoint(width-spacer, height-240);
  path.addPoint(width-20, height/2);
  path.addPoint(width-spacer, 240);
  path.addPoint(width-170, 200);
  path.addPoint(170, height-200);
  path.addPoint(spacer, height-240);
  path.addPoint(20, height/2);
  path.addPoint(spacer, 240);
}
public void keyPressed() {
  if (key == ' ') {
    debug = !debug;
  }
}

public void mousePressed() {
  newPath();
}

