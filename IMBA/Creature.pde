/*
  THINGS NEEDED:
      Positionable array for collide        
      A way to include setSpeedHorizontal   **All Good!
      Display                               **All Good... I hope!
      Creature constructor                  **All Good!
*/
/*
  How this runs:
      1. Set the state
      2. move will automatically read the state and act accordingly (set the speed, move a bit)
      3. move handles the rest
      
      4. read player (or random move command generator) input
      5. update state
*/

public class Creature{
   public final static float gravity_constant = 30;
   
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
       state = "STOP";
       speedX = 0;
       speedY = 0;
       move();
   }

   
   public float getX() { return x; }
   public float getY() { return y; }
   public float getSpeedX() { return speedX; }
   public float getSpeedY() { return speedY; }
   public String getState() { return state; }
   
   public void setState(String newState) { state = newState; }
   public void setSpeedHorizontal(String direction) {
      if (direction.equals("LEFT")) {
         speedX = -8; 
      } else if (direction.equals("RIGHT")) {
         speedX = 8; 
      } else {
         System.out.println("Invalid move attempted"); 
      }
   }
      
   //checks the state and moves accordingly
   //changes the speed and location of creature
   public void move() {
      if (state.equals("FALLING")) {
         //just accelerate downwards 
      }
      else if (state.equals("JUMPING")) {
        speedY += 100;
      }
      else if (state.equals("DEFAULT")) {
          speedY = 0;
      }
      else if (state.equals("STOP")) {
         speedX = 0;
         speedY = 0; //may want to remove this -- if i'm on the ground it's 0, if i'm in the air would i want to stop midair?
      }
      //collide(new Positionable[30]);
      y += speedY;
      x += speedX;
      applyGravity();
      display();
   }
   
   //makes player move downwards
   public void applyGravity() {
      if (speedY < gravity_constant) {
         speedY = 0; 
      } else {
         speedY = speedY - gravity_constant; 
      }
   }
   
   //sets the speed (and state?) to accomodate for statuses
   //accomodates for the speed and state to prevent collisions
   public void collide(ArrayList<Positionable> others) {
     //decides behavior with the edges of the world
      if (y > height - 40 || y < 40) {
         speedY = 0; 
      } 
      //need to change with map scrolling
      if (x > width - 40 || x < 40) {
         speedX = 0; 
      }
      
      //prevents creature from going closer to another creature
      for (int i = 0; i < others.size(); i++) {
         float diffX = x - others.get(i).getX();
         float diffY = y - others.get(i).getY();
         //separate if with creature and blocks -- for blocks, see world code and use x,y cor (middle of the block) to determine collide
         if (diffX < 0 && diffX > -70) {
            if (speedX < 0) {
               speedX = 0; 
            }
         }
         if (diffX > 0 && diffX < 70) {
            if (speedX > 0) {
               speedX = 0; 
            }
         }
         
         if (diffY < 0 && diffY > -70) {
            if (speedY < 0) {
               speedY = 0; 
            }
         }
         if (diffY > 0 && diffY < -70) {
            if (speedY < 0) {
               speedY = 0; 
            }
         }
      }
      if (speedY == 0 ) {
        if (speedX == 0) {
           state = "STOP"; 
        } else {
           state = "DEFAULT"; 
        }
      }
   }
   
   public void display() {
     ellipseMode(CENTER);
      ellipse(x, 1000 - y, 20, 20); 
  }
  
  public void label() {
      text("Hi I'm A Creature!", x, 1000 - y);
  }
}