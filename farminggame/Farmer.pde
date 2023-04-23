class Farmer extends Character {

  Farmer() {
    super(color(100,100,100), loadImage("Assets/character_f.png"));
    this.location = graph.getRandomEmptyNode().getTileCenter();
  }
  
  void moveLeft() {
    this.characterImg = loadImage("Assets/character_l.png");
    Node n = getNodeFromOffset(-graph.tileSize, 0);
    if ((n != null) && (!n.block))
      this.location = n.getTileCenter();
  }
  
  void moveRight() {
    this.characterImg = loadImage("Assets/character_r.png");
    Node n = getNodeFromOffset(graph.tileSize, 0);
    if ((n != null) && (!n.block))
      this.location = n.getTileCenter();
  }
  
  void moveUp() {
    this.characterImg = loadImage("Assets/character_b.png");
    Node n = getNodeFromOffset(0, -graph.tileSize);
    if ((n != null) && (!n.block))
      this.location = n.getTileCenter();
  }
  
  void moveDown() {
    this.characterImg = loadImage("Assets/character_f.png");
    Node n = getNodeFromOffset(0, graph.tileSize);
    if ((n != null) && (!n.block))
      this.location = n.getTileCenter();
  }
  
  Node getNodeFromOffset(int xOffset, int yOffset) {
    int tileX = floor((location.x+xOffset)/graph.tileSize);
    int tileY = floor((location.y+yOffset)/graph.tileSize);
    int index = tileY * graph.cols + tileX;
    if ((index >= 0) && (index < graph.nodes.size()))
      return graph.nodes.get(tileY * graph.cols + tileX);
    else 
      return null;
  }
}
