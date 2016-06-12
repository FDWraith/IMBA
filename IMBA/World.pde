public class World{  //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
   private Block[][] board;
   private ArrayList<Positionable> collidableBlocks;
   private ArrayList<Positionable> creatures;
   private ArrayList<EndBlock> endingPositions;
   private ArrayList<MovableBlock> movingBlocks;
   private Player player;
   private String filePath;
   private float worldAdjust = 0;
   private int score = 0;
   private boolean first = true;
   
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
     first = true;
     movingBlocks = null;
     player = null;
     score = 0;
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
      }else if(player.getX() > (100 * board.length - 500) ){
        translate(-1 * (100 * board.length - 1000), 0);
      }else{
        translate(0,0); 
      }
      if(first){
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
        first = false;
      }else{
        for(int r =0; r < board.length; r++){
          for(int c = 0; c < board[r].length; c++){
            board[r][c].display(board[r][c].getX(),1000 - board[r][c].getY());
          }
        }
      }
      //println(collidableBlocks.size());
      //    player.collide(collidableBlocks);
      //player.collide(others);
      player.move(collidableBlocks, creatures);
      player.display();
      
      if( round(player.getY()) / 100 != 0){
        if(board[round(player.getX())/100][round(player.getY())/100 -1] instanceof FallingBlock){
          println("triggered");
          ((FallingBlock)(board[round(player.getX())/100][round(player.getY())/100 -1])).triggerFall();
        }
      }
      
      if( board[(round(player.getX())) / 100][(round(player.getY())) / 100] instanceof CoinBlock){
        board[(round(player.getX()) / 100)][(round(player.getY())) / 100] = new AirBlock(100,0);
        score++;
      }
      for(int i =0 ;i < creatures.size();i++){
        Positionable current = creatures.get(i);
        if(current instanceof Npc){
          ((Npc)(current)).randomizeMove(collidableBlocks, creatures);
        }else if(current instanceof Player){
          //((Player)(current)).move(collidableBlocks);          
        }
        current.display();  
      }
      checkCreatureCollision(creatures);
      //println(movingBlocks.toString());
      for(int i =0; i < movingBlocks.size(); i++){
        MovableBlock current = movingBlocks.get(i);
        if(current instanceof FallingBlock){
          //println(current.getX()+","+current.getY());
          ((FallingBlock)(current)).move(collidableBlocks);  
        }else if(current instanceof SlidingBlock){
          ((SlidingBlock)(current)).move(collidableBlocks);
        }
      }
      
      
      
      popMatrix();
      
      
      //ScoreDisplay
      
      //textMode(RIGHT);
      textAlign(LEFT,TOP);
      textSize(20);
      fill(0);
      text("Score : "+score,0,0);
      textSize(12);
      //noFill();
      

      
      for(int i = 0;i < endingPositions.size(); i++){
        float diffX = abs(player.getX() - endingPositions.get(i).getX());
        float diffY = abs(player.getY() - endingPositions.get(i).getY());
        //println(diffX + "," + diffY);
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
       movingBlocks = new ArrayList<MovableBlock>();
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
             
             if(b instanceof MovableBlock){
               movingBlocks.add((MovableBlock)(b));  
             }
             
          }
          temp.close();
       }
       Scanner nextLine = new Scanner(in.nextLine());
       int numOfCreatures = nextLine.nextInt();
       //System.out.println("t"+numOfCreatures);
       nextLine.close();
       creatures = new ArrayList<Positionable>();
       for(int i = 0; i < numOfCreatures; i++){
         String data = in.nextLine();
         data = data.substring(1,data.length()-1);
         String[]ary = data.split(",");
         Creature c = intializeCreature(ary[0],Float.parseFloat(ary[1]),Float.parseFloat(ary[2]));         
         creatures.add((Positionable)(c));
         //System.out.println("\t\t"+creatures.size());
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
        case 2: return new FallingBlock("gravel.jpg",100,ID);
        case 3: return new SolidBlock("stone_brick.jpg",100,ID);
        case 4: return new SolidBlock("wood.jpg",100,ID);
        case 5: return new EndBlock(100,ID);
        case 6: return new CoinBlock(100,ID);
        case 7: return new SlidingBlock("platform.jpg",100,ID);
     }
     return null;
   }
   private Creature intializeCreature(String info, float xCor, float yCor){
     int ID = Integer.parseInt(info);
     switch(ID){
        case 0: return new Player(xCor,yCor);
        case 1: return new Npc(xCor,yCor);
     }
     System.out.println("returned null");
     return null;
   }
   
   private void updateScore(){
     score++;
     
   }
   
   private void checkCreatureCollision(ArrayList<Positionable> creatures) {
     System.out.println(creatures.size());
      for (int i = 0; i < creatures.size(); i++) {
        System.out.println("Creature "+i+" (x, y): ("+creatures.get(i).getX()+", "+creatures.get(i).getY()+")");
         for (int j = 0; j < creatures.size(); j++) {
            if (i != j) { //prevents creature from colliding with itself
              Creature creatureOne = (Creature)creatures.get(i);
              Creature creatureTwo = (Creature)creatures.get(j);
              float diffX = creatureOne.getX() - creatureTwo.getX();
              float diffY = creatureOne.getY() - creatureTwo.getY();
              System.out.println("Diff(x,y): ("+diffX+", "+diffY+")");
              while (Math.abs(diffX) < 40 && Math.abs(diffY) < 40) {
                fixCreatureCollision(creatureOne, creatureTwo);
              }
              creatureOne.setSpeedX(-creatureOne.getSpeedX());
              creatureOne.setSpeedY(-creatureOne.getSpeedY());
              creatureTwo.setSpeedX(-creatureTwo.getSpeedX());
              creatureTwo.setSpeedY(-creatureTwo.getSpeedY());
            }
         }
      }
   }
   
   //one tick of collision
   private void fixCreatureCollision(Creature creatureOne, Creature creatureTwo) {
     System.out.println("Fixing!");
      float diffX = creatureOne.getX() - creatureTwo.getX(); //if positive, creatureOne is to the right. If negative, creatureOne is to the left.
      float diffY = creatureOne.getY() - creatureTwo.getY();
      float speedXOne = creatureOne.getSpeedX();
      float speedYOne = creatureOne.getSpeedY();
      float speedXTwo = creatureTwo.getSpeedX();
      float speedYTwo = creatureTwo.getSpeedY();
      creatureOne.setX(-speedXOne/10);
      creatureOne.setY(-speedYOne/10);
      creatureTwo.setX(-speedXTwo/10);
      creatureTwo.setY(-speedYTwo/10);
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