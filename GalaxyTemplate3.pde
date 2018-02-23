//////////////////////////////////////////////////////////////////////////////
//Name:
//  _____              _      _   _  __     _       _                   _    _ 
// |  __ \            (_)    | | | |/ /    | |     | |                 | |  (_)
// | |  | | __ _ _ __  _  ___| | | ' /_   _| | __ _| | _____  _   _ ___| | ___ 
// | |  | |/ _` | '_ \| |/ _ \ | |  <| | | | |/ _` | |/ / _ \| | | / __| |/ / |
// | |__| | (_| | | | | |  __/ | | . \ |_| | | (_| |   < (_) | |_| \__ \   <| |
// |_____/ \__,_|_| |_|_|\___|_| |_|\_\__,_|_|\__,_|_|\_\___/ \__,_|___/_|\_\_|
//Due Date: Friday
//Description: Galaxy Game
////////////////////////////////////////////////////////////////////////////// 

import ddf.minim.*; //imports the speed adjuster
import controlP5.*; //imports the music library

ControlP5 MyController; //declares the controller

Minim minim; //declares the music
AudioPlayer player; //background music
AudioSample explosionSound; //explosion sound effect
AudioSample laserSound; //sound when laser is shot

int Speed = 5; //speed that the asteroids fly at
int ballSpeed; //used to remember the previous speed when stopping the movement of balls

PImage empty; //empty heart slots
PImage fillHeart; //heart that is used to fill the slots in

int numberOfHits = 0; //number of times that the asteroids hit the ship

int score = 0; //score

float circleX = 500; //circle that the user has to press in the instructions to continue
float circleY = 530.5;

boolean gameOverB = false; //game over boolean

PImage insOne; //instructions part 1
PImage insTwo; //instructions part 2

boolean one = false; //boolean for part one of instructions
boolean two = false; //boolean for part two of instructions

boolean gInstructions = false; //boolean that activates the instructions screen

PImage background; //background that apears with the start and instructions buttons

PFont myFont; //imports my custom font (in setup)

int c = 0; //colour that I use to colour my text
int cChange = 1; //allows me to alter the value that c is equal to

boolean start = false; //prevents from starting in the beginning without seeing the first screen

int numFrames = 16; //fire sprite
PImage [] images = new PImage[numFrames];
int currentFrame = 1;

int numFrames2 = 6; //sprite when an asteroid hits the ship
PImage [] explosion = new PImage[numFrames2];
int [] currentFrame2 = new int[100];

int numFrames3 = 4; //sprite when the bullet hits an asteroid
PImage [] collision = new PImage[numFrames3];
int [] currentFrame3 = new int[100];

int numFrames4 = 18; //sprite for the beam powerup
PImage [] beamRay = new PImage[numFrames4];
int currentFrame4 = 1;

PImage img; //stars background

PImage bullet; //image for bullet
PImage asteroid; //image for asteroid
PImage ship; //image for ship

int imgY = 0; //y coordinate of the stars background

int bgdSpeed = 0; //speed that the background moves at

// ship variables
int shipW = 50; //width of ship
int shipH = 60; //height of ship
int shipX = 400; //xcoordinate of ship
int shipY = 535-shipH; //ycoordinate of ship
int shipSpeed = 5; //speed that the ship can move left and right at

// ball variables
float [] ballD = new float [100]; //diameter of the asteroid
float [] ballR = new float [100]; //diameter of the asteroids that is used in the scale function to resize the asteroids to random sizes

int powerSpeed = 10; //speed that the powerups move down the screen

int [] ballX = new int [100]; //array of asteroid coordinates
int [] ballY = new int [100];

boolean [] ballVisible = new boolean [100]; //array of if the asteroids are visible or not

// bullet variables
int bulletW = 4; //width of the bullet
int bulletH = 15; //height of the bullet
int bulletSpeed = 10; //speed that the bullet moves down the screen
int currentBullet = 0; //current index of bullet

int [] bulletX = new int [100]; //array for bullet coordinates
int [] bulletY = new int [100];

