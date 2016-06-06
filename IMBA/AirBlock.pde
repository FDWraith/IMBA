public class AirBlock extends Block {
  
   public AirBlock(int size, int ID){
     super("null.jpg", size, ID);
   }
   
   public void display(float xCor, float yCor){
     rectMode(CENTER);
     noStroke();
     noFill();
     rect(xCor,yCor,getSize(),getSize());
     setX(xCor);
     setY(1000-yCor);
   }
}