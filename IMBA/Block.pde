class Block {
    boolean isSolid;
    int x, y;
    
    public Block(int x, int y, int l, int w, boolean isSolid) {
       rect(x, y, l, w);
       this.isSolid = isSolid;
    }
    public Block(int x, int y) {
      stroke(0, 0, 255);
       rect(x, y, 10, 10); 
    }
    public Block() {
       rect(0, 0, 1, 1); 
    }
    
    void setSolid(boolean b) {
      isSolid = b;
    }
}