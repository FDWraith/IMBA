public class Npc  extends Creature {
  public Npc(float xcor, float ycor) {
    super(xcor, ycor);
  }

  public void randomizeMove(ArrayList<Positionable> others, ArrayList<Positionable> otherCreatures) {
    int randomChoice = (int)(Math.random() * 2);
    if (randomChoice == 0) {
      setState("DEFAULT");
      setSpeedHorizontal("LEFT");
    } else if (randomChoice == 1) {
      setState("DEFAULT");
      setSpeedHorizontal("RIGHT");
    }
    move(others, otherCreatures);
  }
}