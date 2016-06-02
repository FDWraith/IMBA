public class AirBlock extends Block {
  
   public AirBlock(int size){
     super("null.jpg", size);
   }
   
   public void display(float xCor, float yCor){
     rectMode(CENTER);
     noFill();
     noStroke();
     rect(xCor,yCor,getSize(),getSize());
   }
}