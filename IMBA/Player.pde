public class Player extends Creature{
  
  public Player(float xCor, float yCor){
   super(xCor, yCor); 
  }
  
  
  public void handleUserInput(String lastKey) {
    System.out.println("\n\n\n\nHANDLING USER INPUT");
    if ((lastKey.equals("W") || lastKey.equals("w")) && !getIsJumping() /* && getState() != "FALLING" */){
       setState("JUMPING");
       setIsJumping(true);
    }
    if (lastKey.equals("A") || lastKey.equals("a")) {
       setState("DEFAULT");
       setSpeedHorizontal("LEFT");
    }
    if (lastKey.equals("D") || lastKey.equals("d")) {
      setState("DEFAULT");
      setSpeedHorizontal("RIGHT");
    }
  }  
  
  //overwrites creature's label
  public void label() {
     text("This Is You!", getX(), 1000 - getY()); 
  }
  /*
  public void move(ArrayList<Positionable> others){
    applyGravity();
    if (getState().equals("FALLING")) {
      if (getSpeedY() == 0) {
        setState("DEFAULT");
      }
      //just accelerate downwards
    } else if (getState().equals("JUMPING")) {
      setSpeedY(getSpeedY() + 10);
      setState("FALLING");
      //isJumping = true;
    } else if (getState().equals("DEFAULT")) {
      //speedY = 0;
      setState("STOP");
    } else if (getState().equals("STOP")) {
      applyFriction();
      //speedY = 0; //may want to remove this -- if i'm on the ground it's 0, if i'm in the air would i want to stop midair?
    }
    setX(getX() + getSpeedX());
    setY(getY() + getSpeedY());
    collide(others);
    //      System.out.println(speedY);
    display();
  }
  */
  
  
  
  
  /*
    NOTES:
        The most awkward thing I see is that w simply sets state to jumping, while for A and D I need to tell Creature class whether to move Left or Right. 
        It will cause no issues, but it is a discrepancy in code and may be annoying to grasp initially
  */
}