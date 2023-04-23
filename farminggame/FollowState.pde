class FollowState extends State {

  void enterState(Bee bee) {
    bee.characterImg = loadImage("Assets/bee_angry.png");
  }
  
  void updateState(Bee bee, Farmer farmer) {
    
    //if the bee is not in range of the character, make it wander
    if (PVector.dist(bee.location, farmer.location) > 200) {
      bee.switchState(new WanderState());
    } else {
      //make the bee follow the player (whiskers for colission avoidance are disabled in order to use the seek behaviour to find the character)
      bee.followPathTo(farmer);
    }
  }
  
}