boolean [] bulletVisible = new boolean [100]; //array for if the bullet is visible or not

// distance between the current bullet and ball
int dist;

// an array that holds the key input (LEFT and RIGHT arrow + SPACE)
boolean[] keys; //boolean array for the keys

boolean triggerReleased = true; //allows for only one bullet to be shot at once

int [] ballRotate = new int [100]; //array for the rotation of the asteroids
float [] ballRSpeed = new float [100]; //array for the rotation speed of the asteroids

Triangle t; //declares a triangle witch is used so that the game could detect if the asteroid hits any part of the ship instead of just the front tip

boolean [] exPlay = new boolean [100]; //array for the number of explosions when the asteroid hits the ship
boolean [] play = new boolean [100]; //array for the number of explosions when the bullet hits the asteroid

int tintLevel = 255; //starting level of tint for the shield powerup

int shieldD = 120; //shield powerup diameter

int beamLength = 0; //how long the beam powerup length plays for

int sloMoLength = 0; //how long the slo motion powerup plays for

int gameOverCounter = 0; //allows for the speed to be remembered when restarting from the game over screen

//////////////////////////////////////////////////
//                 FUNCTIONS                    //
//////////////////////////////////////////////////

void generateBalls() { //generates the asteroids
  for (int i = 0; i<ballX.length; i++) {
    ballX[i] = int(random(width)); //generates the ballX coordinate randomly across the width of the screenth
    ballR[i] = random(0.1, 0.5); //generates the scale factor of the asteroids
    ballD[i] = ballR[i]*asteroid.width; //allows for the diameter of the ball to be a variable
    ballY[i] = int(random((-8)*height-ballD[i])); //generates the ballY coordinate and multiplies it by -7 so that the asteroids start higher up in the screen
    ballVisible[i] = true; //makes all asteroids start off visible
    ballRotate[i] = int(random(1, 360)); //starting point of the rotation of the asteroid
    ballRSpeed[i] = random(3); //speed that the asteroid is rotated at
  }
}

//-------------------------------------------//
void generateBullets() { //generates the bullets
  for (int i = 0; i<bulletX.length; i++) {
    bulletX[i] = -50; //makes the bullets start off at -50, -50
    bulletY[i] = -50;
    bulletVisible[i] = false; //makes all bullets start off invisible
  }
}

