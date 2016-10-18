//  e.pde
//  Jeffrey Paletta

import SimpleOpenNI.*;
SimpleOpenNI kinect;

ArrayList<Particle> particles;
PImage[] ads = new PImage[117];

int closestValue;
int closestX;
int closestY;
int random;

void setup(){
 size(640,360);
  kinect = new SimpleOpenNI(this);
   kinect.enableDepth(); 
     particles = new ArrayList<Particle>();
  
  for (int i = 0; i < ads.length; i++) {
  ads[i] = loadImage("image" + i + ".jpg");
  
}
}

void draw(){
   random = int(random(116));

 closestValue = 4000;
  kinect.update();
   int[] depthValues = kinect.depthMap();
    for(int y = 0;y<360; y++){
     for(int x = 0;x<640; x++){
      int i = x + y*640;
       int currentDepthValue = depthValues[i];
      
        if(currentDepthValue>0 && currentDepthValue < closestValue){
         closestValue = currentDepthValue;
         closestX = x;
         closestY = y;
        } 
     }
    } 
    image(kinect.depthImage(),0,0);
    particles.add(new Particle(new PVector(closestX, closestY)));
    
      for(int i=0; i<particles.size(); i++){
       Particle p = particles.get(i);
        p.run();
         if(p.isDead()){
          particles.remove(i);
         } 
      }
  //image(kinect.depthImage(),0,0);
   // fill(155,150,200);
   // ellipse(closestX, closestY,25,25);
  
}