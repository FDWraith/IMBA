public class SolidBlock extends Block implements Positionable{
  private float xCor, yCor;
  private PImage img;
  
  public SolidBlock(String fileName){
    img = loadImage("./Images/Blocks/"+fileName);
    xCor = 0;//temp
    yCor = 0;//temp
  }
  
  public void display(float xCor, float yCor){
    imageMode(CENTER);
    image(img,xCor,yCor,100,100);
    this.xCor = xCor;
    this.yCor = yCor;
  }
  
  public float getX(){
   return xCor; 
  }
  public float getY(){
    return yCor; 
  }
}