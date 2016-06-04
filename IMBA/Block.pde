public class Block{
    private PImage img;
    private int size;
    private int ID;
    
    public Block(){
       //Do nothing; 
    }  
    public Block(String filename, int size, int ID){
      img = loadImage("./Images/Blocks/"+filename);
      this.size = size;
      this.ID = ID;
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
    public int getID(){
      return ID;  
    }
}