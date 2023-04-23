Graph graph;
LCG lcg;

ArrayList<Node> Honeycombs;
ArrayList<Node> Water;

boolean gameOver = false;

Farmer farmer;
ArrayList<Bee> bees;

void setup() {
  size(900, 600);
  background(255);

  //setting up perlin noise before converting to graph (to procedurally generate the world)
  Perlin perlin = new Perlin(50);

  for (int x = 0; x < width; x++) {
    for (int y = 0; y < height; y++) {
      float val = perlin.octaveNoise(x, y, 0.01, 8, 0.5);
      int c = color(0, 0, 120);
      if (val < 0.52) {
        c = color(0, 100, 0);
      } else if ((0.52 < val) && (val < 0.54)) {
        c = color(255, 200, 100);
      } else if ((0.54 < val) && (val < 0.56)) {
        c = color(0, 100, 200);
      }
      set(x, y, c);
    }
  }

  //assigning values for blocked nodes, honeycomb collectibles (to keep track of score), and chasing bees
  Water = new ArrayList<Node>();
  Honeycombs = new ArrayList<Node>();
  bees = new ArrayList<Bee>();
  
  //setting up graph and random value generator
  lcg = new LCG();
  graph = new Graph();
  graph.initialize(width, height, 20);

  //converting perlin noise to graph based on color of pixel
  for (Node n : graph.nodes) {
    PVector loc = n.getTileCenter();
    if (get(int(loc.x), int(loc.y)) == color(0, 0, 120)) { //if color from perlin noise was blue (water)
      Water.add(n);
      n.block();
      graph.handleBlockedNodes();
    } else if (get(int(loc.x), int(loc.y)) == color(0, 100, 200) || get(int(loc.x), int(loc.y)) == color(255, 200, 100) ) { //if color from perlin noise was beige (sand), make it an empty patch
      n.emptypatch();
    } else { // if the color was anything else, make it a grass patch
      n.setType(TileType.GrassPatch);
    }
  }

  //using LCG to choose a number of honeycombs to make
  int numberHoneycombs = (int)lcg.generate(0, 15);

  //generating honeycombs
  for (int i = 0; i < numberHoneycombs; i++)
  {
    Node myHoneycomb = graph.getRandomEmptyNode();
    Honeycombs.add(myHoneycomb);
  }

  //setting up character
  farmer = new Farmer();

}

void draw() {
  
  //displaying the graph based on values defined at setup
  for (Node n : graph.nodes) {
    n.display();
    
    //looping through each honeycomb node and checking to see if the character has intersected with it
    for (int i = 0; i < Honeycombs.size(); i++)
    {
      float distance = PVector.dist(farmer.location, Honeycombs.get(i).getTileCenter());
      if (distance == 0)
      {
        //convert the honeycomb to a regular grass tile, remove it from the list, and add a new bee to the canvas
        Honeycombs.get(i).setType(TileType.GrassPatch);
        Honeycombs.remove(i);
        Bee newBee = new Bee();
        bees.add(newBee);
      } else
      {
        graph.nodes.get(Honeycombs.get(i).id).setType(TileType.Honey);
      }
    }
    n.reset();
  }

  //showing the character
  farmer.display();

  //showing all of the bees
  for (int i = 0; i < bees.size(); i++)
  {
    bees.get(i).display();
    bees.get(i).checkEdges();
    bees.get(i).updateChaser(farmer);
  }
  
  //checking the distance from the charater to each bee and seeing if they instersect each other
  for (int i = 0; i < bees.size(); i++)
  {
    float chased = PVector.dist(farmer.location, bees.get(i).location);
    if (chased <= 1) //game is over when the bee gets to the character
    {
      //game over screen
      background(204, 0, 0);
      rectMode(CENTER);
      fill(0, 56, 147);
      noStroke();
      rect(width/2, height/2, width-40, height-40);
      textSize(40);
      textAlign(CENTER);
      fill(204, 0, 0);
      text("YOU LOST!", width/2, height/2);

      PImage bee = loadImage("Assets/bee_normal.png");
      image(bee, width/2, height/2 + 220, 50, 50);
      
      gameOver = true;
    }
  }
  
  //if there are no more honeycombs in the list (i.e the player has collected all the honeycombs)
  if (Honeycombs.size() == 0)
  {
    //winning screen
    background(219, 191, 74);
    rectMode(CENTER);
    fill(0, 148, 68);
    noStroke();
    rect(width/2, height/2, width-40, height-40);
    textSize(40);
    textAlign(CENTER);
    fill(219, 191, 74);
    text("YOU WON!", width/2, height/2);

    PImage farmer = loadImage("Assets/character_gameOver.png");
    image(farmer, width/2, height/2 + 220, 50, 50);
  }
}

//prevent character from moving if the game is over
void keyPressed() {
  if (keyCode == LEFT) {
    if(!gameOver)
    farmer.moveLeft();
  } else if (keyCode == RIGHT) {
    if(!gameOver)
    farmer.moveRight();
  } else if (keyCode == UP) {
    if(!gameOver)
    farmer.moveUp();
  } else if (keyCode == DOWN) {
    if(!gameOver)
    farmer.moveDown();
  }
}
