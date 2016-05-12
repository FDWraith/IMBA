class Block {
    boolean isSolid;
    int x, y;
    
    public Block(int l, int w, boolean isSolid) {
       rect(x, y, l, w);
       this.isSolid = isSolid;
    }
    public Block(int l, int w) {
       rect(x, y, l, w); 
    }
    public Block() {
       rect(x, y, 1, 1); 
    }
    
    void setSolid(boolean b) {
      isSolid = b;
    }
}