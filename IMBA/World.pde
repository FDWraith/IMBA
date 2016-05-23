public class World{ //<>//
   private Block[][] board;
   private ArrayList<Positionable> collidableBlocks;
   //  private int rowStart, rowEnd;
   
   //Constructor, empty means generating new world.
   public World(){
       this("./MapSaves/default.map");
   }
   
   public World(String filePath){
      initializeWorld(filePath);
   }
   
   public void display(float adjust){//adjust starts at 0. As adjust increases, we move left
      float movement = adjust % 100;
      int blockChange = (int)(adjust / 100);
      float xCor = movement + 50.0;
      float yCor = 50.0;
      for(int r = 0 + blockChange; r < 10 + blockChange && r < board.length; r++){
        for(int c = 0; c < board[r].length; c++){
          board[r][c].display(xCor, 1000 - yCor);
          yCor += 100;
        }
        yCor = 50.0;
        xCor += 100.0;
      }
      
      
      
   }
   
   //might want to replace numBlocksRow and numBlocksCol with width and height primitives
   private void initializeWorld(String filePath) {
     //can be moved to constructor
     File d;
     try{
       d = new File(filePath);
       Scanner in = new Scanner(d);
       Scanner firstLine = new Scanner(in.nextLine());
       int row = firstLine.nextInt();
       int col = firstLine.nextInt();
       firstLine.close();
       board = new Block[row][col];
       collidableBlocks = new ArrayList<Positionable>();
       for(int r = 0;r < row;r++){
          Scanner temp = new Scanner(in.nextLine());
          for(int c = 0; c < col; c++){
            String data = temp.next();
             data = data.substring(1,data.length()-1); // get rid of array markings
             Block b = initializeBlock(data);
             board[r][c] = b;
             /*
             if(b instanceof SolidBlock){
               collidableBlocks.add((Positionable)(b));
             }
             */
          }
          temp.close();
       }       
       in.close();       
     }catch(FileNotFoundException e){
       
     }
       
   }
   
   private Block initializeBlock(String info){
     int ID = Integer.parseInt(info);
     switch(ID){
        case 0: return new AirBlock();
        case 1: return new Block("dirt.jpg");
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