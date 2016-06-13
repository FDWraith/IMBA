public class World {  //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>// //<>//
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
  public World() {
    this("./MapSaves/default.map");
  }

  public World(String filePath) {
    initializeWorld(filePath);
    this.filePath = filePath;
  }

  public void handleUserInput(String in) {
    player.handleUserInput(in);
  }

  public void reload() {
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

  public void display() throws Throwable {//adjust starts at 0. As adjust increases, we move left
    /*
      float movement = adjust % 100;
     int blockChange = (int)(adjust / 100);
     */
    pushMatrix();
    if (player.getX() >= 500 && player.getX() <= (100 * board.length - 500)) {
      translate(-1 * (player.getX() - 500), 0);
    } else if (player.getX() > (100 * board.length - 500) ) {
      translate(-1 * (100 * board.length - 1000), 0);
    } else {
      translate(0, 0);
    }
    if (first) {
      float xCor = 50.0;
      float yCor = 50.0;
      for (int r = 0; r < board.length; r++) {
        for (int c = 0; c < board[r].length; c++) {
          board[r][c].display(xCor, 1000 - yCor);
          yCor += 100;
        }
        yCor = 50.0;
        xCor += 100.0;
      }
      first = false;
    } else {
      for (int r =0; r < board.length; r++) {
        for (int c = 0; c < board[r].length; c++) {
          board[r][c].display(board[r][c].getX(), 1000 - board[r][c].getY());
        }
      }
    }
    //println(collidableBlocks.size());
    //    player.collide(collidableBlocks);
    //player.collide(others);
    player.move(collidableBlocks, creatures);
    player.display();

    if ( round(player.getY()) / 100 != 0) {
      if (board[round(player.getX())/100][round(player.getY())/100 -1] instanceof FallingBlock) {
        println("triggered");
        ((FallingBlock)(board[round(player.getX())/100][round(player.getY())/100 -1])).triggerFall();
      }
    }

    if ( board[(round(player.getX())) / 100][(round(player.getY())) / 100] instanceof CoinBlock) {
      board[(round(player.getX()) / 100)][(round(player.getY())) / 100] = new AirBlock(100, 0);
      score++;
    }
    for (int i =0; i < creatures.size(); i++) {
      Positionable current = creatures.get(i);
      if (current instanceof Npc) {
        ((Npc)(current)).randomizeMove(collidableBlocks, creatures);
      } else if (current instanceof Player) {
        //((Player)(current)).move(collidableBlocks);
      }
      current.display();
    }
    checkCreatureCollision(creatures);
    //println(movingBlocks.toString());
    ArrayList<Positionable> temp = new ArrayList<Positionable>();
    temp.addAll(creatures);
    temp.addAll(collidableBlocks);
    for (int i =0; i < movingBlocks.size(); i++) {
      MovableBlock current = movingBlocks.get(i);
      if (current instanceof FallingBlock) {
        //println(current.getX()+","+current.getY());
        ((FallingBlock)(current)).move(temp);
      } else if (current instanceof SlidingBlock) {
        ((SlidingBlock)(current)).move(temp);
      }
    }
    //println("break?");

    popMatrix();


    //ScoreDisplay

    //textMode(RIGHT);
    textAlign(LEFT, TOP);
    textSize(20);
    fill(0);
    text("Score : "+score, 0, 0);
    textSize(12);
    //noFill();



    for (int i = 0; i < endingPositions.size(); i++) {
      float diffX = abs(player.getX() - endingPositions.get(i).getX());
      float diffY = abs(player.getY() - endingPositions.get(i).getY());
      //println(diffX + "," + diffY);
      if (diffX < endingPositions.get(i).getSize() / 2 && diffY < endingPositions.get(i).getSize() / 2) {
        clear();
        throw new Throwable("EndGame");
      }
    }

    if (player.getState().equals("DEATH")) {
      throw new Throwable("Lose");
    }
  }

  //might want to replace numBlocksRow and numBlocksCol with width and height primitives
  private void initializeWorld(String filePath) {
    //can be moved to constructor
    File d;
    try {
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
      for (int r = 0; r < row; r++) {
        Scanner temp = new Scanner(in.nextLine());
        for (int c = 0; c < col; c++) {
          String data = temp.next();
          data = data.substring(1, data.length()-1); // get rid of array markings
          Block b = initializeBlock(data);
          board[r][c] = b;

          if (b instanceof SolidBlock) {
            collidableBlocks.add((Positionable)(b));
          }

          if (b instanceof EndBlock) {
            endingPositions.add((EndBlock)(b));
          }

          if (b instanceof MovableBlock) {
            movingBlocks.add((MovableBlock)(b));
          }
        }
        temp.close();
      }
      Scanner nextLine = new Scanner(in.nextLine());
      int numOfCreatures = nextLine.nextInt();
      nextLine.close();
      creatures = new ArrayList<Positionable>();
      for (int i = 0; i < numOfCreatures; i++) {
        String data = in.nextLine();
        data = data.substring(1, data.length()-1);
        String[]ary = data.split(",");
        Creature c = intializeCreature(ary[0], Float.parseFloat(ary[1]), Float.parseFloat(ary[2]));         
        creatures.add((Positionable)(c));
        if (c instanceof Player) {
          player = ((Player)(c));
        }
      }

      in.close();
    }
    catch(FileNotFoundException e) {
    }
  }

  private Block initializeBlock(String info) {
    int ID = Integer.parseInt(info);
    switch(ID) {
    case 0: 
      return new AirBlock(100, ID);
    case 1: 
      return new SolidBlock("dirt.jpg", 100, ID);
    case 2: 
      return new FallingBlock("gravel.jpg", 100, ID);
    case 3: 
      return new SolidBlock("stone_brick.jpg", 100, ID);
    case 4: 
      return new SolidBlock("wood.jpg", 100, ID);
    case 5: 
      return new EndBlock(100, ID);
    case 6: 
      return new CoinBlock(100, ID);
    case 7: 
      return new SlidingBlock("platform.jpg", 100, ID);
    }
    return null;
  }
  private Creature intializeCreature(String info, float xCor, float yCor) {
    int ID = Integer.parseInt(info);
    switch(ID) {
    case 0: 
      return new Player(xCor, yCor);
    case 1: 
      return new Npc(xCor, yCor);
    }
    return null;
  }

  private void updateScore() {
    score++;
  }

  /*
  private void checkCreatureCollision(ArrayList<Positionable> creatures) {
   boolean wentBack = false;
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
   creatureOne.goBack(collidableBlocks);
   creatureTwo.goBack(collidableBlocks);
   diffX = creatureOne.getX() - creatureTwo.getX();
   diffY = creatureOne.getY() - creatureTwo.getY();
   wentBack = true;
   }
   if (wentBack) {
   creatureOne.setSpeedX(-creatureOne.getSpeedX());
   creatureOne.setSpeedY(-creatureOne.getSpeedY());
   creatureTwo.setSpeedX(-creatureTwo.getSpeedX());
   creatureTwo.setSpeedY(-creatureTwo.getSpeedY());
   wentBack = false;
   }
   }
   }
   }
   }
   
   //one tick of collision
   private void fixCreatureCollision(Creature creatureOne, Creature creatureTwo) {
   float diffX = creatureOne.getX() - creatureTwo.getX(); //if positive, creatureOne is to the right. If negative, creatureOne is to the left.
   float diffY = creatureOne.getY() - creatureTwo.getY();
   float speedXOne = creatureOne.getSpeedX();
   float speedYOne = creatureOne.getSpeedY();
   float speedXTwo = creatureTwo.getSpeedX();
   float speedYTwo = creatureTwo.getSpeedY();
   creatureOne.setX(creatureOne.getX() + -speedXOne/10 - (getSign(speedXOne) * .1));
   creatureOne.setY(creatureOne.getY() + -speedYOne/10 - (getSign(speedYOne) * .1));
   creatureTwo.setX(creatureTwo.getX() + -speedXTwo/10 - (getSign(speedXTwo) * .1));
   creatureTwo.setY(creatureTwo.getY() + -speedYTwo/10 - (getSign(speedYTwo) * .1));
   }
   */

  private void checkCreatureCollision(ArrayList<Positionable> creatures) {
    for (int i = 0; i < creatures.size(); i++) {
      for (int j = 0; j < creatures.size(); j++) {
        if (i != j) {
          Creature creatureOne = (Creature)creatures.get(i);
          Creature creatureTwo = (Creature)creatures.get(j);
          float creatureOneNextX = creatureOne.getX() + creatureOne.getSpeedX();
          float creatureOneNextY = creatureOne.getY() + creatureOne.getSpeedY();
          float creatureTwoNextX = creatureTwo.getX() + creatureTwo.getSpeedX();
          float creatureTwoNextY = creatureTwo.getY() + creatureTwo.getSpeedY();

          float nextDiffX = creatureOneNextX - creatureTwoNextX;
          float nextDiffY = creatureOneNextY - creatureTwoNextY;

          //System.out.println("Next diff(x,y): ("+nextDiffX+", "+nextDiffY+")");
          if (Math.abs(nextDiffX) < 40 && Math.abs(nextDiffY) < 40) { //if we need to slow down while approaching each other
            //System.out.println("Running if statement!");
            float newNextDiffX = (creatureOne.getX() + (creatureOne.getSpeedX() / 10)) - (creatureTwo.getX() + (creatureTwo.getSpeedX() / 3)); //the slowed down version of nextDiffX
            float newNextDiffY = (creatureOne.getY() + (creatureOne.getSpeedY() / 10)) - (creatureTwo.getY() + (creatureTwo.getSpeedY() / 3)); //the slowed down version of nextDiffY
            //System.out.println("New Next diff(x,y): ("+newNextDiffX+", "+newNextDiffY+")");
            while ((Math.abs(newNextDiffX) > 40 || Math.abs(newNextDiffY) > 40 /*&& Math.abs(newNextDiffX) > 40*/)) {
              creatureOne.setX(creatureOne.getX() + creatureOne.getSpeedX() / 50);
              creatureOne.setY(creatureOne.getY() + creatureOne.getSpeedY() / 50);
              creatureTwo.setX(creatureTwo.getX() + creatureTwo.getSpeedX() / 50);
              creatureTwo.setY(creatureTwo.getY() + creatureTwo.getSpeedY() / 50);

              newNextDiffX = creatureOne.getX() + creatureOne.getSpeedX() / 50 - (creatureTwo.getX() + creatureTwo.getSpeedX() / 50);
              newNextDiffY = creatureOne.getY() + creatureOne.getSpeedY() / 50 - (creatureTwo.getY() + creatureTwo.getSpeedY() / 50);
              //System.out.println("New Next diff(x,y): ("+newNextDiffX+", "+newNextDiffY+")");
            }
            //if they are reasonably close to each other -- now we need to set speeds properly
            float diffX = creatureOne.getX() - creatureTwo.getX();
            float diffY = creatureOne.getY() - creatureTwo.getY();
            //System.out.println(diffY);
            //there are now a few base cases...
            // 1. one is standing on top of the other (speedX is normal, while speedY is 0)
            // 2. one is standing next to another on the ground (speedX is reversed, while speedY is 0)
            // 3. one is standing next to another in the air (speedX is reversed, while speedY is normal)                 ***********Will be melged into case 2  -- no speedY changes
            // 4. one is standing on top of another in the air (speedX is normal, while speedY is the slower's/no change) ***********Will be melged into case 1  -- the above creature's speed is the below creature's speed
            
            // 5. BUGFIX: Somehow one is inside the other (reverse speedX)


            //Case 1 and 4:
            if (Math.abs(diffY) > 40 && Math.abs(diffY) < 42) {
              //System.out.print("1");
              if (diffY > 0) { //one is above, two is below
                //System.out.print("A");
                creatureOne.setSpeedY(creatureTwo.getSpeedY()); //sets to same speed
                //System.out.println(creatureOne.getSpeedY());
                if (Math.abs(creatureOne.getSpeedY()) <= 1.5) { //makes sure speed is not negligible
                  //System.out.print("a");
                  creatureOne.onFloor = true;
                }
                creatureOne.setY(creatureTwo.getY() + 41);  //fixes where it is
              } else if (diffY < 0) {
                //System.out.print("B");
                creatureTwo.setSpeedY(creatureOne.getSpeedY());
                if (Math.abs(creatureTwo.getSpeedY()) <= 1.5) {
                  //System.out.print("a");
                  creatureTwo.onFloor = true;
                }
                creatureTwo.setY(creatureOne.getY() + 41);
              }
              //System.out.print("\n");
            }
            //Case 2 and 3
            //System.out.println("Diff(x,y): ("+diffX+", "+diffY+")");
            if (Math.abs(diffX) > 40 && Math.abs(diffX) < 42) {
              //System.out.println("Reversing speed!");
              //System.out.println("Speed (1, 2): ("+(creatureOne.getSpeedX())+", "+creatureTwo.getSpeedX());
              creatureOne.setSpeedX(-creatureOne.getSpeedX());
              creatureTwo.setSpeedX(-creatureTwo.getSpeedX());
              //System.out.println("Speed (1, 2): ("+(creatureOne.getSpeedX())+", "+creatureTwo.getSpeedX());
            }
            
            if (Math.abs(diffX) < 40 && Math.abs(diffY) < 5) { //can't directly change x/y values due to possible issues with block collision
            //System.out.println("Reversing and Multiplying speed!");
            //System.out.println("Speed (1, 2): ("+(creatureOne.getSpeedX())+", "+creatureTwo.getSpeedX());
              creatureOne.setSpeedX(Math.min(-creatureOne.getSpeedX() * 1.3, creatureOne.max_speedx));
              creatureTwo.setSpeedX(Math.min(-creatureTwo.getSpeedX() * 1.3, creatureTwo.max_speedx));
              
              //System.out.println("Speed (1, 2): ("+(creatureOne.getSpeedX())+", "+creatureTwo.getSpeedX());
            }
          }
          if (Math.abs(creatureOne.getX() - creatureTwo.getX()) < 40 && (creatureOne.getY() - creatureTwo.getY()) > 40 && (creatureOne.getY() - creatureTwo.getY()) < 42) {
            creatureOne.onFloor = true;
          }
        }
      }
    }
  }

  private float getSign(float x) {
    if (Math.abs(x) == x) {
      return 1;
    } else {
      return -1;
    }
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