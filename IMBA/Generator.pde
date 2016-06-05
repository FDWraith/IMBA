import java.util.*;
import java.io.*;

public class Generator{
  private ArrayList<ArrayList<Block>> board;
  private String filePath;
  private int adjust = 0;
  private ArrayList<Block> displayBoard;
  private int maxCount = 1;
  private Block followBlock;
  private boolean pressed = false;
  
  
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
    if(adjust < board.get(0).size() - 10){
      adjust++;
    }
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
        board = new ArrayList<ArrayList<Block>>(r);
        for(int i = 0; i < r; i++){
          Scanner newLine = new Scanner(in.nextLine());
          board.add(new ArrayList<Block>(c));
          for(int j = 0; j < c;j++){
            String nxt = newLine.next();
            nxt = nxt.substring(1,nxt.length()-1);
            board.get(i).add(initializeBlock(Integer.parseInt(nxt)));  
          }
        }
      }
    }catch(FileNotFoundException e){
      println("FILE NEVER FOUND");      
    }
    
    displayBoard = new ArrayList<Block>();
    displayBoard.add(new AirBlock(100, 0));
    displayBoard.add(new SolidBlock("dirt.jpg",100,1));    
    displayBoard.add(new AirBlock(100,0));
    displayBoard.add(new AirBlock(100,0));
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
       end += "1\n{0,50,950}";//The ball spawns in top left corner...
       
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
    }
    return null;
  }
  
  private void fillNulls(){//beginning of the board.
    for(int i =0 ;i < 10; i++){
      for(int j =0;j < 10;j++){
        board.get(i).add(new AirBlock(50,0));  
      }
    }
  }
  
  public void display(){
    //pushMatrix();
    //translate(-1 * adjustX, 0);
    float xCor = 140.0;
    float yCor = 40.0;
    for(int r = 0; r < board.size() && xCor < 900; r++){
      for(int c = adjust; c < 10 + adjust; c++){
        board.get(r).get(c).display(xCor, 800 - yCor);
        yCor += 80;
      }
      yCor = 40.0;
      xCor += 80.0;
    }
    
    //Bottom GUI
    
    fill(0);
    rect(500,900,width-100,150);
    noFill();
    
    xCor = 200.0;
    yCor = 100;
    for(int i = 0; i< displayBoard.size(); i++){
      fill(255);
      rect(xCor, 1000 - yCor, 105, 105);
      noFill();
      displayBoard.get(i).display(xCor, 1000 - yCor);
      xCor += 200;
    }
    
    //Handle Picking up a block
    if(followBlock != null){
      followBlock.display(mouseX, mouseY);
    }else{
        
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