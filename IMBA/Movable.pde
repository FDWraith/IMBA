public interface Moveable extends Positionable {
  public void move(); 
  public void collide(ArrayList<Positionable> others); 

}