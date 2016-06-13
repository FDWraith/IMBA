public class Block implements Positionable {
  private PImage img;
  private int size;
  private int ID;
  private float xCor, yCor;

  public Block() {
    //Do nothing;
  }  
  public Block(String filename, int size, int ID) {
    img = loadImage("./Images/Blocks/"+filename);
    this.size = size;
    this.ID = ID;
  }
  public void display(float xCor, float yCor) {
    imageMode(CENTER);
    image(img, xCor, yCor, size, size);
    this.xCor = xCor;
    this.yCor = 1000 - yCor;
  }
  public void display() {
    //nada
  }
  public int getSize() {
    return size;
  }
  public PImage getImage() {
    return img;
  }
  public int getID() {
    return ID;
  }
  public float getX() {
    return xCor;
  }
  public float getY() {
    return yCor;
  }
  public void setX(float x) {
    xCor = x;
  }
  public void setY(float y) {
    yCor = y;
  }
}