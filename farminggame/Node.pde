enum TileType {
  Honey,
    Water,
    EmptyGrass,
    GrassPatch
}

class Node {

  int id;

  String name;
  ArrayList<Edge> edges;
  PVector position;
  float size;

  float angle = 0.0;

  PImage img;

  TileType type;

  boolean block;
  boolean grass;
  int fillcolor = 255;

  /*
  Node constructor
  */
  Node(String n, ArrayList<Edge> e, float x, float y, float mSize) {
    name = n;
    edges = e;

    position = new PVector(x, y);
    size = mSize;
  }

  void display() {
    rectMode(CORNER);
    noStroke();
    fill(fillcolor);
    rect(position.x, position.y, size, size);
  }

  /*
  choosing between different types of tiles to show in the graph
  */
  void setType(TileType t) {
    type = t;

    switch (type) {

    case Honey: //green square with yellow hexagon drawn in center (to show honeycomb)
      fillcolor = color(0, 148, 68);
      pushMatrix();
      fill(252, 211, 48);
      polygon(getTileCenter().x, getTileCenter().y, size/3, 6);
      popMatrix();
      break;
    case Water: //regular blue square
      fillcolor = color(0, 56, 147);
      break;
    case EmptyGrass: //regular green square
      fillcolor = color(0, 148, 68);
      break;
    case GrassPatch: //green square with rotating light green triangle (to show grass)
      fillcolor = color(0, 148, 68);
      pushMatrix();
      fill(57, 181, 74);
      translate(getTileCenter().x, getTileCenter().y);
      rotate(angle);
      polygon(0, 0, size/3, 3);
      angle += 0.01;
      popMatrix();
      break;
    }
  }

  void block()
  {
    block = true;
    setType(TileType.Water);
  }

  void emptypatch()
  {
    grass = true;
    setType(TileType.EmptyGrass);
  }
  
  void path()
  {
    fillcolor = color(204, 0, 0);
  }

  void reset() {
    if (!block && !grass)
      setType(TileType.GrassPatch);
  }

  PVector getTileCenter() {
    return new PVector(position.x + size/2, position.y + size/2);
  }

  /*
  method to help draw custom polygons
  */
  void polygon(float x, float y, float radius, int npoints) {
    float angle = TWO_PI / npoints;
    beginShape();
    for (float a = 0; a < TWO_PI; a += angle) {
      float sx = x + cos(a) * radius;
      float sy = y + sin(a) * radius;
      vertex(sx, sy);
    }
    endShape(CLOSE);
  }
}
