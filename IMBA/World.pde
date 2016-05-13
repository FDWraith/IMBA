//Hello World!
import java.util.*;

public class World{
   Block[][] board;
   
   //might want to replace numBlocksRow and numBlocksCol with width and height primitives
   void initializeWorld(String filename) {
     //can be moved to constructor
       Scanner in = new Scanner(new File('./MapSaves/'+filename) );
       row = in.nextInt();
       col = in.nextInt();
       board = new Block[row][col];
       for(int r = 0;r < row;r++){
          Scanner temp = new Scanner(in.nextLine());
          for(int c = 0; c < col; c++){
             String data = in.next();
             data = data.substring(1,data.length()-1) // get rid of array markings
             String[] ary = data.split(',');
             board[r][c] = new Block(ary[0],ary[1],ary[2]);
          }
       }
   }
   
   //very crude randomizer -- randomly sets blocks to solid or gas
   // 2/3 chance of being gaseous
   void randomizeBlocks() {
     for (int r = 0; r < board.length; r++) {
       for (int c = 0; c < board[r].length; c++) {
         if ((Math.random() * 3) < 1) {
           board[r][c].setSolid(true);
         }
         else {
            board[r][c].setSolid(false); 
         }
       }
     }
   }
}