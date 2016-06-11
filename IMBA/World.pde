public class World{  //<>// //<>// //<>// //<>// //<>// //<>// //<>//
   private Block[][] board;
   private ArrayList<Positionable> collidableBlocks;
   private ArrayList<Positionable> creatures;
   private ArrayList<EndBlock> endingPositions;
   private Player player;
   private String filePath;
   private float worldAdjust = 0;
   
   //  private int rowStart, rowEnd;
   
   //Constructor, empty means generating new world.
   public World(){
       this("./MapSaves/default.map");
   }
   
   public World(String filePath){
      initializeWorld(filePath);
      this.filePath = filePath;
   }
   
   public void handleUserInput(String in){
     player.handleUserInput(in); 
   }
   
   public void reload(){
     board = null;
     collidableBlocks = null;
     creatures = null;
     endingPositions = null;
     player = null;
     initializeWorld(filePath);
   }
   
   public void display() throws Throwable{//adjust starts at 0. As adjust increases, we move left
   /*
      float movement = adjust % 100;
      int blockChange = (int)(adjust / 100);
      */
      pushMatrix();
      if(player.getX() >= 500 && player.getX() <= (100 * board.length - 500)){
        translate(-1 * (player.getX() - 500), 0);
      }
      float xCor = 50.0;
      float yCor = 50.0;
      for(int r = 0; r < board.length; r++){
        for(int c = 0; c < board[r].length; c++){
          board[r][c].display(xCor, 1000 - yCor);
          yCor += 100;
        }
        yCor = 50.0;
        xCor += 100.0;
      }
      //println(collidableBlocks.size());
      //    player.collide(collidableBlocks);
      //player.collide(others);
      player.move(collidableBlocks, creatures);
      player.display();
      for(int i =0 ;i < creatures.size();i++){
        Positionable current = creatures.get(i);
        if(current instanceof Npc){
          ((Npc)(current)).randomizeMove(collidableBlocks, creatures);
        }else if(current instanceof Player){
          //((Player)(current)).move(collidableBlocks);          
        }
        current.display();  
      }
      popMatrix();
      
      for(int i = 0;i < endingPositions.size(); i++){
        float diffX = abs(player.getX() - endingPositions.get(i).getX());
        float diffY = abs(player.getY() - endingPositions.get(i).getY());
        println(diffX + "," + diffY);
        if(diffX < endingPositions.get(i).getSize() / 2 && diffY < endingPositions.get(i).getSize() / 2){
          clear();
          throw new Throwable("EndGame");
        }
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
       endingPositions = new ArrayList<EndBlock>();
       for(int r = 0;r < row;r++){
          Scanner temp = new Scanner(in.nextLine());
          for(int c = 0; c < col; c++){
            String data = temp.next();
             data = data.substring(1,data.length()-1); // get rid of array markings
             Block b = initializeBlock(data);
             board[r][c] = b;
             
             if(b instanceof SolidBlock){
               collidableBlocks.add((Positionable)(b));
             }
             
             if(b instanceof EndBlock){
               endingPositions.add((EndBlock)(b));  
             }
             
          }
          temp.close();
       }
       Scanner nextLine = new Scanner(in.nextLine());
       int numOfCreatures = nextLine.nextInt();
       nextLine.close();
       for(int i = 0; i < numOfCreatures; i++){
         String data = in.nextLine();
         data = data.substring(1,data.length()-1);
         String[]ary = data.split(",");
         Creature c = intializeCreature(ary[0],Float.parseFloat(ary[1]),Float.parseFloat(ary[2]));
         creatures = new ArrayList<Positionable>();
         creatures.add((Positionable)(c));
         if(c instanceof Player){
           player = ((Player)(c));  
         }
       }
       
       in.close();       
     }catch(FileNotFoundException e){
       
     }
       
   }
   
   private Block initializeBlock(String info){
     int ID = Integer.parseInt(info);
     switch(ID){
        case 0: return new AirBlock(100,ID);
        case 1: return new SolidBlock("dirt.jpg",100,ID);
        case 2: return new SolidBlock("stone.jpg",100,ID);
        case 3: return new SolidBlock("stone_brick.jpg",100,ID);
        case 4: return new SolidBlock("wood.jpg",100,ID);
        case 5: return new EndBlock(100,ID);
     }
     return null;
   }
   private Creature intializeCreature(String info, float xCor, float yCor){
     int ID = Integer.parseInt(info);
     switch(ID){
        case 0: return new Player(xCor,yCor);
        case 1: return new Npc(xCor,yCor);
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