public class Block{
    private PImage img;

    public Block(String filename){
      img = loadImage("./Images/Blocks/"+filename); 
    }
    public void display(float xCor, float yCor){
      imageMode(CENTER);
      image(img,xCor,yCor,100,100);
    }
}