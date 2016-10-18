//  inter_type_seizure.pde
// Jeffrey Paletta

ParticleSystem ps;
String Quote = "Jeff is the coolest";
PFont f;

void setup() {
  size(600, 600);
  smooth();
  noStroke();
  f = loadFont("Flama-Medium-48.vlw");
  colorMode(HSB, 360, 100, 100);
  ps = new ParticleSystem(1, new PVector(width/2, height/2));
  noCursor();
}

void draw() {
  background(25);
  ps.run();
  ps.addParticle(mouseX,mouseY);

}
class Particle {
  PVector loc;
  PVector vel;
  PVector acc;
  float life;
  float h; //hue

  Particle(PVector _loc) {
    loc = _loc.get();
    vel = new PVector(random(-1, 0.5), random(-1, 1), 0);
    acc = new PVector(random(-0.1, -.01), random(-0.1, -0.01), 0);
    life = 10.0;
    h = random(0,100);
  }

  void run() {
    display();
    update();
  }

  void display() {

    fill(h, 90, 90, life);
    float a = life * 0.1; //Size also linked to life.
    textFont(f, 32);
    int x = 10;
      fill(h, 90, 90);
    textAlign(CENTER, CENTER);
    textSize(random(mouseX, mouseY));
    text (Quote, width/2,height/2);
    for (int i = 0; i < Quote.length(); i++) {
      textSize(random(12, 52));
      text(Quote.charAt(i), x+i, random(0,height));
      // textWidth() spaces the characters out properly.
      x += textWidth(Quote.charAt(i));
    }

    fill(25);
    ellipse(mouseX,mouseY,150,150);


  }

  void update() {
    vel.add(acc); //Add acceleration to velocity
    loc.add(vel); //Add velocity to position
    life -= 1.5;  //Decrease the lifespan by 2
  }

  boolean dead() {
    if (life <= 0.0) { //Am I dead???
      return true;
    }
    else {
      return false;
    }
  }
}

class ParticleSystem {

  ArrayList particles; //The list of Particles
  PVector origin;

  ParticleSystem(int num, PVector _origin) {
    particles = new ArrayList();
    origin = _origin.get();
    for ( int i=0; i<num; i+=20) {
      particles.add(new Particle(origin));
    }
  }

  void run() {
    for (int i = particles.size()-1; i>=0; i--) {
      Particle p = (Particle) particles.get(i);
      p.run();
      if (p.dead()) {
        particles.remove(i);
      }
    }
  }
  void addParticle(float i, float _y) {
    particles.add(new Particle(new PVector(i, _y)));
  }

  boolean dead(){
     if(particles.isEmpty())
      return true;
     else
      return false;
  }
}