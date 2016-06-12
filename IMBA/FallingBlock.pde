public class FallingBlock extends MovableBlock{
  private float fall_constant;
  private boolean triggered = false;
  
  public FallingBlock(String fileName, int size, int ID){
    super(fileName,size,ID);   
    determineFallConstant(ID);
  }
  
  private void determineFallConstant(int ID){
    switch(ID){
      case 2: fall_constant = 0.01;
              break;
      
    }
  }
  
  public void triggerFall(){
    setSpeedY(-1);//Initial falling velocity is small, but gets faster as time continues. 
    triggered = true;
  }
 
  public void move(ArrayList<Positionable> solidBlocks){
    if(triggered){
      //println(getSpeedY());
      setSpeedX(0);//speedX is always zero since it is falling.
      setSpeedY(getSpeedY() - fall_constant);//change in speed is dependent on the block. 
      //println("break1");
      super.move(solidBlocks);
      //println("break2");
      if(super.collide(solidBlocks)){
        setSpeedY(0);
        println("happened");
      }
      //println("triggering");
    }
  }
  
}