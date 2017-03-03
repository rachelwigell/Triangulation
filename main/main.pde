/* @pjs preload="graceHopper.jpg"; */  

float gridSize = 8;
float tryInc = 10;
float yGridSize = 7;
float xGridSize = 5;
int gridX;
int gridY;
PImage graceHopper = loadImage("graceHopper.jpg");
final int fieldX = graceHopper.width;
final int fieldY = graceHopper.height;
console.log(graceHopper.width, graceHopper.height);
Vector2D[][] grid;

public void setup(){
  size(fieldX, fieldY, P2D);
  background(255);
  gridX = ceil(fieldX/xGridSize);
  gridY = ceil(fieldY/yGridSize);
  setupBalancedGrid();
  drawTriangles();
}

public void draw(){

}

public void setupHomogenousGrid(){
  grid = new Vector2D[gridX][gridY];
  for(int y = 0; y < gridY; y++){
    for(int x = 0; x < gridX; x++){
      grid[x][y] = new Vector2D((int) (x*gridSize + random(-gridSize/2, gridSize/2)), (int) (y*gridSize  + random(-gridSize/2, gridSize/2)));
    }
  }
}

public void setupEdgeDetectingGrid(){
  grid = new Vector2D[gridX][gridY];
  int j = 0;
  for(int y = 0; y < fieldY-gridSize; y += gridSize){
    HashMap gradToXVal = new HashMap();
    int prevColor = 0;
    for(int x = 0; x < fieldX; x += max(ceil(gridSize/tryInc), 2)){
      if(prevColor == 0){
        prevColor = graceHopper.get(x, y);
        continue;
      }
      else{
        int currColor = graceHopper.get(x,y); 
        gradToXVal.put(colorsDiff(prevColor, currColor), x + ceil(gridSize/(tryInc*2)));
        prevColor = currColor;
      }
    }
    int[] topVals = topValuesForEdgeDetectingGrid(gradToXVal);
    for(int i = 0; i < gridX; i++){
      grid[i][j] = new Vector2D(topVals[i], y + (int) random(-gridSize/2, gridSize/(2)));
    }
    j++;
  }
}

public int[] topValuesForEdgeDetectingGrid(HashMap gradToXVal){
  int[] sortedKeys = new int[ceil(fieldX/max(ceil(gridSize/tryInc), 2))];
  int index = 0;
  for(Object gradient: gradToXVal.keySet()){
    int grad = (int) (gradient);
    sortedKeys[index] = grad;
    index++;
  }
  sortedKeys = sort(sortedKeys);
  sortedKeys = reverse(sortedKeys);
  int[] topVals = new int[gridX];
  for(int i = 0; i < floor(gridX/2); i++){
    topVals[i] = (int) gradToXVal.get(sortedKeys[i]);
  }
  int j = 0;
  for(int i = floor(gridX/2); i < gridX; i++){
    topVals[i] = j + (int) random(-gridSize/2, gridSize/2);
    j += gridSize*2;
  }
  return sort(topVals);
}

public void setupBalancedGrid(){
  grid = new Vector2D[gridX][gridY];
  int k = 0;
  for(int y = 0; k < gridY; y += yGridSize){
    int j = 0;
    for(int x = 0; j < gridX; x += xGridSize*tryInc){
      HashMap xValToGrad = new HashMap();
      for(int i = x + ceil(xGridSize/tryInc); i < x + xGridSize*tryInc + ceil(xGridSize/tryInc); i += ceil(xGridSize/tryInc)){
        xValToGrad.put(i - ceil(xGridSize/(tryInc*2)), colorsDiff(graceHopper.get(i - ceil(xGridSize/tryInc), y), graceHopper.get(i, y)));
      }
      int[] topVals = topValuesForBalancedGrid(xValToGrad);
      for(int i = 0; i < tryInc && j < gridX; i++){
        grid[j][k] = new Vector2D(topVals[i], y + floor(random(-yGridSize/2, yGridSize/2)));
        j++;
      }
    }
    k++;
  }
}

public int[] topValuesForBalancedGrid(HashMap xValToGrad){
  int[] sortedValues = new int[ceil(tryInc*tryInc+tryInc)];
  int index = 0;
  for(Object xVal: xValToGrad.keySet()){
    int x = (int) (xVal);
    sortedValues[index] = (int) xValToGrad.get(x);
    index++;
  }
  sortedValues = sort(sortedValues);
  sortedValues = reverse(sortedValues);
  int[] topVals = new int[ceil(tryInc)];
  for(index = 0; index < tryInc; index++){
    int i = sortedValues[index];
    for(Object xVal: xValToGrad.keySet()){
      if((int) xValToGrad.get(xVal) == i){
        topVals[index] = (int) xVal;
        xValToGrad.put(xVal, -1);
        break;
      }
    }
  }
  return sort(topVals);
}

public int colorsDiff(int color1, int color2){
  int rDiff = ceil(abs(red(color1) - red(color2)));
  int gDiff = ceil(abs(green(color1) - green(color2)));
  int bDiff = ceil(abs(blue(color1) - blue(color2)));
  return rDiff+gDiff+bDiff;
}

public void drawGridPoints(boolean showImage, boolean dynamicColor){
  if(showImage){
    image(graceHopper, 0, 0);
  }
  for(int i = 0; i < gridX-1; i++){
    for(int j = 0; j < gridY-1; j++){
      Vector2D point = (Vector2D) grid[i][j];
      if(dynamicColor) set(point.x, point.y, graceHopper.get(point.x, point.y));
      else set(point.x, point.y, color(255, 0, 255));
    }
  }
}

public void drawTriangles(){
  noStroke();
  int i = 1;
  int j = 1;
  while(j < gridY-2){
    if(i == gridX-1){
      j++;
      i = 1;
    }
    Vector2D point1 = (Vector2D) grid[i][j];
    Vector2D point2 = (Vector2D) grid[i+1][j];
    Vector2D point3 = (Vector2D) grid[i][j+1];
    Vector2D center = new Vector2D(point1, point2, point3);
    int centerColor = graceHopper.get(center.x, center.y);
    fill(centerColor);
    triangle(point1.x, point1.y, point2.x, point2.y, point3.x, point3.y);
    point1 = (Vector2D) grid[i+1][j];
    point2 = (Vector2D) grid[i+1][j+1];
    point3 = (Vector2D) grid[i][j+1];
    center = new Vector2D(point1, point2, point3);
    centerColor = graceHopper.get(center.x, center.y);
    fill(centerColor);
    triangle(point1.x, point1.y, point2.x, point2.y, point3.x, point3.y);
    i++;
  }
}PImage i;
void setup() {
  size(164, 164);
  int ID = int(random(11000, 13000));
  i = loadImage("http" + "://www.flaticon.com/png/64/" + ID + ".png");
}
void draw() {
  if(i.width > 0) {
    image(i, 50, 50);
    noLoop();
  }
}