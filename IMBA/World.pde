//Hello World!
import java.util.*;

public class World{
   private Block[][] board;
   private int colStart, colEnd;
   
   //Constructor, empty means generating new world.
   public World(){
       Generator worldGen = new Generator();
   }
   
   public World(String fileName){
      initializeWorld(fileName);
      colStart = 0;
      colEnd = 5;
   }
   
   void display(){
   }
   
   //might want to replace numBlocksRow and numBlocksCol with width and height primitives
   private void initializeWorld(String fileName) {
     //can be moved to constructor
     File d;
     try{
       d = new File("./MapSaves/"+fileName);
       Scanner in = new Scanner(d);
       int row = in.nextInt();
       int col = in.nextInt();
       board = new Block[row][col];
       for(int r = 0;r < row;r++){
          Scanner temp = new Scanner(in.nextLine());
          for(int c = 0; c < col; c++){
             String data = in.next();
             data = data.substring(1,data.length()-1); // get rid of array markings
             String[] ary = data.split(",");
             board[r][c] = initializeBlock(ary);
          }
       }
       in.close();
     }catch(FileNotFoundException e){
       
     }
       
   }
   
   private Block initializeBlock(String[]ary){
     int ID = Integer.parseInt(ary[ary.length-1]);
     switch(ID){
        case 0: return new AirBlock();
        case 1: return new Block("ground.jpg");
     }
     return null;
   }
   
   /*
   //to be changed (may not include in working edition.
   void randomizeBlocks() {
     for (int r = 0; r < board.length; r++) {
       for (int c = 0; c < board[r].length; c++) {
         if ((Math.random() * 3) < 1) {
         }
         else {
            board[r][c].setSolid(false); 
         }
       }
     }
   }  
   */
}