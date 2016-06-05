import java.util.*;

/*
  THINGS NEEDED:
 Positionable array for collide        
 A way to include setSpeedHorizontal   **All Good!
 Display                               **All Good... I hope!
 Creature constructor                  **All Good!
 */
/*
  CURRENT ISSUES:
 1. Jumping on the floor (sometimes y position is 35 instead of 40 -- i'll jump, then immediately set speed back to 0 --- hopefully this won't need to happen after 2 is done   **??done?
 2. Colliding with the blocks... like wtf man!    --- WORKS!!!!
 3. Jumping nonstop                               --- WORKS!!!!
 4. Moving while jumping                          --- WORKS!!!!
/*
 How this runs:
 1. Set the state
 2. move will automatically read the state and act accordingly (set the speed, move a bit)
 3. move handles the rest
 
 4. read player (or random move command generator) input
 5. update state
 */

public class Creature {
  private Block[][] board;

  public static final float gravity_constant = 5;
  public static final float friction_constant = .1;
  public static final float max_speedx = 10;
  public static final float accelerateX = 3;

  public static final float ceiling_constant = 1000 - 40;
  public static final float floor_constant = 40;
  public static final float leftWall_constant = 40;
  public static final float rightWall_constant = 40;

  //crude but effective solution to multi-jump
  private boolean isJumping = false;
  private boolean onFloor = false;
  private float x, y, speedX, speedY;
  private String state;
  //There are several states:
  //JUMPING: The user will temporarily accelerate dramatically, and state reverts to falling
  //FALLING: The user is mid-air. **You can be accelerating upwards, but you are regardless mid-air and thus will fall... eventually
  //DEFAULT: The user is on the ground and is walking by default
  //STOP: The user has stopped

  public Creature() {
    this(0, 0);
  }

  public Creature(float xcor, float ycor) {
    x = xcor;
    y = ycor;
    state = "FALLING";
    speedX = 0;
    speedY = 0;
    display();
  }

  public Creature(float xcor, float ycor, Block[][] b) {
    this(xcor, ycor);
    board = b;
  }


  public float getX() { 
    return x;
  }
  public float getY() { 
    return y;
  }
  public float getSpeedX() { 
    return speedX;
  }
  public float getSpeedY() { 
    return speedY;
  }
  public String getState() { 
    return state;
  }
  public boolean getIsJumping() {
    return isJumping;
  }

  public void setState(String newState) { 
    state = newState;
  }
  public void setSpeedHorizontal(String direction) {
    if (direction.equals("LEFT")) {
      if (speedX >= -1 * max_speedx + accelerateX) {
        speedX -= accelerateX;
      }
    } else if (direction.equals("RIGHT")) {
      if (speedX <= max_speedx - accelerateX) {
        speedX += accelerateX;
      }
    } else {
      System.out.println("Invalid move attempted");
    }
  }
  public void setIsJumping(boolean b) {
    isJumping = b;
  }

  private void applyFriction() {
    //player moves to the right
    if (speedX > 0) {
      if (speedX > friction_constant) {
        speedX -= friction_constant;
      } else {
        speedX = 0;
      }
    } else { //player moves to the left
      if (speedX < friction_constant) {
        speedX += friction_constant;
      } else {
        speedX = 0;
      }
    }
  }

  //checks the state and moves accordingly
  //changes the speed and location of creature
  public void move(ArrayList<Positionable> others) {
    applyGravity();
    if (state.equals("FALLING")) {
      if (speedY == 0) {
        state = "DEFAULT";
        isJumping = false;
      }
      //just accelerate downwards
    } else if (state.equals("JUMPING")) {
      speedY += 50;
      state = "FALLING";
      isJumping = true;
      //      onFloor = false;
    } else if (state.equals("DEFAULT")) {
      //speedY = 0;
      state = "STOP";
    } else if (state.equals("STOP")) {
      applyFriction();
      //speedY = 0; //may want to remove this -- if i'm on the ground it's 0, if i'm in the air would i want to stop midair?
    }
    collide(others);
    y += speedY;
    x += speedX;

    //System.out.println("~~~~~~~~~~~~~~START GOING BACK~~~~~~~~~~~~~~");
    goBack(others);
    //System.out.println("~~~~~~~~~~~~~~~END GOING BACK~~~~~~~~~~~~~~~");
    //      System.out.println(speedY);
    display();
    //    System.out.println("OnFloor= "+onFloor);
    System.out.println("" + state + " Speed(X, Y): (" + speedX + ", " + speedY);
    //      System.out.println("Y: "+y);
  }

