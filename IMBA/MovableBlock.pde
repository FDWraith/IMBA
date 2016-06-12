public class MovableBlock extends SolidBlock implements Movable{
  private float speedX, speedY;
  
  public MovableBlock(String fileName, int size, int ID){
    super(fileName, size, ID);
    speedX = 0;
    speedY = 0;
  }
  
  public void setSpeedX(float in){
    speedX = in; 
  }
  public void setSpeedY(float in){
    speedY = in;  
  }  
  public float getSpeedY(){
    return speedY;  
  }
  public float getSpeedX(){
    return speedX;
  }
  public void move(ArrayList<Positionable> solidBlocks){
    if( getX() - getSize() / 2 > 0){
      setX(speedX + getX());
      println(getX());
    }
    if( getY() - getSize() / 2 > 0){
      setY(speedY + getY()); 
    }        
    //collide(solidBlocks);
  }
  public boolean collide(ArrayList<Positionable> solidBlocks){
    boolean end = false;
    for(int i = 0; i < solidBlocks.size(); i++){
     //if(solidBlocks.get(i) != this){
        boolean b = moveBack( (SolidBlock)(solidBlocks.get(i)) );  
        if(b){end = true;}
      //}
    }
    return end;
  }
  
  public boolean moveBack(SolidBlock b){
    boolean end = false;
    float diffX = abs( getX() - b.getX() );
    float diffY = abs( getY() - b.getY() );
    if(diffX == 0 && diffY == 0){
      return false;  
    }
    //println(diffX+","+diffY);
    if(getSpeedX() != 0){
      while(diffX < b.getSize() && diffY < b.getSize() ){
        end = true;
        setX( getX() - getSpeedX() );
        diffX = abs( getX() - b.getX() );
      }
    }
    if(getSpeedY() != 0){
      println(getY());
      while(diffY < b.getSize() && diffX < b.getSize() ){
        end = true;
        //setY( 1000 - ((1000 - getY()) - getSpeedY()));
        setY(getY() - getSpeedY());
        diffY = abs( getY() + b.getY() );
      }
    }
    return end;
  }
}