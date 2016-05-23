import java.util.*;
import java.util.concurrent.*;

private String globalState;
private String action;
private Object world;
private static float adjustment;


   void setup() {
   size(1000, 1000);
   background(255, 255, 255);
   globalState = "initialize";
   adjustment = 0.0;
  }

  void draw(){
    //Button b = new Button(mouseX, mouseY, 50, 200, 0, 255, "Hello World");
    //b.draw();
    if(globalState.equals("initialize")){
      fill(#FFF333);
      promptScreen();
      globalState = "loading";
    }else if(globalState.equals("loading")){
      if(action != null){
        clear();  
        if(action.equals("play")){
          globalState = "choosingWorld";
        }else if(action.equals("create")){
          world = new Generator();
          globalState = "generating";
        }
      }
    }else if(globalState.equals("choosingWorld")){
        selectInput("Choose a map file", "fileSelected");
        globalState = "tempPhaseOut";
    }else if(globalState.equals("running")){
        ((World)(world)).display(adjustment);
        
    }else if(globalState.equals("generating")){
        //world.display(); 
    }
    //System.out.println(globalState);
  }
  
  void fileSelected(File selection){
    if(selection == null){
      globalState = "initialize";
      action = null;
    }else if(!selection.exists()){
      println("file does not exist");
      globalState = "initialize";
      action = null;
    }else if(!(selection.getAbsolutePath().contains("MapSaves") && selection.getAbsolutePath().contains(".map") ) ){
      println("file not in proper format or not in proper location");
      globalState = "initialize";
      action = null;
    }else{
      try{
        println(selection.getAbsolutePath());
        println(selection.getCanonicalPath());
        world = new World(selection.getAbsolutePath());
        globalState = "running"; 
      }catch(Exception e){
        println("done goofed");
        e.printStackTrace();
      }
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
    if(globalState.equals("loading")){
      if(checkMouse(500,250,300,100)){
        fill(#333FFF);  
        promptScreen();
        action = "play";
      }
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