//-------------------------------------------//
void redrawGameField() {

  imageMode(CORNER); //draws the image from the corner

  imgY+=5; //moves the stars image down

  if (imgY>img.height) //if the image is below the height then it respawns at the top
    imgY = 0;

  image(img, 0, imgY); //draws the first image at the start
  image(img, 0, imgY-img.height); //draws the second image on top of the first one to be able to make the background seem like it is scrolling

  imageMode(CENTER); //centres the images
  for (int i = 0; i<ballVisible.length; i++) {
    if (ballVisible[i] == true) { //determines if the asteroid is visible
      pushMatrix(); //pushes the matrix until the matrix is popped
      translate(ballX[i], ballY[i]); //moves the asteroid to ballX and ballY
      rotate(radians(ballRotate[i])); //rotates the asteroids
      scale(ballR[i]); //scales the asteroids by a factor of ballR
      image(asteroid, 0, 0); //draws the asteroid images
      popMatrix(); //pops the matrix
      ballRotate[i]+=ballRSpeed[i]; //increases what the asteroid is rotated by
    }
    if (exPlay[i]) { //plays the explosion sprite when the asteroids collide with the ship
      imageMode(CENTER); //centres the images
      image(explosion[currentFrame2[i]], ballX[i], ballY[i]); //draws the images
      if (frameCount%7==0) { //only increases the frame if the frameCount is divisible by 7
        currentFrame2[i]++; //increases currentFrame by 1
      }
      if (currentFrame2[i] >= explosion.length) { //stops playing the animation once it reaches the final frame
        currentFrame2[i] = 1;
        exPlay[i] = false;
      }
    }

    if (play[i]) { //plays the explosion sprite when an asteroid collides with the bullet
      imageMode(CENTER); //centres the images
      pushMatrix(); //pushes the matrix so that the asteroid can be edited until the matrix is popped
      translate(ballX[i], ballY[i]); //moves the coordinates of the sprite to ballX and ballY
      scale(ballR[i]+0.2); //scales the asteroid by ballR
      image(collision[currentFrame3[i]], 0, 0); //draws the images
      popMatrix(); //pops the matrix
      if (frameCount%7==0) { //only increases the current frame if the frame count is divisible by 7
        currentFrame3[i]++;
      }
      if (currentFrame3[i] >= collision.length) { //stops playing once the sprite reaches the final frame
        currentFrame3[i] = 1;
        play[i] = false;
      }
    }
  }

  for (int i = 0; i<powerNumber.length; i++) {
    if (powerVisible[i]) { //determines if the pwoerup is visible or not
      if (powerNumber[i] == 1) { //determines which powerup is being called for
        image(shield, powerX[i], powerY[i]); //draws the corresponding powerup icon
      }
      if (powerNumber[i] == 2) {
        image(beam, powerX[i], powerY[i]);
      }
      if (powerNumber[i] == 3) {
        image(sloMo, powerX[i], powerY[i]);
      }
    }
  }

  imageMode(CORNER); //draws the images from the corner

  image(ship, shipX-shipW/2, shipY); //draws the ship

  for (int i = 0; i<bulletVisible.length; i++) {
    if (bulletVisible[i] == true) { //determines if the bullet is visible
      image(bullet, bulletX[i], bulletY[i]); //draws the bullet
    }
  }

  if (!gameOverB) { //only plays the fire animation if gameover is false
    imageMode(CENTER); //centres the images
    image(images[currentFrame], shipX, shipY+90); //draws the images
    if (frameCount%2==0) { //only increases the current frame if the frame count is divisible by 2
      currentFrame++; //increases the current frame
      if (currentFrame >= images.length) { //if the current frame is out of array bounds, current frame is one
        currentFrame = 1;
      }
    }
  }

  image(empty, 740, 30); //draws the empty heart slots
  if (numberOfHits==0) { //if the ship hasn't been hit by an asteroid, all three hearts are drawn
    image(fillHeart, 705.5, 36); //left
    image(fillHeart, 739.5, 36); //middle
    image(fillHeart, 772.5, 36); //right
  }
  if (numberOfHits==1) { //if it was hit once then only two hearts are drawn
    image(fillHeart, 705.5, 36); //left
    image(fillHeart, 739.5, 36); //middle
  }
  if (numberOfHits==2) { //if it was hit twice then only one heart is drawn
    image(fillHeart, 705.5, 36); //left
  }
  if (numberOfHits==3) { //if it was hit three times then the game over screen appears
    gameOverB = true;
  }

  fill(255); //fills with white
  textSize(40); //increases text size to 40
  text(score, width/2, 50); //displays the score

  if (Speed>0) { //increases speed if score is greater than 0
    if (frameCount%(100/Speed)==0) { //increases the score depending on the speed that the asteroids travel at
      score++;
    }
  }

  t = new Triangle(shipX, shipY, shipX-shipW/2, shipY+shipH, shipX+shipW/2, shipY+shipH); //defines the triangle so that the program can determine if the asteroid hits any part of the ship
  t.drawTriangle(); //draws the triangle

  imageMode(CENTER); //draws the images from the centre
  if (shieldB) { //determines if the shield powerup is true
    tint(255, tintLevel); //tints the shield until the shield can't be seen anymroe
    image(forcefield, shipX, shipY+shipH/2); //draws the image
    noFill(); //draws a circle with no fill and no stroke (so that it isn't visible) and determines if anything touches it so that it can be destroyed
    noStroke();
    ellipse(shipX, shipY+shipH/2, shieldD, shieldD);
    tintLevel-=0.05; //decreases the tint level
    if (tintLevel<=0) { //makes the shield powerup false if the shield is not visible anymore
      shieldB = false;
      tintLevel = 255;
    }
  }
  noTint(); //stops tinting everything else

  if (beamB) { //determines if the beam powerup is true
    imageMode(CORNER); //draws the images from the corner
    image(beamRay[currentFrame4], shipX-shipW, shipY-height+shipH+50); //draws the images
    if (frameCount%7==0) { //only increases current frame if the frame count is divisible by 7
      currentFrame4++;
    }
    if (currentFrame4 >= beamRay.length) { //stops playing the beam after three times
      currentFrame4 = 1;
      beamLength++;
      if (beamLength==3) {
        beamB = false;
        beamLength = 0;
      }
    }
  }

  if (sloMoB) { //determines if the slo motion powerup is true
    if (sloMoLength==0) { //only assigns the speed to ballSpeed once (so that it doesn'y become 0 later)
      ballSpeed = Speed;
      sloMoLength++; //increases the length so that the speed isn't assigned again
    }
    if (frameCount%50==0) { //only increases the length if the frame count is divisble by 50
      sloMoLength++;
    } else {
      Speed = 2;
    }
    if (sloMoLength>=5) { //if the slo motion length is 5, then the speed returns to normal and the powerup turns false
      Speed = ballSpeed;
      sloMoLength = 0;
      sloMoB = false;
    }
  }
}

