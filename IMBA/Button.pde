//BUTTON NO WORK. MUST MANUALLY DO BUTTONS INSTEAD

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
  
  public void draw(){
    rectMode(CENTER);
    fill(bckColor);
    rect(xCor,yCor,wide, len);
    //textMode();
    fill(stringColor);
    text(txt,xCor,yCor);
    mouseClicked();
    noFill();
    
  }
  
  void mouseClicked(){
    if(mousePressed == true){
      bckColor = 255; 
      System.out.println("triggered");
    }
  }
  
}