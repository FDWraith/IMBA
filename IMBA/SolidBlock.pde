public class SolidBlock extends Block implements Positionable{
  private float xCor, yCor;
  
  public SolidBlock(String fileName, int size){
    super(fileName, size);
  }
  
  public void display(float xCor, float yCor){
    imageMode(CENTER);
    image(getImage(),xCor,yCor,getSize(),getSize());
    this.xCor = xCor;
    this.yCor = 1000 - yCor;
  }
  
  public float getX(){
   return xCor; 
  }
  public float getY(){
    return yCor; 
  }
}