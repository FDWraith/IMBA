import java.util.*;
import java.io.*;

public class Generator{
  private ArrayList<ArrayList<Block>> board;
  
  
  public Generator(String fileName){
    initializeFile("./MapSaves/"+fileName);     
  }
  private void initializeFile(String fileName){
    try{
      File f = new File(fileName);
      Scanner in = new Scanner(f);
      if(!in.hasNext()){//file is empty, aka new file 
        board = new ArrayList<ArrayList<Block>>(10);
        for(int i = 0; i < board.size(); i++){
          board.set(i, new ArrayList<Block>(10));  
        }
        fillNulls();
      }else{
        Scanner firstLine = new Scanner(in.nextLine());
        int r = firstLine.nextInt();
        int c = firstLine.nextInt();
        board = new ArrayList<ArrayList<Block>>(r);
        for(int i = 0; i < board.size(); i++){
          Scanner newLine = new Scanner(in.nextLine());
          board.set(i, new ArrayList<Block>(c));
          for(int j = 0; j < board.get(i).size();j++){
            board.get(i).set(j, initializeBlock(newLine.nextInt()));  
          }
        }
      }
    }catch(FileNotFoundException e){
      println("FILE NEVER FOUND");      
    }
  }
  
  private Block initializeBlock(int ID){
    switch(ID){
      case 0: return new AirBlock(80);
      case 1: return new SolidBlock("dirt.jpg",80);
    }
    return null;
  }
  
  private void fillNulls(){
    for(int i =0 ;i < board.size(); i++){
      for(int j =0;j <board.get(i).size();j++){
        if(board.get(i).get(j) == null){
          board.get(i).set(j,new AirBlock(50));  
        }
      }
    }
  }
  
  public void display(){
    
  }
  
    
}