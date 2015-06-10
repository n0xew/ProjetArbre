int depth = 450;
float rotY = 0;
float rotX = 0;
float rotZ = 0;
float speed = 1.0;
int mode = 0; //0 = normal, 1 = SHIFT-MODE
int boxHeight = 10;
int boxWidth = 300;

PGraphics dataBackgroundSurface;
PGraphics topViewSurface;
PGraphics gameGraphics;
PGraphics scoresSurface;
PGraphics bartChartSurface;

int userPoints;
int bestScore;

Mover mover;
float gravityConstant = 1;
ArrayList<Cylinder> cylList = new ArrayList<Cylinder>();
Cylinder cylinder = new Cylinder();

PShape tree;

void setup(){
  size(700, 700, P3D);
 /* noStroke();
  tree = loadShape("data/3DModels/Obj/tree_no_tex.obj");
  tree.scale(6);
  gameGraphics = createGraphics(width,height,P3D);
  dataBackgroundSurface = createGraphics(width, height/5, P2D);
  topViewSurface = createGraphics(height/5 - 20, height/5 - 20, P2D);
  scoresSurface = createGraphics(height/8 - 20, height/5 - 20, P2D);
  bartChartSurface = createGraphics(width-(topViewSurface.width+scoresSurface.width+2*10)-20, height/5 - 20, P2D);
  mover = new Mover();
  cylinder.init();*/
  calculate2D3DAngles();
}

/*void draw(){
  if(bestScore<userPoints){
    bestScore=userPoints;
  }
  gameGraphics.beginDraw();
  gameGraphics.noStroke();
  gameGraphics.background(200);
  gameGraphics.directionalLight(50, 100, 125, 0, 1, 0);
  gameGraphics.ambientLight(102, 102, 102);
  if(mode==0)  {
    gameGraphics.camera(width/2, height/2-700, depth, 0, 0, 0, 0, 1, 0);
    
    gameGraphics.pushMatrix();
    gameGraphics.rotateX(rotX);
    gameGraphics.rotateY(rotY);
    gameGraphics.rotateZ(rotZ);
  
    mover.update();
    mover.checkEdges();
    mover.display(gameGraphics);
    
    gameGraphics.translate(0, boxHeight,0);
    gameGraphics.box(boxWidth, boxHeight, boxWidth);
    gameGraphics.popMatrix();
  }else{

    gameGraphics.camera(0, -depth, 0, 0, 0, 0, 0, 0, 1);
    gameGraphics.translate(0, boxHeight,0);
    gameGraphics.box(boxWidth, boxHeight, boxWidth);
    cylinder.display(gameGraphics);
  }
  for(Cylinder c : cylList){
    if(c.position.y < boxWidth/2 && c.position.y > -boxWidth/2 && c.position.x < boxWidth/2 && c.position.x > -boxWidth/2)
     c.display(gameGraphics); 
  }
  gameGraphics.endDraw();
  image(gameGraphics,0,0);
  
  drawDataVizualSurface();
}*/


