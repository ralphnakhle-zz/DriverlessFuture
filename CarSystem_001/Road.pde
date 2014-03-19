//Based on Path Following
// by Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code

class Road {

  // A Road is an arraylist of points (PVector objects)
  ArrayList<PVector> points;
  // A Road has a radius, i.e how far is it ok for the boid to wander off
  float radius;

  Road() {
    // Arbitrary radius of 20
    radius = 20;
    points = new ArrayList<PVector>();
  }

  // Add a point to the Road
  void addPoint(float x, float y) {
    PVector point = new PVector(x, y);
    points.add(point);
  }

  // Draw the Road
  void display() {
    // Draw Roads
    stroke(255, 50);
    strokeWeight(radius*2+2);
    noFill();

    for (int v = 0; v < points.size()-1; v++ ) {
      line(points.get(v).x, points.get(v).y, points.get(v+1).x, points.get(v+1).y);
    }
    stroke(10, 20, 20);
    strokeWeight(radius*2);
    noFill();

    for (int v = 0; v < points.size()-1; v++ ) {
      line(points.get(v).x, points.get(v).y, points.get(v+1).x, points.get(v+1).y);
    }
    // draw buildings
    /* int buildingN = 5;
     for (int bv = 1; bv < buildingN; bv++ ) {
     for (int bh = 1; bh < buildingN-1; bh++ ) {
     
     float buildingSize = gridSize*0.6;
     float offset=0;
     rectMode(CENTER);
     noStroke();
     fill(15, 15, 30);
     rect(gridSize*bv-gridSize/2, gridSize*bh- gridSize/2, buildingSize, buildingSize);
     fill(15, 20, 50);
     offset= 15;
     //  rect(gridSize*bv-gridSize/2+offset, gridSize*bh- gridSize/2+offset, buildingSize, buildingSize);
     }
     }
     */
    /// draw dot grid
    strokeWeight(2);
    stroke(255, 50);
    for ( int h = 0; h< width/radius; h++) {
      for ( int v = 0; v< height/radius; v++) {
        point(radius*h, radius*v);
      }
    }
  }
}