//-------------------------------------------//
void moveBalls() { //moves the asteroids
  for (int i = 0; i<ballY.length; i++) {
    ballY[i] += Speed; //moves by the Speed
    if (ballY[i] >= height+ballD[i]) { //determines if the asteroids are further than the height
      ballY[i] = int(((-7)*height+ballD[i])); //changes the ycoordinate to -7 times the screen
      ballX[i] = ballX[i] = int(random(width)); //changes the xcoordinates to anywhere in the width
      ballVisible[i] = true; //makes the asteroids visible
    }
  }
}
//-------------------------------------------//
void moveBullets() { //moves the bullets
  for (int i = 0; i<bulletVisible.length; i++) {
    if (bulletVisible[i] == true) { //determines if the bullet is visible
      bulletY[i] -= bulletSpeed; //moves the bullet up
      if (bulletY[i] < 30-(bulletH/2)) { //stops the bullets from moving past the top by making them not visible
        bulletVisible[i] = false;
      }
    }
  }
}
//-------------------------------------------//
// a functions that calculates and returns the distance between two points as a decimal number
int distance (int x1, int y1, int x2, int y2) {
  return round(sqrt(pow((x1 - x2), 2) + pow((y1 - y2), 2)));
}
//-------------------------------------------//

// check for collison between the vidible bullets and visible balls using the distance function
void checkCollision() { //checks any collisions
  for (int i = 0; i<100; i++) {
    for (int j = 0; j<100; j++) {
      dist = distance(ballX[i], ballY[i], bulletX[j], bulletY[j]); //determines the distance between asteroids and bullets
      if (dist <= ballD[i]-5) { //determines if this distance is less than the ball diameter
        if (ballVisible[i]==true && bulletVisible[j]==true) { //determines if both the asteroid and the bullet are visible
          explosionSound.trigger(); //plays the explosion sound
          play[i] = true; //plays the sprite (in redrawGameField())
          score+=100*Speed; //score increases the score depending on the speed that the asteroids are moving at
          ballVisible[i] = false; //makes the asteroid invisible
          bulletVisible[j] = false; //makes the bullet invisible
        }
      }
    }
  }

  for (int i = 0; i<100; i++) {
    if ((checkCollisionTriangle(ballX[i]+ballD[i]/2, ballY[i]+ballD[i]/2, t)) || (checkCollisionTriangle(ballX[i]-ballD[i]/2, ballY[i]+ballD[i]/2, t))) { //determines if the asteroid is inside of the triangle (explained at the bottom of the code)
      if (ballVisible[i]) { //checks if the asteroid is visible
        explosionSound.trigger(); //plays the explosion sound
        exPlay[i] = true; //plays the explosion sprite
        numberOfHits++; //increases the number of times that the ship has been hit
        ballVisible[i] = false; //makes the asteroids invisible
      }
    }
  }

  if (gameOverB) {
    gameOver();
  }

  for (int i = 0; i<numberOfPowerUps; i++) {
    if ((checkCollisionTriangle(powerX[i]+powerD/2, powerY[i]+powerD/2, t)) || (checkCollisionTriangle(powerX[i]-powerD/2, powerY[i]+ballD[i]/2, t))) { //checks if the powerup is inside of the triangle (explained at the bottom of the code)
      if (powerVisible[i]) { //checks if the powerup is visible
        powerVisible[i] = false; ///makes the powerup icon invisible
        if (powerNumber[i]==1) { //checks what powerup the ship has hit and plays the corresponding powerup
          shieldB = true;
        }
        if (powerNumber[i]==2) {
          beamB = true;
        }
        if (powerNumber[i]==3) {
          sloMoB = true;
        }
      }
    }
  }

  for (int i = 0; i<100; i++) {
    dist = distance(ballX[i], ballY[i], shipX, shipY); //calculates the distance between the asteroid and the ship
    if (dist <= ballD[i]/2+shieldD/2) { //checks if distance of the asteroid is less than or equal to the shield's diameter
      if (ballVisible[i]==true && shieldB) { //checks if the asteroid is visible and if the shield powerup is true
        explosionSound.trigger(); //plays the explosion sound
        play[i] = true; //plays the explosion sprite
        score+=100*Speed; //inreases the score depending on the speed of the asteroids
        ballVisible[i] = false; //makes the asteroid invisible
      }
    }
  }

  for (int i = 0; i<100; i++) {
    dist = distance(ballX[i], ballY[i], shipX, shipY); //calaculates the distance between the asteroid and the ship
    if ((ballX[i]+ballD[i]/2 >= shipX-shipW && ballX[i]-ballD[i]/2 <= shipX-shipW + shipX/4) && (ballY[i]-ballD[i]/2 > 0) && (ballY[i]+ballD[i]/2 < shipY+shipH)) { //checks if the asteroid is in hte range of the beam
      if (ballVisible[i]==true && beamB) { //checks if the asteroid is visible and if the beam powerup is true
        explosionSound.trigger(); //plays the explosion sound effect
        play[i] = true; //plays the explosion sprite
        score+=100*Speed; //increases the score depending on the speed of the asteroids
        ballVisible[i] = false; //makes the asteroids invisible
      }
    }
  }
}

