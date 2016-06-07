import java.util.*;
import java.io.*;

public class Generator{
  private ArrayList<ArrayList<Block>> board;
  private String filePath;
  private int adjust = 0;
  private int displayAdjust = 0;
  private ArrayList<Block> displayBoard;
  private int maxCount = 5;
  private Block followBlock;
  private boolean triggered;
  
  public Generator(){
    this("./MapSaves/default.map");
  }
  public Generator(String filePath){
    setFilePath(filePath);
    initializeFile(filePath);
  }
  private void setFilePath(String in){
    filePath = in;
  }
  public void moveLeft(){
    if(adjust > 0){
      adjust--;  
    }
  }
  public void moveRight(){
    if(adjust < board.size() - 10){
      adjust++;
    }
    //println(adjust+","+(board.get(0).size()-10));
    //println(board.toString());
  }
  
  public void flashTriggered(){
    triggered = true;  
  }
  private void initializeFile(String filePath){
    try{
      File f = new File(filePath);
      Scanner in = new Scanner(f);
      if(!in.hasNext()){//file is empty, aka new file 
        board = new ArrayList<ArrayList<Block>>(10);
        for(int i = 0; i < 10; i++){
          board.add(new ArrayList<Block>(10));  
        }
        fillNulls();
        save();
      }else{
        Scanner firstLine = new Scanner(in.nextLine());
        int r = firstLine.nextInt();
        int c = firstLine.nextInt();
        firstLine.close();
        board = new ArrayList<ArrayList<Block>>(r);
        for(int i = 0; i < r; i++){
          Scanner newLine = new Scanner(in.nextLine());
          board.add(new ArrayList<Block>(c));
          for(int j = 0; j < c;j++){
            String nxt = newLine.next();
            nxt = nxt.substring(1,nxt.length()-1);
            board.get(i).add(initializeBlock(Integer.parseInt(nxt)));  
          }
          newLine.close();
        }
      }
      in.close();
    }catch(FileNotFoundException e){
      println("FILE NEVER FOUND");      
    }
    
    displayBoard = new ArrayList<Block>();
    for(int i = 0; i < maxCount;i++){
      displayBoard.add(initializeDisplayBlock(i));  
    }
  }
  
  private void moveDisplayLeft(){
    if(displayAdjust > 0){
       displayAdjust--; 
    }
  }
  private void moveDisplayRight(){
    if(displayAdjust < displayBoard.size() - 4){
      displayAdjust++;  
    }
  }
  
  private void save(){
    try{
       File f = new File(filePath);//this is causing null for some reason....
       BufferedWriter out = new BufferedWriter(new FileWriter(f));
       String end = "";
       end += board.size() + " " + board.get(0).size() + "\n";       
       //Block of code for writing all the board information
       for(int i = 0; i < board.size(); i++) {
         String line = "";
         for(int j = 0; j < board.get(i).size(); j++) {
           line += "{"+board.get(i).get(j).getID()+"} ";
         }
         line = line.substring(0,line.length()-1);
         end += line += "\n";      
       }
       //Block of code for Creatures
       /*{Missing until later}*/
       
       //temp lines:
       end += "1\n{0,50,140}";//The ball spawns in top left corner...
       
       out.write(end);
       out.close();       
    }catch(IOException e){
      println("Things were not as planned");
    }catch(Exception e){
      println(e.getCause()); 
    }
       
  }
  
  private Block initializeBlock(int ID){
    switch(ID){
      case 0: return new AirBlock(80,ID);
      case 1: return new SolidBlock("dirt.jpg",80,ID);
      case 2: return new SolidBlock("stone.jpg",80,ID);
      case 3: return new SolidBlock("stone_brick.jpg",80,ID);
      case 4: return new SolidBlock("wood.jpg",80,ID);
    }
    return null;
  }
  private Block initializeDisplayBlock(int ID){
    switch(ID){
      case 0: return new AirBlock(100,ID);
      case 1: return new SolidBlock("dirt.jpg",100,ID);
      case 2: return new SolidBlock("stone.jpg",100,ID);
      case 3: return new SolidBlock("stone_brick.jpg",100,ID);
      case 4: return new SolidBlock("wood.jpg",100,ID);
    }
    return null;
  }
  
  private void fillNulls(){//beginning of the board.
    for(int i =0 ;i < board.size(); i++){
      for(int j =0;j < 10;j++){
        board.get(i).add(new AirBlock(80,0));  
      }
    }
  }
  
