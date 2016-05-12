//Hello World!

class World {
   Block[][] board;
   
   //might want to replace numBlocksRow and numBlocksCol with width and height primitives
   void initializeWorld(int numBlocksRow, int numBlocksCol) {
     //can be moved to constructor
       board = new Block[numBlocksRow][numBlocksCol];
       for (int r = 0; r < board.length; r++) {
          for (int c = 0; c < board[r].length; c++) {
             board[r][c] = new Block(r, c); 
          }
       }
       randomizeBlocks();
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