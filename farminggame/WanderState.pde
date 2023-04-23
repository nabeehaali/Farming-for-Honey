class WanderState extends State {

  void enterState(Bee bee) {
    bee.characterImg = loadImage("Assets/bee_normal.png");
  }

  void updateState(Bee bee, Farmer farmer) {
    //if the bee is within range of the player, make the bee follow the player
    if (PVector.dist(bee.location, farmer.location) < 200) {
      bee.switchState(new FollowState());
    } else {
      
      //bee wanders in the scene
      PVector wander = bee.wander();
      bee.applyForce(wander);
      
      //while wandering, whiskers are added to the bee to avoid collision with the water      
      PVector collision = bee.avoidCollisionNodes(Water, 40, 160);
  
      // If the magnitude of the collision force is > 0, there is a collision
      if (collision.mag() > 0) {
        bee.applyForce(collision);
      
      }
    }
  }
}
