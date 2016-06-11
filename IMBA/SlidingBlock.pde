public class SlidingBlock extends MovableBlock{
  private int slideSpeed;  
  
  public SlidingBlock(String fileName, int size, int ID){
      super(fileName,size,ID);  
      initializeSlidingSpeed(ID);
  }
  
  private void initializeSlidingSpeed(int ID){
    switch(ID){
      case 7: slideSpeed = 5;
    }
  }
  
  public void move(ArrayList<Positionable> solidBlocks){
    setSpeedY(0);
    setSpeedX(slideSpeed);
    super.move(solidBlocks);
    if(super.collide(solidBlocks)){
      setSpeedX(-1 * slideSpeed );
    }
  }
  
}