public class Vector2D {
  public int x;
  public int y;
  
  public Vector2D(int x, int y){
    this.x = x;
    this.y = y;
  }
  
  public Vector2D(Vector2D point1, Vector2D point2, Vector2D point3){
    this.x = floor((point1.x + point2.x + point3.x)/3);
    this.y = floor((point1.y + point2.y + point3.y)/3);
  }

  public float distanceFrom(Vector2D from){
    return (float) sqrt((this.x - from.x)*(this.x-from.x) + (this.y - from.y)*(this.y-from.y));
  }
  
  public float squareDistance(Vector2D from){
    return (float) (this.x - from.x)*(this.x-from.x) + (this.y - from.y)*(this.y-from.y);
  }
  
  public boolean samePoint(Vector2D as){
    return (this.x == as.x && this.y == as.y);
  }
  
  public Vector2D nearestInRow(Vector2D[][] array, int yVal){
    Vector2D nearest = array[0][yVal];
    float dist = this.squareDistance(nearest);
    for(int i = 1; i < gridX-1; i++){
      Vector2D vec = array[i][yVal];
      float newDist = this.squareDistance(vec);
      if(newDist < dist && newDist != 0){
        dist = newDist;
        nearest = vec;
      }
    }
    return nearest;
  }
  
  public Vector2D nearestInColumn(Vector2D[][] array, int xVal){
    Vector2D nearest = array[xVal][0];
    float dist = this.squareDistance(nearest);
    for(int i = 1; i < gridY-1; i++){
      Vector2D vec = array[xVal][i];
      float newDist = this.squareDistance(vec);
      if(newDist < dist && newDist != 0){
        dist = newDist;
        nearest = vec;
      }
    }
    return nearest;
  }
}