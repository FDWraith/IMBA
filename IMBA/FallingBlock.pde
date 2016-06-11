public class FallingBlock extends MovableBlock{
  private float fall_constant;
  
  public FallingBlock(String fileName, int size, int ID){
    super(fileName,size,ID);   
    determineFallConstant(ID);
  }
  
  private void determineFallConstant(int ID){
    switch(ID){
      case 2: fall_constant = 1;
              break;
      
    }
  }
  
  public void triggerFall(){
    setSpeedY(-3);//Initial falling velocity is small, but gets faster as time continues.  
  }
  
  public void move(ArrayList<Positionable> solidBlocks){
    setSpeedX(0);//speedX is always zero since it is falling.
    setSpeedY(getSpeedY() - fall_constant);//change in speed is dependent on the block. 
    super.move(solidBlocks);
    if(super.collide(solidBlocks)){
      setSpeedY(0);  
    }
  }
  
}