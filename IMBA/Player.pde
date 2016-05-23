public class Player extends Creature {
    public void handleUserInput(String lastKey) {
      if (lastKey.equals("W")) {
         setState("JUMPING");
      }
      if (lastKey.equals("A")) {
         setState("MOVING");
         
      }
      if (lastKey.equals("D")) {
         //setSpeedRight(); 
      }
    }
    
    
}