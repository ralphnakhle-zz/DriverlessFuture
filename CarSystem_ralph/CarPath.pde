//Based on Path Following
// by Daniel Shiffman <http://www.shiffman.net>
// The Nature of Code

class CarPath {

  // A Road is an arraylist of points (PVector objects)
  ArrayList<PVector> points;
  // A Road has a radius, i.e how far is it ok for the boid to wander off
  float radius;
  PVector start;
  PVector end;
  int offsetDistance;
  CarPath(PVector start_, PVector end_, int offsetDistance_) {

    points = new ArrayList<PVector>();
    start = start_.get();
    end = end_.get();
    offsetDistance = offsetDistance_;
    generatePath();
    
  }
  int getSize() {
    int size = points.size();
    return size;
  }
  void generatePath() {
    PVector offset = new PVector(0, 0);
    // end without offset
    PVector realEnd = end.get();

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
    // println("offset: "+ offset.x + ", " + offset.y);

    start.add(offset);
    end.add(offset);

    PVector middle = new PVector(end.x, start.y);

    points.add(start);
    points.add(middle);
    points.add(end);
    points.add(realEnd);
  }
}

