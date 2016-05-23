public class Creature{
   public final static float gravity_constant = 9.81;
   
   private float x, y, speedX, speedY;
   private String state;
     //There are several states:
        //JUMPING: The user will temporarily accelerate dramatically, and state reverts to falling
        //FALLING: The user is mid-air and will fall
        //DEFAULT: The user is on the ground and is walking by default
   
   public float getX() { return x; }
   public float getY() { return y; }
   public float getSpeedX() { return speedX; }
   public float getSpeedY() { return speedY; }
   public String getState() { return state; }
   
   public void setState(String newState) { state = newState; }
   public void setSpeedX(float newSpeedX) { speedX = newSpeedX; }
   
   
   //All we need to do now is set speed appropriately
   public void move() {
      if (state.equals("FALLING")) {
         //just accelerate downwards 
      }
      else if (state.equals("JUMPING")) {
        //gravity -- may need to add by .981 instead -- REQUIRES TESTING
        speedY += 9.81;
      }
      else if (state.equals("DEFAULT")) {
          speedY = 0;
      }
      //collide(new Positionable[30]);
      y += speedY;
      x += speedX;
      applyGravity();
      //speedX = Math.abs(speedX / 10 - .001); //accounts for friction
   }
   
   public void applyGravity() {
      if (speedY < gravity_constant) {
         speedY = 0; 
      } else {
         speedY = speedY - gravity_constant; 
      }
   }
   
   public void moveHorizontal(String direction) {
      if (direction.equals("LEFT")) {
         speedX = -5; 
      } else {
         speedX = 5; 
      }
   }
   
   //sets the speed (and state?) to accomodate for statuses
   //accomodates for the speed and state to prevent collisions
   public void collide(Positionable[] others) {
     //decides behavior with the edges of the world
      if (y > height - 40 || y < 40) {
         speedY = 0; 
      } 
      //need to change with map scrolling
      if (x > width - 40 || x < 40) {
         speedX = 0; 
      }
      
      //prevents creature from going closer to another creature
      for (int i = 0; i < others.length; i++) {
         float diffX = x - others[i].getX();
         float diffY = y - others[i].getY();
         //separate if with creature and blocks -- for blocks, see world code and use x,y cor (middle of the block) to determine collide
         if (diffX < 0 && diffX > -40) {
            if (speedX < 0) {
               speedX = 0; 
            }
         }
         if (diffX > 0 && diffX < 40) {
            if (speedX > 0) {
               speedX = 0; 
            }
         }
         
         if (diffY < 0 && diffY > -40) {
            if (speedY < 0) {
               speedY = 0; 
            }
         }
         if (diffY > 0 && diffY < -40) {
            if (speedY < 0) {
               speedY = 0; 
            }
         }
      }
      if (speedY == 0) {
         state = "DEFAULT"; 
      }
   }
   
   public void display() {
      text("Hi I'm A Creature!", x, y); 
  }
  
  public void jump() {
    
  }
}