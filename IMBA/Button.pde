public class Button{
  float xCor,yCor,len,wide;
  String txt;
  int bckColor, stringColor;
  public Button(float xCor, float yCor, float len, float wide, int bckColor, int stringColor, String txt){
    this.xCor = xCor;
    this.yCor = yCor;
    this.len = len;
    this.wide = wide;
    this.txt = txt;
    this.bckColor = bckColor;
    this.stringColor = stringColor;
  }
  
  public void display(){
    rectMode(CENTER);
    fill(bckColor);
    rect(xCor,yCor,wide, len);
    //textMode();
    fill(stringColor);
    text(txt,xCor,yCor);
    
    if(mousePressed){
      bckColor = 255;//For some reason, this line is not being activated...
      //System.out.println("triggered");
    }
    
  }
  
}