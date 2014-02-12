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

void setup() {
  size(800, 600);
  smooth();

  // Call a function to generate new Path object
  newPath();

  // Each vehicle has different maxspeed and maxforce for demo purposes
  car1 = new Vehicle(new PVector(0, height/2), 8, 0.8);
  car2 = new Vehicle(new PVector(0, height/2-10), 4, 0.6);
}

void draw() {
  background(255);
  // Display the path
  path.display();
  // The boids follow the path
  car1.follow(path);
  car2.follow(path);
  // Call the generic run method (update, borders, display, etc.)
  car1.run();
  car2.run();

  // Instructions
 // fill(0);
 // text("Hit space bar to toggle debugging lines.\nClick the mouse to generate a new path.", 10, height-30);
}

void newPath() {
  // A path is a series of connected points
  // A more sophisticated path might be a curve
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

