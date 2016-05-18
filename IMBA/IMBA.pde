   void setup() {
   size(1000, 1000);
   background(255, 255, 255);
  }

  void draw(){
    clear();
    background(255, 255, 255);
    Button b = new Button(mouseX, mouseY, 50, 200, 0, 255, "Hello World");
    b.display();
  }