/////////////////////////////////////////////
// Main Program                            //
/////////////////////////////////////////////

void setup() {
  size(800, 600); //sets the screen size

  smooth(); //smooths everything
  noStroke(); //removes any stroke

  myFont = loadFont("AbadiMT-CondensedExtraBold-48.vlw"); //sets my font to a custom one
  textFont(myFont);

  MyController = new ControlP5(this); //displays an adjuster for the speed
  MyController.addSlider("Speed", 5, 15, 5, 20, 30, 200, 30);

  minim = new Minim(this); //plays music
  player = minim.loadFile("song.mp3"); //loads the background music
  explosionSound = minim.loadSample("explosion.mp3"); //loads the explosion music
  laserSound = minim.loadSample("laser.wav"); //loads the laser music

  background = loadImage("background.png"); //loads the starting screen image
  background.resize(width, height);
  img = loadImage("stars.jpg"); //loads the stars image
  img.resize(width, height);

  insOne = loadImage("instructionsPart1.png"); //loads the first page of instructions
  insOne.resize(width, height);
  insTwo = loadImage("instructionsPart2.png"); //loads the second page of instructions
  insTwo.resize(width, height);
  asteroid = loadImage("asteroid.png"); //loads asteroid image
  bullet = loadImage("bullet.png"); //loads bullet image
  bullet.resize(bulletW, bulletH);
  ship  = loadImage("ship.png"); //loads ship image
  ship.resize(shipW, shipH);
  empty = loadImage("emptyLives.png"); //loads empty heart slots
  empty.resize(110, 50);
  fillHeart = loadImage("heartFill.png"); //loads hearts
  fillHeart.resize(27, 21);
  shield = loadImage("shield.png"); //loads shield icon
  shield.resize(powerD, powerD);
  beam = loadImage("beam.png"); //loads beam icon
  beam.resize(powerD, powerD);
  sloMo = loadImage("time.png"); //loads slo mo icon
  sloMo.resize(powerD, powerD);
  forcefield = loadImage("forcefield_spyBig.png"); //loads forcefield image (for the shield)
  forcefield.resize(120, 120);

  keys=new boolean[5]; //loads the boolean array for the keys and makes them all false
  keys[0]=false;                           
  keys[1]=false;
  keys[2]=false;
  keys[3]=false;
  keys[4]=false;

  generateBalls(); //calls the functions
  generateBullets();
  spawnPowerUps();

  for (int i = 1; i<images.length; i++) { //loads the fire sprite
    String imageName = "frame" + nf(i, 4) + ".gif";
    images[i] = loadImage(imageName);
    images[i].resize(50, 100);
  }

  for (int i = 1; i<explosion.length; i++) { //loads the explosion sprite
    String imageName2 = "frame" + nf(i, 4) + ".png";
    explosion[i] = loadImage(imageName2);
    explosion[i].resize(shipW+70, shipH+30);
  }

  for (int i = 1; i<collision.length; i++) { //loads the other explosion sprite
    String imageName3 = "frames" + nf(i, 4) + ".png";
    collision[i] = loadImage(imageName3);
    //collision[i].resize(int(ballD[i]+30), int(ballD[i]+30));
  }
  for (int i = 0; i<currentFrame2.length; i++) { //makes all the current frames start at 1
    currentFrame2[i] = 1;
    currentFrame3[i] = 1;
  }

  for (int i = 1; i<beamRay.length; i++) { //loads the beam sprite
    String imageName4 = "fram" + nf(i, 4) + ".gif";
    beamRay[i] = loadImage(imageName4);
    beamRay[i].resize(shipX/4, height-shipH);
  }
}

