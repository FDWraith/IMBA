public class SlidingBlock extends MovableBlock{
  private int slideSpeed;  
  private boolean first = true;
  
  public SlidingBlock(String fileName, int size, int ID){
      super(fileName,size,ID);  
      initializeSlidingSpeed(ID);
  }
  
  private void initializeSlidingSpeed(int ID){
    switch(ID){
      case 7: slideSpeed = 1;
    }
  }
  
  public void move(ArrayList<Positionable> solidBlocks){
   if(first){ 
      setSpeedY(0);
      setSpeedX(slideSpeed);
      first = false;
    }
    //println(getSpeedX()+","+getSpeedY());
    super.move(solidBlocks);
    if(super.collide(solidBlocks)){
      //println(getSpeedX());
      setSpeedX(-1 * getSpeedX());//speed is not inverting for some reason?
      //println("It has happened");
      //println(getSpeedX());
    }
  }
  
}