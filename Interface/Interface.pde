
ArrayList<Root> roots;
ArrayList<Button> buttons;
int score;
int lives;
float Stime=0;
boolean lose;
float ingamet=0;
PImage bg, ts;
PFont font;
int sessionScore;
int highScore;
//mouse particles
int numShapes = 7;
int shape = 0;   
int shapeSize = 13;
float[] xCor = new float[numShapes];  
float[] yCor = new float[numShapes];  
float[] shapeR = new float[numShapes]; 
float[] shapeG = new float[numShapes];
float[] shapeB = new float[numShapes];
boolean pause;
void setup() {
  font = loadFont("GB.vlw");
  textFont(font);
  ts = loadImage("titleScreen.jpg");
  bg = loadImage("background.png");
  ts.resize(1000,800);
  bg.resize(1000,800); //change
  frameRate(30);
  background(ts);
  size(1000, 800);
  lives=3;
  roots = new ArrayList<Root>();
  buttons= new ArrayList<Button>();
  buttons.add( new Button("Play",width/2-100,height/2-50,200,100));
  lose=true;
  pause=false;
}
void draw() {
  if(lives <= 0) {
    background(ts);
    lose = true;
    roots.clear();
    fill(213,44,32);
    textSize(20);
    if(sessionScore > highScore) highScore = sessionScore;
    text("Last Round Score: " + sessionScore, width-180, 50);
    text("Highscore: " + highScore, width-180, 100);
    score=0;
  }

if (lose){
    for (Button b: buttons){
      b.Draw();
      if (b.clicked==true){
      lose=false;
      lives = 3;
      b.clicked = false;
      Stime=millis();      }     
    }
  }
  
  else {
    if (pause){
    background(bg);
     text("Lives: "+lives+"\nTime: "+(int)(Math.round(ingamet)/1000), 60, 50);
    text("Score: " + score, width-180, 50);
    textSize(100);
    text("Paused",width/2,50);
  }
   else{ 
  ingamet=millis()-Stime;
  background(bg);
   //mouse particles
  stroke(255);
  line(pmouseX,pmouseY,mouseX,mouseY);
  xCor[shape] = mouseX;
  yCor[shape] = mouseY;
  shapeR[shape] = random(255);
  shapeG[shape] = random(255);
  shapeB[shape] = random(255);
  for (int i=0; i<numShapes; i++) {
    fill(shapeR[i],shapeG[i],shapeB[i]);
    ellipse(xCor[i], yCor[i], shapeSize, shapeSize);
  }
  shape++;
  if(shape >= numShapes) shape = 0; 
  fill(255);
  //rect(20, 5, 200, 100, 7);
  //rect(width-220, 5, 200, 100, 7);
  fill(213,44,32);
  textSize(20);
  text("Lives: "+lives+"\nTime: "+(int)(Math.round(ingamet)/1000), 60, 50);
  text("Score: " + score, width-180, 50);
  sessionScore = score;
  for (Root r : new ArrayList<Root>(roots)) {
    r.move();
    r.display();
    r.click();//enables slashing
    //if goes off the bottom, remove it
    if(r.y>=height+r.radius){
      if (r.bomb==false&&r.deadroot==false)
    lives --;
    }
    if (r.y>=height+r.radius||r.remove==true) {    
      float angle= atan2(mouseY-r.y,mouseX-r.x);
      roots.remove(r);
      if (r.remove==true){
        if (r.bomb==true){
          score-=5;
          lives--;
        } 
        else{
        score++;
        if (r.dy>0)
        roots.add(new Deadroot(r.radius,r.x,r.y,r.dx,r.dy,color(0),angle));
        
        else{
        roots.add(new Deadroot(r.radius,r.x,r.y,r.dx,-r.dy,color(0),angle));
        }
       
        }
      }
    } 
  }
  if ((ingamet%5000>50&&ingamet%5000<100)||roots.size()==0) {
    double multi=1;
    if (ingamet>15000){
       multi=(double)ingamet/10000;
    }
      for (int i=0; i<(int)(random(10)*multi); i++) {
      int x = (int)(Math.random() * ((12 -1) + 1)) + 1;
      if (x<=3) roots.add(new Radish());
      if (x>=7) roots.add(new Onion());
      if (x>=10) roots.add(new Bomb());
      else if (x >3 && x<7)  roots.add(new Potato());
    }
  }
  }

  fill(0);  
  textSize(20);
  text("FPS: "+frameRate+"\nRoots: "+roots.size(), width/2, 20); //hide laterrrrrrrrbac
  }
}

void mousePressed() {
  if (mouseButton == LEFT) {
    for (Root r : roots) {
      r.click();
    }
    for (Button b : buttons) {
      b.click();
    }
  }
}

void keyPressed(){
  if (keyPressed){
    if (key==32)
      pause=!pause;
  }
}
