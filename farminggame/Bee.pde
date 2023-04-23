import java.util.ArrayList;

class Bee extends Character {

  State currentState;

  Bee() {
    super(color(0, 0, 255), loadImage("Assets/bee_normal.png"));
    this.location = graph.getRandomEmptyNode().getTileCenter();
    currentState = new FollowState();
  }

  void switchState(State state) {
    currentState = state;
    state.enterState(this);
  }

  void updateChaser(Farmer t) {
    currentState.updateState(this, t);
    this.update();
  }

  /*
  using A-star to create a path from the bee to the character when they are in range
  */
  void followPathTo(Farmer t) {
    
    Node chaseNode; //node of the bee
    Node targetNode; //node of the character

    int chaseNodeX = floor(location.x/graph.tileSize);
    int chaseNodeY = floor(location.y/graph.tileSize);

    chaseNode = graph.nodes.get(chaseNodeY * graph.cols + chaseNodeX);

    int targetNodeX = floor(t.location.x/graph.tileSize);
    int targetNodeY = floor(t.location.y/graph.tileSize);

    targetNode = graph.nodes.get(targetNodeY * graph.cols + targetNodeX);

    PVector steer;

    if (chaseNode == targetNode) {
      steer = this.arrive(targetNode.getTileCenter(), graph.tileSize);
      this.applyForce(steer);
    } else {
      if (!Water.contains(chaseNode))
      {
        ArrayList<Edge> path = graph.astar(chaseNode, targetNode);
        //visualize path
        /*for (Edge e : path) {
          e.endNode.path();
        }*/
        steer = this.seek(path.get(0).endNode.getTileCenter());
        this.applyForce(steer);
      }
    }
  }
}