void draw() {
  cursor(HAND); //changes the cursor to a hand
  if (!start && !gInstructions) {
    if ((mouseX >= 215 && mouseX <= 585) && (mouseY >= 150 && mouseY <= 275) && mousePressed) { //if the start button is pressed, the game starts
      start = true;
    }

    if ((mouseX >= 247 && mouseX <= 550) && (mouseY >= 340 && mouseY <= 420) && mousePressed) { //if the instructions button is pressed, the instructions are displayed
      gInstructions = true;
    }
  }

  colorMode(HSB); //changes the colour mode to HSB
  background(background); //changes the background to the starting screen

  if (!player.isPlaying()) { //determines if the music isn't playing and loops it
    player.rewind();
    player.play();
  }

  rectMode(CORNER); //draws rectangles from the corner
  noStroke(); //removes the stroke
  textAlign(CENTER); //aligns the text to the centre
  fill(c, 255, 255); //fills with c so that the colour can be rainbow
  if (!one || !two) { //if the instructions are false, the colour changes slowly
    c+=cChange;
  }
  if (one || two) { //if the instructions are true, the brightness changes faster
    c+=3*cChange;
  }

  if (c>255) { //if the colour is greater than 255, it goes back down
    cChange = -1;
  }
  if (c<0) { //if the colour is less than 0, it goes back up
    cChange = 1;
  }

  textSize(60); //increases the text size to 60
  text("START", width/2, 240); //displays START

  textSize(50); //increases the text size to 50
  text("INSTRUCTIONS", width/2, 400); //displays INSTRUCTIONS

  if (start) { //plays only if start is true
    background(0); //changes background underneath the images to black
    redrawGameField(); //calls all the functions
    movePowerUps();
    moveBalls();
    moveBullets();
    checkCollision();

    // move the ship with LEFT & RIGHT ARROWS KEYS

    if (keys[0]) { //only moves the ship to the left if it isn't offscreen
      if (shipX<=width-shipW+20) {
        shipX = shipX + shipSpeed;
      }
    }

    if (keys[1]) { //only moves the ship to the right if it isn't offscreen
      if (shipX>=shipW-20) {
        shipX = shipX - shipSpeed;
      }
    }

    if (keys[3]) { //only moves the ship to the up if it isn't offscreen
      if (shipY>=0) {
        shipY = shipY - shipSpeed;
      }
    }

    if (keys[4]) { //only moves the ship to the down if it isn't offscreen
      if (shipY<=height-shipH-75) {
        shipY = shipY + shipSpeed;
      }
    }
    // shoot bullets with SPACE BAR
    if (keys[2] && triggerReleased) { // triggerReleased is true when the SPACE bar is pressed
      triggerReleased = false; // then it turns into false to prevent creating more then one bullet 
      if (!gameOverB) { //only plays the sound effect if game over isn't true
        laserSound.trigger();
      }
      bulletX[currentBullet] = shipX; //changes the bullet coordinates to the ship
      bulletY[currentBullet] = shipY;           
      bulletVisible[currentBullet] = true; //makes the specific bullet true
      currentBullet++; //increases the bullet count
      if (currentBullet == 100) { //if the bullet counter reaches 100, it goes back to 0
        currentBullet = 0;
      }
    } else if (keys[2]==false) { //only fires one bullet at a time
      triggerReleased = true;
    }
  }
  if (gInstructions == true) { //calls the instructions function
    instructions();
  }
}

