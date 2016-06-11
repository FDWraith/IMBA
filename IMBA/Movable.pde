public interface Movable extends Positionable {
  public void move(ArrayList<Positionable> others); 
  public boolean collide(ArrayList<Positionable> others); 
}