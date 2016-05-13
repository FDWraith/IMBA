public class Block implements Displayable{
    private int xCor, yCor;
    private int color;
    
    public Block(int x, int y, int color) {
       xCor = x;
       yCor = y;
       setColor(color);
    }
    public Block(int x, int y) {
	xCor = x;
	yCor = y;
	color = 0;
    }
    public Block() {
       rect(0, 0, 1, 1); 
    }    
    public void setColor(int c){
	color = c;
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
	return color;
    }

    public void display(){
	//fill in later
    }
}
