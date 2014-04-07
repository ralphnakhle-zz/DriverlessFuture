
class HighwayBg {

  // A Road is an arraylist of points (PVector objects)
  ArrayList<PVector> points;
  // A Road has a radius, i.e how far is it ok for the boid to wander off
  float radius;

  HighwayBg(float r) {
    // Arbitrary radius of 20
    radius = r;
    // point array to draw path grid
    points = new ArrayList<PVector>();
    // new grid starting at point 0
    newGrid(0);
  }

  // Add a point to the Road
  void addPoint(float x, float y) {
    // initialize point
    PVector point = new PVector(x, y);
    points.add(point);
  }
  // creates a grid of points for the road
  void newGrid(int spacer) {
 // add ppints
 addPoint(0,height/2);
 addPoint(width,height/2);
   
  }
  // Draw the Road
  void display() {
    // Draw Roads
    stroke(255, 50);
    strokeWeight(20);
    noFill();
    
    //center line
    line(0, height/2, width, height/2);
    
    //bottom line
    line(0, height/2+200, width, height/2+200);
    
    //top line
    line(0, height/2-200, width, height/2-200);
    
    strokeWeight(2);
    for (int i = 0; i < width+20; i = i + 45){
      rectMode(CENTER);
      
      // south lanes
     rect (i, height/2 + 60, 20, 3);
     rect (i, height/2 + 100, 20, 3);
     rect (i, height/2 + 140, 20, 3);
      
      //north lanes
      
     rect (i, height/2 - 60, 20, 3);
     rect (i, height/2 - 100, 20, 3);
     rect (i, height/2 - 140, 20, 3);
      
    }

    
      }
    }
  


