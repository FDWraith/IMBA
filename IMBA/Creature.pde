public class Creature{
   private float x, y, speedX, speedY;
   private String state;
   
   public float getX() { return x; }
   public float getY() { return y; }
   public float getSpeedX() { return speedX; }
   public float getSpeedY() { return speedY; }
   public String getState() { return state; }
   
   public void setState(String newState) { state = newState; }
   
   //All we need to do now is set speed appropriately
   public void move() {
      if (state.equals("FALLING") || state.equals("JUMPING")) {
        y += speedY;
        //may need to add by .981 instead -- REQUIRES TESTING
        speedY += 9.81;
      }
      else if (state.equals("WALKING")) {
          speedY = 0;
      }
      x += speedX;
      Math.abs(speedX /= 10 - .001); //accounts for friction
   }
   
   public void collide(Positionable[] others) {
      if (y > height - 40 || y < 40) {
         speedY = 0; 
      } 
      if (x > width - 40 || x < 40) {
         speedX = 0; 
      }
      
      //prevents creature from going closer to another creature
      for (int i = 0; i < others.length; i++) {
         float diffX = x - others[i].getX();
         float diffY = y - others[i].getY();
         
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
   }
   
   public void display() {
      text("Hi I'm A Creature!", x, y); 
  }
}