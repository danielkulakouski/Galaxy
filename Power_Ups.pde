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
int numberOfPowerUps = 5; //the number of powerups that can appear in the game at a time and is a variable so that it can be easily adjusted
int [] powerNumber = new int [numberOfPowerUps]; //picks a random integer and shows the corresponding powerup
int [] powerX = new int [numberOfPowerUps]; //random powerup x coordinate
int [] powerY = new int [numberOfPowerUps]; //random powerup y coordinate
boolean [] powerVisible = new boolean [numberOfPowerUps]; //makes the powerup visible or not

PImage shield; //defines shield powerup icon
PImage beam; //defines beam powerup icon
PImage sloMo; //defines sloMo powerup icon
PImage forcefield; //defines forcefield powerup icon

boolean shieldB = false; //plays the powerup only if the boolean is true
boolean beamB = false;
boolean sloMoB = false;

int powerD = 50; //diameter of the powerup icon

void spawnPowerUps() { //spawns powerups
  for (int i = 0; i<powerNumber.length; i++) {
    powerX[i] = int(random(20, width-20)); //generates random coordinates
    powerY[i] = int(random((-8)*height));
    powerNumber[i] = int(random(1, 4)); //generates a random number and based on that number, the corresponding powerup will spawn
    powerVisible[i] = true; //makes all the powerups visible
  }
}

void movePowerUps() { //moves powerups
  for (int i = 0; i<powerNumber.length; i++) {
    powerY[i] += Speed; //moves the powerups depending on the asteroid speed
    if (powerY[i] >= height+powerD) { //determines if the powerup passes the bottom
      powerY[i] = int(((-7)*height+powerD)); //spawns the powerup back above the screen
      powerX[i] = powerX[i] = int(random(width)); //changes the x coordinate
      powerNumber[i] = int(random(1, 4)); //changes the powerup
      powerVisible[i] = true; //makes the powerup visible again
    }
  }
}