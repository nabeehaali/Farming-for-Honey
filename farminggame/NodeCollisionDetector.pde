class NodeCollisionDetector {

  // Class variable for checking if there is a collision
  PVector NO_COLLISION = new PVector(-99999, -99999);

  // Constructor
  NodeCollisionDetector() {
  }

  // testing against class variable NO_COLLISION
  boolean isCollision(PVector avoid) {
    return !(avoid == NO_COLLISION);
  }

  // Method to use for finding which position
  // to seek during collision avoidance
  // Input:
  //        an array of blocked nodes,
  //        a characters location,
  //        a characters predicted location, and
  //        how far to seek away from the Node
  // Output:
  //        a point to seek for avoidance
  PVector getNormalToAvoid(ArrayList<Node> obstacles, PVector location, PVector prediction, float collisionThreshold) {
    
    PVector[] closest = {NO_COLLISION, null};

    // iterate over blocked nodes
    for (Node n : obstacles) {
      PVector[] pair = getLineRectCollisionNormal(location, prediction, n.position, n.size, n.size);
      // find the closest collision point to avoid
      if (PVector.dist(location, pair[0]) < PVector.dist(location, closest[0])) {
        closest = pair;
      }
    }
    // if not a collision
    if (closest[0] == NO_COLLISION) {
      return NO_COLLISION;

      // if is a collision
    } else {
      closest[1].setMag(collisionThreshold);
      PVector avoid = new PVector(closest[0].x+closest[1].x, closest[0].y+closest[1].y);
      return avoid;
    }
  }

  // helper method to get perpendicular vector
  PVector getPerpendicularVector(PVector rect1, PVector rect2) {
    PVector vec = PVector.sub(rect2, rect1);
    return new PVector(-vec.y, vec.x);
  }

  // Method to detect a collision and
  //get both the collision point and
  // it's associated normal vector
  PVector[] getLineRectCollisionNormal(PVector start, PVector ray, PVector rectLocation, float rw, float rh) {

    PVector closest = NO_COLLISION;
    PVector normal = new PVector(0, 0);
    float x1 = start.x;
    float y1 = start.y;

    float x2 = ray.x;
    float y2 = ray.y;

    float rx = rectLocation.x;
    float ry = rectLocation.y;
    // check if the line has hit any of the rectangle's sides
    // uses the Line/Line function below
    PVector left =   lineLine(x1, y1, x2, y2, rx, ry, rx, ry+rh);
    if (PVector.dist(start, left) < PVector.dist(start, closest)) {
      closest = left;
      normal = getPerpendicularVector(rectLocation, new PVector(rx, ry+rh));
    }

    PVector right =  lineLine(x1, y1, x2, y2, rx+rw, ry, rx+rw, ry+rh);
    if (PVector.dist(start, right) < PVector.dist(start, closest)) {
      closest = right;
      normal = getPerpendicularVector(new PVector(rx+rw, ry), new PVector(rx+rw, ry+rh));
      normal.x = -normal.x;
    }

    PVector top =    lineLine(x1, y1, x2, y2, rx, ry, rx+rw, ry);
    if (PVector.dist(start, top) < PVector.dist(start, closest)) {
      closest = top;
      normal = getPerpendicularVector(rectLocation, new PVector(rx+rw, ry));
      normal.y = -normal.y;
    }

    PVector bottom = lineLine(x1, y1, x2, y2, rx, ry+rh, rx+rw, ry+rh);
    if (PVector.dist(start, bottom) < PVector.dist(start, closest)) {
      closest = bottom;
      normal = getPerpendicularVector(new PVector(rx, ry+rh), new PVector(rx+rw, ry+rh));
    }


    normal.normalize();

    PVector[] projection = {closest, normal};
    return projection;
  }


  // Collision between two lines
  PVector lineLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {

    // calculate the direction of the lines
    float uA = ((x4-x3)*(y1-y3) - (y4-y3)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));
    float uB = ((x2-x1)*(y1-y3) - (y2-y1)*(x1-x3)) / ((y4-y3)*(x2-x1) - (x4-x3)*(y2-y1));

    // if uA and uB are between 0-1, lines are colliding
    if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {

      // optionally, draw a circle where the lines meet
      float intersectionX = x1 + (uA * (x2-x1));
      float intersectionY = y1 + (uA * (y2-y1));


      return new PVector(intersectionX, intersectionY);
    }
    return NO_COLLISION;
  }
}