  //makes player move downwards
  public void applyGravity() {
    /*if (state.equals("FALLING") || state.equals("JUMPING")) {
     speedY = speedY - gravity_constant; 
     }*/
    if (!checkOnFloor()) {
      System.out.println("Applying Gravity");
      speedY = speedY - gravity_constant;
    }
  }

  //sets the speed (and state?) to accomodate for statuses
  //accomodates for the speed and state to prevent collisions
  public void collide(ArrayList<Positionable> others) {
    //decides behavior with the edges of the world
    if (y > height - 40) {
      y = height - 40;
      speedY = (-1) * gravity_constant;
    }
    if (y < 40) {
      y = 40;
      speedY = 0;
      isJumping = false;
    }
    //need to change with map scrolling
    if (x < 40) {
      x -= speedX;
      speedX = 0;
    }

    //prevents creature from going closer to another creature
    for (int i = 0; i < others.size(); i++) {
      float diffX = x - others.get(i).getX();
      float diffY = y - others.get(i).getY();
      //separate if with creature and blocks -- for blocks, see world code and use x,y cor (middle of the block) to determine collide

      //creature is above block and about to fall through it
      if (diffY > 0 && diffY < 81 && diffX > -50 && diffX < 50) {
        if (speedY < 0) {
          //speedY = 0; 
          isJumping = false;
          System.out.println("4th if statement");
        }
      }
      //creature is left of block
      if (diffY > -50 && diffY < 50 && diffX < -50 && diffX > -60) {
        if (speedX > 0) {
          //speedX = 0;  
          System.out.println("5th if statement");
        }
      }
      //creature is right of block
      if (diffY > -50 && diffY < 50 && diffX > 50 && diffX < 60) {
        if (speedX < 0) {
          //speedX = 0;  
          System.out.println("6th if statement");
        }
      }
    }
  }

  //helper function for collide -- reverts the speed of a unit in an illegal place until it is in a valid location
  //THIS IS ONLY FOR BLOCKS!! (not the edges of world, maybe other creatures)
  public void goBack(ArrayList<Positionable> others) {
    //a simple variable to see if i went back
    boolean wentBack = false;
    float newSpeedX = (-speedX) / 100;
    float newSpeedY = (-speedY) / 100;

    //int counter = 100;

    for (int i = 0; i < others.size(); i++) {
      float diffX = x - others.get(i).getX();
      float diffY = y - others.get(i).getY();
      //System.out.println("newSpeed(X, Y): ("+newSpeedX+", "+newSpeedY);

      //System.out.println("\tDiff(X,Y): ("+diffX+", "+diffY+")");

      //onFloor = false;
      while (diffY > -70 && diffY < 70 && diffX > -70 && diffX < 70 && speedY <= 0 /*&& counter > 0*/) { //won't back up when jumping up
        //System.out.println("\n\n\n\n\n\nRUNNING THE WHILE LOOP!!!!!\n\n\n\n\n\n");
        x += newSpeedX;
        y += newSpeedY;
        diffX = x - others.get(i).getX();
        diffY = y - others.get(i).getY();
        wentBack = true;

        if (diffY >= 70) {
          //          onFloor = true;
          isJumping = false;
          System.out.println("Setting onFloor to true");
        } else {
          //          onFloor = false; 
          isJumping = true;
        }
      }
    }
    if (wentBack) {
      System.out.println("Backed up! -- setting speeds to 0!");
      speedX = 0;
      speedY = 0;
    }
  }

  public boolean checkOnFloor() {
    try {
      System.out.println(isSolid(x-1, y-1));
      return isSolid(x-10, y-10);
    }
    catch (NullPointerException e) {
      return false;
    }
  }

  public void display() {
    fill(#000000);
    ellipseMode(CENTER);
    ellipse(x, 1000 - y, 40, 40);
    label();
  }

  public void label() {
    text("Hi I'm A Creature!", x, 1000 - y);
  }

  public boolean isSolid(float xCor, float yCor) {
    if ( board[ ( Math.round(xCor)/* - 50 */) / 100][ (Math.round(yCor)/* - 50*/) / 100] instanceof SolidBlock) {
      return true;
    } else {
      return false;
    }
  }
}