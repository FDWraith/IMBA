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

public class Creature implements Positionable {
  private Block[][] board;

  public static final float epsilon = .1;
  public static final float gravity_constant = 1.5;
  public static final float friction_constant = .1;
  public static final float max_speedx = 10;
  public static final float accelerateX = 3;
  public static final float jumping_constant = 28;

  public static final float ceiling_constant = 1000 - 40;
  public static final float floor_constant = 20;
  public static final float leftWall_constant = 20;
  public static final float rightWall_constant = 20;

  //crude but effective solution to multi-jump
  private boolean isJumping = false;
  private boolean onFloor = false;
  private float x, y, speedX, speedY;
  private String state;
  //There are several states:
  //JUMPING: The user will temporarily accelerate dramatically, and state reverts to rising
  //RISING:  The user is moving upwards
  //FALLING: The user is moving downwrds
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
  public void setX(float num) {
    x = num;
  }
  public void setY(float num) {
    y = num;
  }
  public void setSpeedX(float num) {
    if (num < .000001) {
      speedX = 0;
    } else {
      speedX = num;
    }
  }
  public void setSpeedY(float num) {
    if (num < .000001) {
      speedY = 0;
    } else {
      speedY = num;
    }
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
    //System.out.println("Applying Friction");
    if (speedX > 0) {
      if (speedX > friction_constant) {
        speedX -= friction_constant;
      } else {
        speedX = 0;
      }
    } else if (speedX  < 0) { //player moves to the left
      if (speedX < friction_constant) {
        speedX += friction_constant;
      } else {
        speedX = 0;
      }
    }
  }

  //checks the state and moves accordingly
  //changes the speed and location of creature
  public void move(ArrayList<Positionable> others, ArrayList<Positionable> otherCreatures) {
    applyGravity();
    if (state.equals("JUMPING")) {
      speedY += jumping_constant;
      state = "RISING";
      isJumping = true;
      onFloor = false;
    } else if (state.equals("RISING")) {
      if (speedY - epsilon <= 0) {
        state = "FALLING";
      }
    } else if (state.equals("FALLING")) {
      if (speedY == 0) {
        state = "DEFAULT";
      }
    } else if (state.equals("DEFAULT")) {
      isJumping = false;
      //speedY = 0;
      state = "STOP";
    } else if (state.equals("STOP")) {
      applyFriction();
      //speedY = 0; //may want to remove this -- if i'm on the ground it's 0, if i'm in the air would i want to stop midair?
    }
    collide(others);
    y += speedY;
    x += speedX;

    //goBackCreature(otherCreatures);
    goBack(others);
    display();
    //System.out.println("" + state + " Speed(X, Y): (" + speedX + ", " + speedY);
  }

