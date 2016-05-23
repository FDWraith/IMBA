public class Player extends Creature{
    
  public void handleUserInput(String lastKey) {      
    if (lastKey.equals("W")) {
       setState("JUMPING");
    }
    if (lastKey.equals("A")) {
       setState("MOVING");
       setSpeedHorizontal("LEFT");
    }
    if (lastKey.equals("D")) {
      setState("MOVING");
      setSpeedHorizontal("RIGHT");
    }
  }  
  
  //overwrites creature's label
  public void label() {
     text("This Is You!", getX(), 1000 - getY()); 
  }
  
  /*
    NOTES:
        The most awkward thing I see is that w simply sets state to jumping, while for A and D I need to tell Creature class whether to move Left or Right. 
        It will cause no issues, but it is a discrepancy in code and may be annoying to grasp initially
  */
}