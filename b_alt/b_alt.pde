//  b_alt.pde
//  Jeffrey Paletta

import SimpleOpenNI.*;
import java.util.*;
 
SimpleOpenNI context;
 
int blob_array[];
int userCurID;
int cont_length = 1280*960;
String[] sampletext = { "This", "is a", "test", "and not", "actually", "my final", "copy", "lots and", "lots of", "strings", "i am very", "tired", "content", "fades off", "as you", "approach", "more sample", "sentences", "i dont", "know what", "else to type", "right now", "this is", "really hard", "to do", "tired" , "depth values", "come out at 10 deimal points", "why didnt", "i pick", "something", "easier", "i need", "coffe but", "hve no money"
}; // sample random text"
 
void setup(){
  frameRate(15); 
  size(1280, 960);
  context = new SimpleOpenNI(this);
  context.setMirror(true);
  context.enableDepth();
  context.enableUser();
 
  blob_array=new int[cont_length];
}
 
 
void draw() {
  background(-1);
     context.update();
  int[] depthValues = context.depthMap();
  int[] userMap =null;
  int userCount = context.getNumberOfUsers();
  if (userCount > 0) {
  userMap = context.userMap();
  }
 
 loadPixels();
  for (int y=0; y<context.depthHeight(); y+=15) {
  for (int x=0; x<context.depthWidth(); x+=40) {
      int index = x + y * context.depthWidth();
      if (userMap != null && userMap[index] > 0) {
 
       userCurID = userMap[index];
        blob_array[index] = 255;
         textSize(10);
         fill(0,random(40,160));
        text(sampletext[int(random(0,10))],x,y); // put your sample random text
          }
          else {
            blob_array[index]=0;
          }
        }
      }
   }