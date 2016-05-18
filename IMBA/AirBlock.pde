public class AirBlock extends Block {
   public void display(double xCor, double yCor){
     noFill();
     rect((float)(xCor),(float)(yCor),50.0,50.0);
   }
   public AirBlock(){
     super("null.jpg"); 
   }
   
}