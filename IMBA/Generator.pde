import java.util.*;
import java.io.*;

public class Generator{
  private ArrayList<Block>[] board;//this will be used as a sounding platform.
  private String fileName;
  
  public Generator(){
    //doNothing Generator.
  }  
  
  private String promptFile(){
          
  }
  
  private void  initialize(){
     fileName = promptFile();
     if(fileName.length() > 0){
       try( PrintWriter out = new PrintWriter( "./MapSaves/" + filename + ".map") ){
           ArrayList<Integer> form = promptOptions();
           if(form.size() < 1){
              System.out.println("Please fill out all the forms!"); 
           }else{
              board = new ArrayList<Block>[form.get(0)];//first form data will be the height of the board.
           }
           out.close();//save file for now.
       }catch(FileNotFoundException e){
       }
     }else{               
       System.out.println("Please enter a valid file name"); 
     }
  }//now, the board has been initialized and we are ready to continue
  
  
    
}