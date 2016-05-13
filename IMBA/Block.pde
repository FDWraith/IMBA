public class Block implements Displayable{
    private int xCor, yCor;
    private int blockColor;
    
    public Block(int x, int y, int blockColor) {
       xCor = x;
       yCor = y;
       setColor(blockColor);
    }
    public Block(int x, int y) {
       xCor = x;
       yCor = y;
       blockColor = 0;
    }    
    public void setColor(int c){
      blockColor = c;
    }
    public void setXCor(int x){
      xCor = x;
    }
    public void setYCor(int y){
	yCor = y;
    }
    public int getXCor(){
	return xCor;
    }
    public int getYCor(){
	return yCor;
    }
    public int getColor(){
	return blockColor;
    }

    public void display(){
	//fill in later
	fill(blockColor);
    }
}