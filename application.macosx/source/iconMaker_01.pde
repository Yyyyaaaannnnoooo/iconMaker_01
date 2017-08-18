import processing.pdf.*;
int grid[][];
int cell = 10;
int w = 500, h = 500;
int cols = w / cell, rows = h / cell;
int posX = 0;
int posY = 0;
int brushSize = 1;
int count = 0;
boolean drawing = false, erasing = false, showImage = true;
boolean displayGrid = false;
String [] loadedIcon;
PImage[] img;
void settings() {
  size(w, h);
}
void setup() {
  img = new PImage[10];
  for (int i = 1; i <= 10; i++) {
    img[i - 1] = loadImage("icon_" + i + ".png");
  }
  grid = new int [cols][rows];
  for (int x = 0; x < cols; x ++) {
    for (int y = 0; y < rows; y ++) {
      grid[x][y] = 1;
    }
  }
}
void draw() {
  background(0);
  if(showImage)image(img[count % img.length], 0, 0);
  noStroke();
  for (int x = 0; x < cols; x ++) {
    for (int y = 0; y < rows; y ++) {
      if (grid[x][y] == 0) {
        fill(255);
        rect(x * cell, y * cell, cell, cell);
      }
    }
  } 
  for (int x = 0; x < cols; x ++) {
    for (int y = 0; y < rows; y ++) {
      noFill();
      stroke(255);
      strokeWeight(.3);
      rect(x * cell, y * cell, cell, cell);
    }
  }
  posX = floor(constrain(map(mouseX, 0, w, 0, cols), 0, cols));
  posY = floor(constrain(map(mouseY, 0, h, 0, rows), 0, rows));
  fill(0, 255, 0);
  println(brushSize);
  for (int x = 0; x < brushSize; x ++) {
    for (int y = 0; y < brushSize; y ++) {
      rect((posX * cell) + (x * cell), (posY * cell) + (y * cell), cell, cell);
      ///Make a resizable brush!!!
      if (drawing) {
        if (posX + x < width && posY + y < height)grid[posX + x][posY + y] = 0;
      }
      if (erasing) {
        if (posX + x < width && posY + y < height)grid[posX + x][posY + y] = 1;
      }
    }
  }
}

void saveIcon() {
  String [] list = new String [cols * rows];
  for (int x = 0; x < cols; x ++) {
    for (int y = 0; y < rows; y ++) {
      int index = x + cols * y;
      list[index] = str(grid[x][y]);
    }
  }
  saveStrings("icon.txt", list);
}

void loadIcon() {
  loadedIcon = loadStrings("icon.txt");
  for (int x = 0; x < cols; x ++) {
    for (int y = 0; y < rows; y ++) {
      int index = x + cols * y;
      grid[x][y] = int(loadedIcon[index]);
    }
  }
}
void keyPressed() {  
  if (key == 'i')count++;
  if (key == 't')showImage = !showImage;
  if (key == 'e')blank();
  if (key == 'v') {
    erasing = !erasing;
    drawing = false;
  }
  if (key == ' ') {
    drawing = !drawing;
    erasing = false;
  }
  //load save icon
  if (key == 's')saveIcon();
  if (key == 'l')loadIcon();
  //brush size
  if (key == CODED) {
    if (keyCode == UP) {
      brushSize++;
      if (brushSize > 10)brushSize = 10;
    }
    if (keyCode == DOWN) {
      brushSize--;
      if (brushSize < 1)brushSize = 1;
    }
  }
}

void blank () {
  for (int x = 0; x < cols; x ++) {
    for (int y = 0; y < rows; y ++) {
      grid[x][y] = 1;
    }
  }
}