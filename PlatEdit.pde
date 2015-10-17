float offsetX, offsetY;
Level eLevel = new Level();
PImage[] tileSprites;
PImage[][] joinedSprites;
PImage bg;
byte c = 0; //change this to input a different file
boolean up, down, left, right, shift;
byte selection = 2;
int brushRadius = 0;
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
    if (shift) {
      offsetY-=15;
    }
  }
  if (down) {
    offsetY+=10;
    if (shift) {
      offsetY+=15;
    }
  }
  if (left) {
    offsetX-=10;
    if (shift) {
      offsetX-=15;
    }
  }
  if (right) {
    offsetX+=10;
    if (shift) {
      offsetX+=15;
    }
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
      rect((sx-brushRadius)*40-offsetX-2, (sy-brushRadius)*40-offsetY-2, 44+(80*brushRadius), 44+(80*brushRadius));
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
        for (int i = sx-brushRadius; i < sx + brushRadius+1; i++) {
          for (int j = sy-brushRadius; j < sy + brushRadius+1; j++) {
            if (inBounds(i, j, eLevel.levelWidth, eLevel.levelHeight)) {
              eLevel.tiles[i][j][l] = new Tile(i, j, l, selection);
              eLevel.tiles[i][j][l].getDisplayFlags(eLevel.levelWidth, eLevel.levelHeight);
            }
            if (inBounds(i+1, j, eLevel.levelWidth, eLevel.levelHeight)) {
              eLevel.tiles[i+1][j][l].getDisplayFlags(eLevel.levelWidth, eLevel.levelHeight);
            }
            if (inBounds(i, j+1, eLevel.levelWidth, eLevel.levelHeight)) {
              eLevel.tiles[i][j+1][l].getDisplayFlags(eLevel.levelWidth, eLevel.levelHeight);
            }
            if (inBounds(i-1, j, eLevel.levelWidth, eLevel.levelHeight)) {
              eLevel.tiles[i-1][j][l].getDisplayFlags(eLevel.levelWidth, eLevel.levelHeight);
            }
            if (inBounds(i, j-1, eLevel.levelWidth, eLevel.levelHeight)) {
              eLevel.tiles[i][j-1][l].getDisplayFlags(eLevel.levelWidth, eLevel.levelHeight);
            }
          }
        }
      }
    }
  }
}

void keyPressed() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shift = true;
    }
  }
  if (key == 'w' || key == 'W') {
    up = true;
  }
  if (key == 's' || key == 'S') {
    down = true;
  }
  if (key == 'a' || key == 'A') {
    left = true;
  }
  if (key == 'd' || key == 'D') {
    right = true;
  }
}

void keyReleased() {
  if (key == CODED) {
    if (keyCode == SHIFT) {
      shift = false;
    }
  }
  if (key == 'w' || key == 'W') {
    up = false;
  }
  if (key == 's' || key == 'S') {
    down = false;
  }
  if (key == 'a' || key == 'A') {
    left = false;
  }
  if (key == 'd' || key == 'D') {
    right = false;
  }
  if (key == ',' && brushRadius > 0) {
    brushRadius--;
  }
  if (key == '.') {
    brushRadius++;
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