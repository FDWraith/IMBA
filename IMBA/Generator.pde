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
      }else{
        
      }
    }catch(FileNotFoundException e){
      println("FILE NEVER FOUND");      
    }
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