// a class to draw the city background
class CityBg {

  // A Road has a radius, i.e how far is it ok for the boid to wander off
  float roadWidth;
  int grid;

  CityBg() {
    //  radius of 20
    roadWidth = 20;
    grid = 180;
  }

  float getGridSize() {
    return grid;
  }


  // Draw the Road
  void display() {
    // Draw Roads

    rectMode(CENTER);
    stroke(50);
    strokeWeight(2);
    fill(0);
    for (int bv = 0; bv < width/grid; bv++ ) {
      for (int bh = 0; bh < height/grid+1; bh++ ) {
        rect(grid*bv+grid/2, grid*bh + grid/2, grid-roadWidth*2, grid-roadWidth*2);
      }
    }

    /// draw dot grid
    strokeWeight(2);
    stroke(255, 50);
    for ( int h = 0; h< width/roadWidth; h++) {
      for ( int v = 0; v< height/roadWidth; v++) {
        point(roadWidth*h, roadWidth*v);
      }
    }
  }

  // a method to draw buildings with an offset according to the center of the screen
  void displayBuildings() {
    int buildingN = 10;
    float buildingSize = grid*0.5;
    float offsetX=0;
    float offsetY=0;
    float buildingHeight;

    for (int bv = 0; bv < buildingN; bv++ ) {
      for (int bh = 0; bh < buildingN-1; bh++ ) {
        // randomSeed(1000);
        buildingHeight = 0.15;
        rectMode(CENTER);
        noStroke();
        fill(50, 180);
        offsetX = (grid*bv-width/2)*buildingHeight;
        offsetY = (grid*bh-height/2)*buildingHeight;

        rect(grid*bv+grid/2, grid*bh+ grid/2, buildingSize, buildingSize);
        beginShape();
        vertex(grid*bv+grid/2-buildingSize/2, grid*bh+grid/2-buildingSize/2);
        vertex(grid*bv+grid/2-buildingSize/2+offsetX, grid*bh+grid/2-buildingSize/2+offsetY);

        vertex(grid*bv+grid/2+buildingSize/2+offsetX, grid*bh+grid/2+buildingSize/2+offsetY);
        vertex(grid*bv+grid/2+buildingSize/2, grid*bh+grid/2+buildingSize/2);
        endShape(CLOSE);

        beginShape();
        vertex(grid*bv+grid/2+buildingSize/2, grid*bh+grid/2-buildingSize/2);
        vertex(grid*bv+grid/2+buildingSize/2+offsetX, grid*bh+grid/2-buildingSize/2+offsetY);

        vertex(grid*bv+grid/2-buildingSize/2+offsetX, grid*bh+grid/2+buildingSize/2+offsetY);
        vertex(grid*bv+grid/2-buildingSize/2, grid*bh+grid/2+buildingSize/2);
        endShape(CLOSE);
        stroke(60);
        noStroke();
        fill(65, 180);
        rect(grid*bv+grid/2+offsetX, grid*bh+ grid/2+offsetY, buildingSize, buildingSize);
      }
    }
  }
}

