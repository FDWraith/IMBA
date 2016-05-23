public class Npc  extends Creature{
   public void randomizeMove() {
      int randomChoice = (int)(Math.random() * 3);
      if (randomChoice == 0) {
         setState("DEFAULT");
         setSpeedHorizontal("LEFT"); 
      }
      else if (randomChoice == 1) {
         setState("DEFAULT");
         setSpeedHorizontal("RIGHT"); 
      }
      else if (randomChoice == 2) {
         setState("STOP"); 
      }
   }
}