// a class to contain a path for the cars to follow

//Based on Path Following
// by Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code

class CarPath {

  // A path is an arraylist of points (PVector objects)
  ArrayList<PVector> points;
  // start of the path
  PVector start;
  // end of the path
  PVector end;
  // offset of the path
  int offsetDistance;

  // CarPath constructor
  CarPath(PVector start_, PVector end_, int offsetDistance_) {

    points = new ArrayList<PVector>();
    start = start_.get();
    end = end_.get();
    offsetDistance = offsetDistance_;
    generatePath();
  }

  // a methode to get the size of the path
  int getSize() {
    int size = points.size();
    return size;
  }

  // a methode to generathe a path from an strat and end point, draw an L
  void generatePath() {
    PVector offset = new PVector(0, 0);
    // end without offset
    PVector realEnd = end.get();

    // find the direction of the path to set the offset
    if (end.x>start.x) {
      offset.add(new PVector(0, offsetDistance));
    }
    else if (end.x<start.x) {
      offset.add(new PVector(0, -offsetDistance));
    }
    if (end.y>=start.y) {
      offset.add(new PVector(-offsetDistance, 0));
    }
    else if (end.y<start.y) {
      offset.add(new PVector(offsetDistance, 0));
    }

    start.add(offset);
    end.add(offset);

// middle point of the path
    PVector middle = new PVector(end.x, start.y);

    points.add(start);
    points.add(middle);
    points.add(end);
    // real end without the offset
    points.add(realEnd);
  }
}