void keyPressed() {
  if (!gameOverB) { //if game over isn't true, then the ship can be moved
    // move the ship left / right / up / down with the arrow keys
    if (key==CODED && keyCode==RIGHT) keys[0]=true;
    if (key==CODED && keyCode==LEFT)  keys[1]=true;
    if (key==CODED && keyCode==UP) keys[3]=true;
    if (key==CODED && keyCode==DOWN) keys[4]=true;
    // shoot bullets when SPACE BAR is pressed
    if (key==' ') keys[2]=true;

    if (keyCode==ENTER) { //pauses the game if ENTER is pressed
      //if (!gInstructions && start) {
      if (start) { //only pauses if the game has started
        if (looping) { //determines if the draw function is looping and if it is, it stops looping, and if it isn't, it starts looping
          textSize(50); //changes text size to 50
          fill(255); //fills with white
          text("Paused\nPress Enter To Continue", width/2, height/2); //displays pause text
          noLoop(); //stops looping
        } else { //if it isn't looping
          loop(); //loops
        }
      }
    }
  }
}

void keyReleased() { //determines if the key is pressed
  //makes the keys false when they are released
  if (key==CODED && keyCode==RIGHT) keys[0]=false;
  if (key==CODED && keyCode==LEFT) keys[1]=false;
  if (key==CODED && keyCode==UP) keys[3]=false;
  if (key==CODED && keyCode==DOWN) keys[4]=false;
  if (key==' ') keys[2]=false;
}

void instructions() {
  if (!start) { //checks if start is false
    one = true; //makes one true
    if (!two) { //if two isn't true
      imageMode(CORNER); //draws images from the corner
      colorMode(RGB); //changes to RGB mode
      stroke(255, 0, 0); //changes the stroke to red
      strokeWeight(3); //changes the stroke weight to 3
      noFill(); //takes out the fill
      ellipse(circleX, circleY, 47, 47); //draws a small circle that the user has to press to get to the next set of instructions

      if (dist(mouseX, mouseY, circleX, circleY)<=23.5 && mousePressed==true && one == true) { //determines if the mouse is inside of the circle and if the mouse is pressed
        two = true; //makes instructions part 2 true
      }
    }

    if (one==true) { //if part 1 is true, it displays the corresponding instructions
      image(insOne, 0, 0);
    }

    if (two==true) { //if part 2 is true, it displays the corresponding instructions
      image(insTwo, 0, 0);
    }

    colorMode(HSB); //changes colour mode to HSB
    fill(0, 0, c); //allows for the colour to be altered by putting c for the brightness
    textSize(25); //changes text size to 25
    text("Press Spacebar To Start Playing", width/2, 590); //displays text

    if (key==' ') { //determines if spacebar was pressed
      start = true; //makes start true
      redrawGameField(); //draws the ship, asteroids, etc.
      one = false; //makes both the instruction screens false
      two = false;
    }
  }
}

