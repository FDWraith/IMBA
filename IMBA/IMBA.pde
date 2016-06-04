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
    background(#FFFFFF);
    if(globalState.equals("initialize")){
      promptScreen();
      globalState = "loading";
    }else if(globalState.equals("loading")){
      if(action != null){
        clear();  
        if(action.equals("play")){
          globalState = "choosingWorld";
        }else if(action.equals("create")){
          globalState = "generating";
        }
      }else{
        promptScreen();
        if(checkMouse(500,250,300,100)){
          fill(#A3A3A3);
          promptButton(500,250,300,100);
          noFill();
        }else if(checkMouse(500,550,300,100)){
          fill(#A3A3A3);
          promptButton(500,550,300,100);
          noFill();
        }
      }
    }else if(globalState.equals("choosingWorld")){
        selectInput("Choose a map file", "fileSelected");
        globalState = "tempPhaseOut";
        action = null;
    }else if(globalState.equals("running")){
        ((World)(world)).display(adjustment);
        
    }else if(globalState.equals("generating")){
        selectInput("Choose a map file to edit, or create a new one", "fileChanged");
        globalState = "tempPhaseOut";
        action = null;
    }else if(globalState.equals("worldMaking")){
        if(action.equals("createNew")){
        
        }else if(action.equals("editOld")){
          
        }
    }
    //System.out.println(globalState);
}
  

  
  void fileSelected(File selection){
    if(selection == null){
      globalState = "initialize";
    }else if(!selection.exists()){
      println("file does not exist, rerouting to default");
      world = new World();
      globalState = "running";
    }else if(!(selection.getAbsolutePath().contains("MapSaves") && selection.getAbsolutePath().contains(".map") ) ){
      println("file not in proper format or not in proper location");
      globalState = "initialize";
    }else{
      try{
        //println(selection.getAbsolutePath());
        //println(selection.getCanonicalPath());
        world = new World(selection.getAbsolutePath());
        globalState = "running"; 
      }catch(Exception e){
        println("done goofed");
        e.printStackTrace();
      }
    }
  }
  
  void fileChanged(File selection){
    if(selection == null){
      world = new Generator();
      globalState = "worldMaking";
      action = "editOld";
    }else if(!selection.exists()){
      File f = new File(selection.getAbsolutePath());
      f.getParentFile().mkdirs();
      try{
        f.createNewFile();
        world = new Generator(selection.getAbsolutePath());
      }catch(IOException e){
        println("What is going on?");
      }
      globalState = "worldMaking";
      action = "createNew";
      //f.close();
      //println(action);
    }else{
      world = new Generator(selection.getAbsolutePath());
      globalState = "worldMaking";
      action = "editOld";
      //println(action);
    }
  }
  void promptButton(float xCor, float yCor, float len, float ht){
    rectMode(CENTER);
    rect(xCor, yCor, len, ht);
  }
  void promptScreen(){
    promptButton(500,250,300,100);
    promptButton(500,550,300,100);
  }
  
  void mouseClicked(){
    //System.out.println(globalState);
    if(globalState.equals("loading")){
      if(checkMouse(500,250,300,100)){
        action = "play";
      }else if(checkMouse(500,550,300,100)){
        action = "create"; 
      }
    }
  }
  
  void keyTyped(){
    if(world instanceof World){ //<>//
      ((World)(world)).handleUserInput(""+key);
      if(key == 'd'){
        adjustment += 5;  
      }else if(key == 'a'){
        adjustment -= 5;  
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
  