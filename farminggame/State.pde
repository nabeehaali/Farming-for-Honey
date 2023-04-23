abstract class State {

  abstract void enterState(Bee bee);
  
  abstract void updateState(Bee bee, Farmer farmer);
  
}
