//  text_rain_2.pde
//  Jeffrey Paletta


import processing.video.*;

// Global variables for handling video data and the input selection screen
String[] cameras;
Capture cam;
Movie mov;
PImage inputImage;
boolean inputMethodSelected = false;
PFont f;
long start_time = System.currentTimeMillis();
ArrayList<Character> poemChar = new ArrayList<Character>();
ArrayList<Character> displayedChar = new ArrayList<Character>();
ArrayList<Float> xPos = new ArrayList<Float>();
ArrayList<Float> yPos = new ArrayList<Float>();
int i = 0, m, j = 0, pos_i, pos_z, pos_j = width -1, pixels_i;
float x, y = 0, thresh_red = 150.0, thresh_green = 150.0, thresh_blue = 150.0;
color left, right, threshHoldColor = color(thresh_red, thresh_green, thresh_blue);
int filt = GRAY, pixelDropPerSecond = 30;
float filt_thresh = 0.3;

void setup() {
  size(1280, 720);  
  inputImage = createImage(width, height, RGB);
  f = createFont("Courier", 20, true);
  textFont(f, 20);
  smooth();
  String[] poemString = loadStrings("blank_space.txt");
  StringBuilder sb = new StringBuilder();
  for (String line:poemString) {
    sb.append(line);
  }
  for (char c : sb.toString().toCharArray()){
    poemChar.add(c);
  }
}


void draw() {
  // When the program first starts, draw a menu of different options for which camera to use for input
  // The input method is selected by pressing a key 0-9 on the keyboard
  if (!inputMethodSelected) {
    cameras = Capture.list();
    int y=40;
    text("O: Offline mode, test with TextRainInput.mov movie file instead of live camera feed.", 20, y);
    y += 40; 
    for (int i = 0; i < min(9,cameras.length); i++) {
      text(i+1 + ": " + cameras[i], 20, y);
      y += 40;
    }
    return;
  }

  // This part of the draw loop gets called after the input selection screen, during normal execution of the program.
  
  // STEP 1.  Load an image, either from a movie file or from a live camera feed. Store the result in the inputImage variable
  
  if ((cam != null) && (cam.available())) {
    cam.read();
    inputImage.copy(cam, 0,0,cam.width,cam.height, 0,0,inputImage.width,inputImage.height);
  }
  else if ((mov != null) && (mov.available())) {
    mov.read();
    inputImage.copy(mov, 0,0,mov.width,mov.height, 0,0,inputImage.width,inputImage.height);
  }
 
  set(0,0,inputImage);
  if (filt == GRAY) {
    filter(filt);
  } else {
    filter(filt, filt_thresh); 
  }
  
  for(pos_z = 0; pos_z < height; pos_z++){
    for(pos_i = 0; pos_i < pos_j; pos_i++){
      left = get(pos_i, pos_z);
      right = get(pos_j, pos_z);
      set(pos_j--, pos_z, left);
      set(pos_i, pos_z, right);
    }
    pos_j = width-1;
  }
  // sets velocity (pixels per second)
  long curr_time = System.currentTimeMillis();
  float draw_time_in_seconds = (curr_time - start_time)/1000.0;
  float pixelYPosition = pixelDropPerSecond * draw_time_in_seconds;
  if (pixelYPosition > 20){
    pixelYPosition = 0;
  }
  start_time = curr_time;
  
  m = millis();
  if (m >= j + 500){
    
    xPos.add(random(width));
    displayedChar.add(poemChar.get(i));
    yPos.add(0.0);
    j = m + 500;
    i++;
  }
  int g = 0;
  color cr_bottom, cr_center;
  for (char c : displayedChar){
    cr_bottom = get(round(xPos.get(g)) + 10, round(yPos.get(g)) + 10 );
    cr_center = get(round(xPos.get(g)), round(yPos.get(g)));
    
    if (yPos.get(g) >= height){
      yPos.set(g, 0.0);
      xPos.set(g, random(width)-1);
 
    }
    if (cr_bottom <=  threshHoldColor || cr_center <=  threshHoldColor){
      while(cr_bottom <=  threshHoldColor || cr_center <=  threshHoldColor){
        letter(c, xPos.get(g), yPos.get(g));
        yPos.set(g, yPos.get(g) - 8);
        cr_bottom = get(round(xPos.get(g)) + 10, round(yPos.get(g)) + 10 );
        cr_center = get(round(xPos.get(g)), round(yPos.get(g)));
      }
    }else{
      letter(c, xPos.get(g), yPos.get(g));
      yPos.set(g, yPos.get(g)+pixelYPosition);
      
    }
    g++;
  }
}


void letter(char c, float x, float y) {
  text(c,(x/20)*20,y);
  fill(int(random(0,250)), int(random(0,250)), int(random(0,250)));
}


void keyPressed() {
  
  if (!inputMethodSelected) {
    // If we haven't yet selected the input method, then check for 0 to 9 keypresses to select from the input menu
    if ((key >= '0') && (key <= '9')) { 
      int input = key - '0';
      if (input == 0) {
        println("Offline mode selected.");
        mov = new Movie(this, "TextRainInput.mov");
        mov.loop();
        inputMethodSelected = true;
      }
      else if ((input >= 1) && (input <= 9)) {
        println("Camera " + input + " selected.");           
        // The camera can be initialized directly using an element from the array returned by list():
        cam = new Capture(this, cameras[input-1]);
        cam.start();
        inputMethodSelected = true;
      }
    }
    return;
  }


  // This part of the keyPressed routine gets called after the input selection screen during normal execution of the program
  // Fill in your code to handle keypresses here..
  
  if (key == CODED) {
    if (keyCode == UP) {
      thresh_red += 5;
      thresh_green += 5;
      thresh_blue += 5;
      filt_thresh += 0.01;
      threshHoldColor = color(thresh_red, thresh_green, thresh_blue);
    }
    else if (keyCode == DOWN) {
      thresh_red -= 5;
      thresh_green -= 5;
      thresh_blue -= 5;
      filt_thresh -= 0.01;
      threshHoldColor = color(thresh_red, thresh_green, thresh_blue);
    }
  }
  else if (key == ' ') {
    if (filt == GRAY){
      filt = THRESHOLD;
    }else{
      filt = GRAY;
    }
  } 
  
}