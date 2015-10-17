float offsetX, offsetY;
Level eLevel = new Level();
PImage[] tileSprites;
PImage[][] joinedSprites;
PImage bg;
byte c = 0; //change this to input a different file
boolean up, down, left, right;
byte selection = 2;
void setup() {
  size(1200, 800);
  loadImages();
  offsetX = 0;
  offsetY = 0;
  noStroke();
  noSmooth();
  eLevel.loadLevel(c);
  //noCursor();
  textSize(20);
}
//TESTING JUNCTIONS
void draw() {
  background(250);
  eLevel.levelRender();
  fill(0, 100);
  rect(0, 0, 40, 40);
  text(selection, 45, 35);
  if (selection >= 1 && selection <= tileSprites.length) {
    tint(255, 100);
    image(tileSprites[selection-1], 5, 5, 30, 30);
    noTint();
  }
  if (up) {
    offsetY-=10;
  }
  if (down) {
    offsetY+=10;
  }
  if (left) {
    offsetX-=10;
  }
  if (right) {
    offsetX+=10;
  }
  if (mouseX > 0 && mouseY > 0 && mouseX < width && mouseY < height) {
    int sx, sy;
    sx = (int)((mouseX+offsetX)/40);
    sy = (int)((mouseY+offsetY)/40);
    if (sx >= 0 && sy >= 0 && sx < eLevel.levelWidth && sy < eLevel.levelHeight) {
      if (selection > 0) {
        fill(0, 200, 0, 100);
      } else if (selection == 0) {
        fill(200, 0, 0, 100);
      }
      rect(sx*40-offsetX-2, sy*40-offsetY-2, 44, 44);
      if (selection >= 1  && selection <= tileSprites.length) {
        tint(255, 200);
        image(tileSprites[selection-1], sx*40-offsetX, sy*40-offsetY, 40, 40);
        noTint();
      }
      if (mousePressed) {
        byte l = 1;
        if (mouseButton == LEFT) {
          l = 1;
        } else {
          l = 0;
        }
        eLevel.tiles[sx][sy][l] = new Tile(sx, sy, l, selection);
        if (inBounds(sx+1, sy, eLevel.levelWidth, eLevel.levelHeight)) {
          eLevel.tiles[sx+1][sy][l].getDisplayFlags(eLevel.levelWidth, eLevel.levelHeight);
        }
        if (inBounds(sx, sy+1, eLevel.levelWidth, eLevel.levelHeight)) {
          eLevel.tiles[sx][sy+1][l].getDisplayFlags(eLevel.levelWidth, eLevel.levelHeight);
        }
        if (inBounds(sx-1, sy, eLevel.levelWidth, eLevel.levelHeight)) {
          eLevel.tiles[sx-1][sy][l].getDisplayFlags(eLevel.levelWidth, eLevel.levelHeight);
        }
        if (inBounds(sx, sy-1, eLevel.levelWidth, eLevel.levelHeight)) {
          eLevel.tiles[sx][sy-1][l].getDisplayFlags(eLevel.levelWidth, eLevel.levelHeight);
        }
        eLevel.tiles[sx][sy][l].getDisplayFlags(eLevel.levelWidth, eLevel.levelHeight);
      }
    }
  }
}

void keyPressed() {
  //if (key = CODED) {
  if (keyCode == UP) {
    up = true;
  }
  if (keyCode == DOWN) {
    down = true;
  }
  if (keyCode == LEFT) {
    left = true;
  }
  if (keyCode == RIGHT) {
    right = true;
  }
  //}
}

void keyReleased() {
  if (keyCode == UP) {
    up = false;
  }
  if (keyCode == DOWN) {
    down = false;
  }
  if (keyCode == LEFT) {
    left = false;
  }
  if (keyCode == RIGHT) {
    right = false;
  }
}

void exit() {
  eLevel.saveLevel(c);
}

void loadImages() {
  PImage tileMap = loadImage("tileMap.png");
  joinedSprites = new PImage[tileMap.height/10][tileMap.width/10];
  for (int i = 0; i < tileMap.height/10; i++) {
    for (int j = 0; j < tileMap.width/10; j++) {
      joinedSprites[i][j] = tileMap.get(j*10, (i)*10, 10, 10);
    }
  }
  tileMap = loadImage("tiles.png");
  tileSprites = new PImage[tileMap.height/10];
  for (int i = 0; i < tileMap.height/10; i++) {
    tileSprites[i] = tileMap.get(0, i*10, 10, 10);
  }
}


boolean inBounds(int x, int y, int lw, int lh) {
  if (x >= 0 && y >= 0 && x < lw && y < lh) {
    return true;
  } else {
    return false;
  }
}

void mouseWheel(MouseEvent event) {
  float e = event.getCount();
  if ((selection != 0 && e > 0) || (e < 0 && selection != tileSprites.length)) {
    selection -= e;
  }
}