  public void display(){
    //pushMatrix();
    //translate(-1 * adjustX, 0);
    float xCor = 140.0;
    float yCor = 40.0;
    for(int r = adjust; r < adjust + 10; r++){
      for(int c = 0; c < 10; c++){
        board.get(r).get(c).display(xCor, 800 - yCor);
        yCor += 80;
      }
      yCor = 40.0;
      xCor += 80.0;
    }
    
    PShape leftTriangle = createShape(PShape.PATH);
    leftTriangle.beginShape();
    leftTriangle.vertex(40,400);
    leftTriangle.vertex(60,450);
    leftTriangle.vertex(60,350);
    leftTriangle.endShape();
    
    PShape rightTriangle = createShape(PShape.PATH);
    rightTriangle.beginShape();
    rightTriangle.vertex(960,400);
    rightTriangle.vertex(940,450);
    rightTriangle.vertex(940,350);
    rightTriangle.endShape();
    
    PShape addLayerTriangle = createShape(PShape.PATH);
    addLayerTriangle.beginShape();
    addLayerTriangle.vertex(990,400);
    addLayerTriangle.vertex(970,450);
    addLayerTriangle.vertex(970,350);
    addLayerTriangle.endShape();
    
    //Side Scrolling
    if(triggered){
      if(leftTriangle.contains(mouseX,mouseY)){
        //println("happened");
        moveLeft();
        triggered = false;
      }else if(rightTriangle.contains(mouseX,mouseY)){
        //println("happening");
        moveRight();
        triggered = false;
      }else if(addLayerTriangle.contains(mouseX,mouseY)){
        board.add(new ArrayList<Block>(10));
        for(int i = 0; i < 10; i++){
          board.get(board.size()-1).add(initializeBlock(0));
        }
        moveRight();
        triggered = false;
      }
      
    }
    
    triangle(40,400,60,450,60,350);
    triangle(960,400,940,450,940,350);
    fill(#862d2d);
    triangle(43,400,58,440,58,360);
    fill(#802b2b);
    triangle(957,400,942,440,942,360);
    triangle(990,400,970,450,970,350);
    
    //Bottom GUI
    /*
    fill(0);
    rect(500,900,width-100,150);
    noFill();
    */
    xCor = 200.0;
    yCor = 100;
    
    for(int i = displayAdjust; i< displayAdjust + 4; i++){
      fill(255);
      rect(xCor, 1000 - yCor, 105, 105);
      noFill();
      displayBoard.get(i).display(xCor, 1000 - yCor);
      xCor += 200;
    }
    
    //BottomGUI's arrow keys on side
    
    PShape bottomLeftTriangle = createShape(PShape.PATH);
    bottomLeftTriangle.beginShape();
    bottomLeftTriangle.vertex(40,900);
    bottomLeftTriangle.vertex(80,850);
    bottomLeftTriangle.vertex(80,950);
    bottomLeftTriangle.endShape();
    
    PShape bottomRightTriangle = createShape(PShape.PATH);
    bottomRightTriangle.beginShape();
    bottomRightTriangle.vertex(960,900);
    bottomRightTriangle.vertex(920,850);
    bottomRightTriangle.vertex(920,950);
    bottomRightTriangle.endShape();
    
    fill(#862d2d);
    triangle(40,900,80,850,80,950);
    fill(#802b2b);
    triangle(960,900,920,850,920,950);
    
    if(triggered){
      if(bottomLeftTriangle.contains(mouseX,mouseY)){
        moveDisplayLeft();
        println("left");
      }else if(bottomRightTriangle.contains(mouseX,mouseY)){
        moveDisplayRight();
        println("right");
      }
      triggered = false;
    }
    
   
    //Handle Picking up a block
    if(followBlock != null){
      followBlock.display(mouseX, mouseY);
    }
    
    
  }
 
  public void chooseBlock(){
    if(followBlock != null){
      return;//terminate if there is already a block following mouse
    }else{
      for(int i = 0; i < displayBoard.size();i++){
         Block current = displayBoard.get(i);
         float diffX = abs(mouseX - current.getX());
         float diffY = abs(mouseY - (1000 - current.getY()));
         //println(diffX + "," + diffY);
         if(diffX < 50 && diffY < 50){
           followBlock = initializeBlock(current.getID());
           //println("picked up" + followBlock.getID());
         }
      }
    }
  }
  
  public void dropBlock(){
    if(followBlock == null){
      return;  
    }else{
      for(int r = 0;r < board.size();r++){
        for(int c = 0; c < board.get(r).size(); c++){
          Block current = board.get(r).get(c);
          float diffX = abs(mouseX - current.getX());
          float diffY = abs(mouseY - (1000 - current.getY()));
          if(diffX < 40 && diffY < 40){
            board.get(r).set(c, followBlock);
            save();
            followBlock = null;
            return;
          }
        }
      }
    }
  }
 
  public boolean hasBlock(){
    return followBlock != null;  
  }
    
}