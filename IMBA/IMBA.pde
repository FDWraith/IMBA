import java.util.*;
import java.util.concurrent.*;

private String globalState;
private String action;
private Object world;
   void setup() {
   size(1000, 1000);
   background(255, 255, 255);
   globalState = "initialize";
  }

  void draw(){
    //Button b = new Button(mouseX, mouseY, 50, 200, 0, 255, "Hello World");
    //b.draw();
    if(globalState.equals("initialize")){
      fill(#FFF333);
      promptScreen();
      globalState = "loading";
    }else if(globalState.equals("loading") && action != null){
      clear();
      if(action.equals("play")){
        globalState = "choosingWorld";
      }else if(action.equals("create")){
        world = new Generator();
        globalState = "generating";
      }
    }else if(globalState.equals("choosingWorld")){
        selectInput("Choose a map file", "fileSelected");
        globalState = "running";
    }
  }
  
  void fileSelected(File selection){
    if(selection == null){
      globalState = "initialize";
    }else if(!selection.exists()){
      println("file does not exist");
      globalState = "initialize";
      action = null;
    }else if(!(selection.getAbsolutePath().contains("MapSaves") && selection.getAbsolutePath().contains(".map") ) ){
      println("file not in proper format");
      globalState = "initialize";
      action = null;
    }
  }
  
  void promptScreen(){
    clear();
    background(255,255,255);
    rectMode(CENTER);
    rect(500,250,300,100);
  }
  
  void mouseClicked(){
    //System.out.println(globalState);
    if(checkMouse(500,250,300,100) && globalState.equals("loading")){
      fill(#333FFF);
      promptScreen();
      action = "play";
    }
  }
  
  public boolean checkMouse(double xCor, double yCor, double wid, double ht){
    //System.out.println("testing");
    if(mouseX < xCor + wid / 2 && mouseX > xCor - wid / 2){
      if(mouseY < yCor + ht / 2 && mouseY > yCor - ht / 2){
         return true; 
      }
    }
    return false;
  }