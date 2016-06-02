public class Block{
    private PImage img;
    private int size;
    
    public Block(){
       //Do nothing; 
    }  
    public Block(String filename, int size){
      img = loadImage("./Images/Blocks/"+filename);
      this.size = size;
    }
    public void display(float xCor, float yCor){
      imageMode(CENTER);
      image(img,xCor,yCor,size,size);
    }
    public int getSize(){
      return size;  
    }
    public PImage getImage(){
      return img;  
    }
}