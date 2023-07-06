import processing.core.*;

PShape ship; 
float shipX; 
float shipY;
float shipZ;

ArrayList<PVector> meteors; 
ArrayList<PVector> bullets; 

ArrayList<PVector> bulletsToRemove; 
ArrayList<PVector> meteorsToRemove; 

boolean upPressed = false; 
boolean downPressed = false; 
boolean leftPressed = false; 
boolean rightPressed = false; 

boolean gameOver = false; 

int highScore = 0; 

void setup() {
  size(800, 600, P3D); 
  ship = createShape(BOX, 40, 20, 80); 
  ship.setTexture(loadImage("spaceship_texture.jpg")); 

  meteors = new ArrayList<PVector>(); 
  bullets = new ArrayList<PVector>(); 

  bulletsToRemove = new ArrayList<PVector>();
  meteorsToRemove = new ArrayList<PVector>(); 

  
  shipX = width / 2;
  shipY = height / 2;
  shipZ = +200;
}

void draw() {
  background(0); 
  if (!gameOver) {
   
    if (upPressed) {
      shipY -= 5;
    } else if (downPressed) {
      shipY += 5;
    }
    if (leftPressed) {
      shipX -= 5;
    } else if (rightPressed) {
      shipX += 5;
    }

   
    pushMatrix();
    translate(shipX, shipY, shipZ); 
    shape(ship); 
    popMatrix();

 
    if (frameCount % 60 == 0) {
      float meteorX = random(width);
      float meteorY = random(height);
      float meteorZ = -500;
      meteors.add(new PVector(meteorX, meteorY, meteorZ));
    }

    // Draw meteors
    for (PVector meteor : meteors) {
      pushMatrix();
      translate(meteor.x, meteor.y, meteor.z);
      sphere(20);
      popMatrix();

     
      meteor.z += 1; 

    
      if (dist(meteor.x, meteor.y, meteor.z, shipX, shipY, shipZ) < 40) {

        gameOver = true;
        break;
      }

      // Remove meteors that have moved off the screen
      if (meteor.z > height) {
        meteorsToRemove.add(meteor);
      }
    }

   
    for (PVector bullet : bullets) {
      pushMatrix();
      translate(bullet.x, bullet.y, bullet.z);
      box(10, 10, 10); // Draw a box as a bullet
      popMatrix();

      
      bullet.z -= 10; // Move bullet away from the spaceship

      
      for (PVector meteor : meteors) {
        if (dist(bullet.x, bullet.y, bullet.z, meteor.x, meteor.y, meteor.z) < 20) {
         
          bulletsToRemove.add(bullet);
          meteorsToRemove.add(meteor);
          highScore += 5; 
          break;
        }
      }

      
      if (bullet.z < -1000) {
        bulletsToRemove.add(bullet);
      }
    }

   
    bullets.removeAll(bulletsToRemove);
    meteors.removeAll(meteorsToRemove);
    bulletsToRemove.clear();
    meteorsToRemove.clear();

  
    textAlign(LEFT);
    textSize(20);
    fill(255);
    text("High Score: " + highScore, 20, 30);
  } else {
    
    textAlign(CENTER);
    textSize(50);
    fill(255);
    text("Game Over!", width / 2, height / 2);
  }
}

void keyPressed() {
 
  if (keyCode == UP) {
    upPressed = true;
  } else if (keyCode == DOWN) {
    downPressed = true;
  } else if (keyCode == LEFT) {
    leftPressed = true;
  } else if (keyCode == RIGHT) {
    rightPressed = true;
  }

  
  if (key == ' ') {
    bullets.add(new PVector(shipX, shipY, shipZ));
  }
}

void keyReleased() {
  // Reset the arrow key states
  if (keyCode == UP) {
    upPressed = false;
  } else if (keyCode == DOWN) {
    downPressed = false;
  } else if (keyCode == LEFT) {
    leftPressed = false;
  } else if (keyCode == RIGHT) {
    rightPressed = false;
  }
}