  //makes player move downwards
  public void applyGravity() {
    /*if (state.equals("FALLING") || state.equals("JUMPING")) {
     speedY = speedY - gravity_constant; 
     }*/
    //System.out.println(onFloor);
    if (onFloor == false) {
      speedY = speedY - gravity_constant;
    }
    /*   if (!checkOnFloor()) {
     System.out.println("Applying Gravity");
     speedY = speedY - gravity_constant;
     }
     */
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
          //System.out.println("4th if statement");
        }
      }
      //creature is left of block
      if (diffY > -50 && diffY < 50 && diffX < -50 && diffX > -60) {
        if (speedX > 0) {
          //speedX = 0;  
          //System.out.println("5th if statement");
        }
      }
      //creature is right of block
      if (diffY > -50 && diffY < 50 && diffX > 50 && diffX < 60) {
        if (speedX < 0) {
          //speedX = 0;  
          //System.out.println("6th if statement");
        }
      }
    }
  }

  //helper function for collide -- reverts the speed of a unit in an illegal place until it is in a valid location
  //THIS IS ONLY FOR BLOCKS!! (not the edges of world, maybe other creatures)
  public void goBack(ArrayList<Positionable> others) {
    //a simple variable to see if i went back
    boolean wentBack = false;
    float newSpeedX = (-speedX) / 30;
    float newSpeedY = (-speedY) / 30;
    //if (newSpeedX < epsilon * 5) { newSpeedX = epsilon * 5; }
    float diffX = 0;
    float diffY = 0;

    //int counter = 100;

    onFloor = false;
    for (int i = 0; i < others.size(); i++) {
      diffX = x - others.get(i).getX();
      diffY = y - others.get(i).getY();
      if (diffY >= -70.5 && diffY <= 70.5 && diffX >= -70.5 && diffX <= 70.5 /*&& speedY <= 0*/) {
        if (diffY - 70.15 > epsilon && diffY - 70.15 < -epsilon) {
          onFloor = false; 
          System.out.println(diffY);
          System.out.println("\n\nMade onFloor False again!");
        }
        if (diffY + 70.39 > epsilon && diffY + 70.49 < -epsilon) {
          onFloor = true; 
          System.out.println(diffY);
          System.out.println("\n\nMade onFloor True again!");
        }
      }
      while (diffY > -70 && diffY < 70 && diffX > -70 && diffX < 70 /*&& speedY <= 0*/ /*&& counter > 0*/) { //won't back up when jumping up
        /*System.out.print("\tdiffX: "+diffX);
         System.out.println("\tdiffY: "+diffY);*/
        x += newSpeedX;
        y += newSpeedY;
        diffX = x - others.get(i).getX();
        diffY = y - others.get(i).getY();
        wentBack = true;

        if (Math.abs(diffY - 70) > epsilon) {
          onFloor = true;
          isJumping = false;
          speedY = 0;
          //System.out.println("Setting onFloor to true");
        } else if (Math.abs(diffY + 70) > epsilon) {
          onFloor = false;
          isJumping = true;
          speedY = gravity_constant;
          wentBack = false;
        }
      }
    }
    if (wentBack) {
      //System.out.println("Backed up! -- setting speeds to 0!");
      speedX = 0;
      speedY = 0;
    }
  }

  public void goBackCreature(ArrayList<Positionable> others) {
    float newSpeedX; //= (-speedX) / 30;
    float newSpeedY = (-speedY) / 30;
    //if (newSpeedX < epsilon * 5) { newSpeedX = epsilon * 5; }
    float diffX = 0;
    float diffY = 0;
    boolean wentBack = false;
    for (int i = 0; i < others.size(); i++) { //loops through all creatuers
      if (others.get(i).getX() != x && others.get(i).getY() != y) { //ensures you're not the creature being read
        diffX = x - others.get(i).getX();
        diffY = y - others.get(i).getY();
        while (diffX < 40 && diffX > -40 && diffY < 40 && diffY > -40) { //while still touching
          /*
          if (speedX < epsilon && speedX > -epsilon) { //makes sure newSpeedX is not negligible
           newSpeedX = -((Math.abs(speedX)) / speedX) * epsilon / 30; 
           }
           */
          if (diffX < 0) { //if creature is to the left
            if (speedX < epsilon && speedX > -epsilon) { //if speed is too small/negligible
              newSpeedX = -epsilon / 30;
            } else { //if speed is large enough
              newSpeedX = -(Math.abs(speedX)) / 30;
            }
          } else { //creature is to the right
            if (speedX < epsilon && speedX > -epsilon) { //speed is negligible
              newSpeedX = epsilon / 30;
            } else {
              newSpeedX = Math.abs(speedX) / 30;
            }
          }
          x += newSpeedX;
          diffX = x - others.get(i).getX();
          wentBack = true;
        }
        /*
        if (diffX < 40 && diffX > -40 && diffY < 40 && diffY > -40) {
         speedX = -speedX;
         x += speedX;
         }
         */
      }
    }
    if (wentBack) {
      speedX = -speedX;
    }
  }

  /*
  public boolean checkOnFloor() {
   System.out.println("\tRunning CheckOnFloor!");
   try {
   System.out.print("\tRunning Check!");
   System.out.println("\tisSolid: "+ str(isSolid(x, y+10)));
   return isSolid(x, y+50);
   }
   catch (NullPointerException e) {
   return false;
   }
   }
   */

  public void display() {
    fill(#A3A3A3);
    //ellipseMode(CENTER);
    //ellipse(x, 1000 - y, 40, 40);
    rectMode(CENTER);
    rect(x, 1000-y, 40, 40);
    label();
  }

  public void label() {
    text("Hi I'm A Creature!", x - 30, 1000 - y - 23);
  }

  /*  public boolean isSolid(float xCor, float yCor) {
   System.out.println("\tRunning isSolid!");
   System.out.println(Math.round(xCor));
   System.out.println(Math.round(yCor));
   System.out.println(Math.round(xCor) / 100);
   System.out.println(Math.round(yCor) / 100);
   System.out.println(board[1][1] instanceof SolidBlock);
   System.out.print("c"+(board[(Math.round(xCor)) / 100][ (Math.round(yCor)) / 100] instanceof SolidBlock));
   System.out.println("\n\n\n");
   if (board[ ( Math.round(xCor) - 50 ) / 100][ (Math.round(yCor) - 50) / 100] instanceof SolidBlock) {
   System.out.println("True!");
   return true;
   } else {
   System.out.println("False!");
   return false;
   }
   }*/
}