void gameOver() { //game over function
  background(img); //changes the background to hard coordinate version of the stars background
  if (gameOverCounter==0) { //only memorizes speed once to prevent the speed to be turned to 0 later on
    ballSpeed = Speed;
    gameOverCounter++;
  }
  Speed = 0; //stops moving the asteroids

  fill(255); //fills with white
  textSize(40); //changes text size to 40
  text(score, width/2, 50); //displays the score

  fill(c, 255, 255); //fills with c to allow for changing rainbow colour

  c+=cChange; //increases by cChange

  if (c>255) { //if the colour is greater than 255, it goes back down
    cChange = -1;
  }
  if (c<0) { //if the colour is less than 0, it goes back up
    cChange = 1;
  }

  textSize(100); //changes text size to 100
  text("Game Over", width/2, height/2); //displays game over text
  textSize(50); //changes text size to 50
  text("Press 'r' To Restart", width/2, height/2+110); //displays restart text
  if (keyPressed && key == 'r' || key == 'R') { //checks if the 'r' key is pressed
    score = 0; //resets the acore
    Speed = ballSpeed; //changes the speed back to normal
    shipX = 400; //puts the ship back to the starting place
    shipY = 535-shipH;
    generateBalls(); //regenerates all the asteroids and powerups
    spawnPowerUps();
    numberOfHits = 0; //resets lives
    gameOverB = false; //stops looping game over
  }
}

/*
I found all of the code featured below is code that I found online and modified it to suit my needs (from http://www.openprocessing.org/sketch/6380). The purpose of 
 this code is to detect whether or not an asteroid hits any part of the ship instead of just the tip which makes the game more challenging and engaging because the player
 can't just fly in a straight line and keep pressing the spacebar (because they will get hit at some point on the wings). This code is perfect for this job because my 
 ship is in the shape of a triangle. This code works by calculating the area of the triangle and checking if any asteroids are inside of this area by first defining a
 class, and then using other functions that specify what the points inside of this area are. Then in my check collision function, the program checks the coordinates of
 the asteroids with the points that are inside of the triangle and if the points are equal, then it plays the collision.
 */

class Triangle {
  float point1x;
  float point1y;
  float point2x;
  float point2y;
  float point3x;
  float point3y;

  Triangle(float point1x, float point1y, float point2x, float point2y, float point3x, float point3y) {
    this.point1x = point1x;
    this.point1y = point1y;
    this.point2x = point2x;
    this.point2y = point2y;
    this.point3x = point3x;
    this.point3y = point3y;
  }

  void drawTriangle() {
    noFill();
    triangle(point1x, point1y, point2x, point2y, point3x, point3y);
  }
}

boolean checkCollisionTriangle(float x, float y, Triangle t) {
  float tArea, t1Area, t2Area, t3Area;
  tArea  = triangleArea(t.point1x, t.point1y, t.point3x, t.point3y, t.point2x, t.point2y);
  t1Area = triangleArea(x, y, t.point2x, t.point2y, t.point3x, t.point3y);
  t2Area = triangleArea(x, y, t.point3x, t.point3y, t.point1x, t.point1y);
  t3Area = triangleArea(x, y, t.point2x, t.point2y, t.point1x, t.point1y);
  noStroke();
  noFill();
  triangle(t.point1x, t.point1y, t.point3x, t.point3y, t.point2x, t.point2y);
  triangle(x, y, t.point2x, t.point2y, t.point3x, t.point3y);
  triangle(x, y, t.point3x, t.point3y, t.point1x, t.point1y);
  triangle(x, y, t.point2x, t.point2y, t.point1x, t.point1y);

  float totalArea = t1Area+t2Area+t3Area;
  return (totalArea == tArea);
}

float triangleArea(float p1, float p2, float p3, float p4, float p5, float p6) {
  float a, b, c, d;
  a = p1 - p5;
  b = p2 - p6;
  c = p3 - p5;
  d = p4 - p6;
  return (0.5* abs((a*d)-(b*c)));
}