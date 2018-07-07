abstract class Figure{
  int index;
  int movesCounter=0;
  PImage figureImage = new PImage();
  PVector[] possibleMoves = null;
  float maxSpeed = 10;
  float maxForce = 7;
  PVector futurePos = new PVector();
  PVector pos = new PVector();
  PVector acc = new PVector();
  PVector vel = new PVector();
  int isBlack=0;
  boolean isMoving=false;
  final float maximumRadius = 15;
  final float minimumRadius = 5;
  final float radiusIncreasing = 0.42;
  float currentRadius = 10;
  boolean isBackward = false;
  
  Figure(int isBlack){
    this.isBlack = isBlack;
  }
  //abstract PVector[] getAllMoves();
  //abstract PVector[] getAttackMoves();
  abstract PVector[] getPossibleMovesImp();
  PVector[] getPossibleMoves(){
    if(Game.refreshCounter == 0){
      PVector [] moves = getPossibleMovesImp();
      this.possibleMoves = moves;
      return this.possibleMoves;
    }else{
      return this.possibleMoves; 
    }
  }
  void showMoves(){
    PVector [] moves = getPossibleMoves();
    if(this instanceof Pawn){
      for(int k = 0; k < 2; k++){
        PVector coords = moves[k];
        if(coords.z == 1 && !isNegativeCoords(coords)){
          if(Game.cells[(int)coords.x][(int)coords.y].figure != null){
            fill(180,0,0,70);
            stroke(230,0,0);
            rect(coords.y * Game.cellWidth, coords.x * Game.cellWidth, Game.cellWidth, Game.cellWidth);
            ellipse(coords.y * Game.cellWidth + Game.cellWidth/2, coords.x * Game.cellWidth + Game.cellWidth/2,currentRadius,currentRadius);
          }
        }
      }
      for(int k = 2; k < moves.length; k++){
        PVector coords = moves[k];
        if(coords.z == 1){
          fill(180,0,0,70);
          stroke(230,0,0);
          rect(coords.y * Game.cellWidth, coords.x * Game.cellWidth, Game.cellWidth, Game.cellWidth);
          ellipse(coords.y * Game.cellWidth + Game.cellWidth/2, coords.x * Game.cellWidth + Game.cellWidth/2,currentRadius,currentRadius);
        }
      }
    }else{
      for(int k = 0; k < moves.length; k++){
        PVector coords = moves[k];
        if(coords.z == 1){
          fill(180,0,0,70);
          stroke(230,0,0);
          rect(coords.y * Game.cellWidth, coords.x * Game.cellWidth, Game.cellWidth, Game.cellWidth);
          ellipse(coords.y * Game.cellWidth + Game.cellWidth/2, coords.x * Game.cellWidth + Game.cellWidth/2,currentRadius,currentRadius);
        }
      }
    }
    if(isBackward){
      currentRadius -= radiusIncreasing;
    }else{
      currentRadius += radiusIncreasing;
    }
    
    if(currentRadius >= maximumRadius){
      isBackward = true;
    }else if(currentRadius <= minimumRadius){
      isBackward = false;
    }
  }
  void move(int x, int y){
    //println(Game.lastSelectedCell);
    //println(x + ", " + y);
    PVector [] moves = getPossibleMoves();
    boolean isValidMove = false;
    if(this instanceof Pawn){
      for(int i = 0; i < 2; i++){
        PVector move = moves[i];
        if(move.x == y && move.y == x){
          if(move.z == 1 && Game.cells[(int)move.x][(int)move.y].figure != null){
            isValidMove = true;
            break;
          }
        }
      }
      for(int i = 2; i < moves.length; i++){
        PVector move = moves[i];
        if(move.x == y && move.y == x){
          if(move.z == 1){
            isValidMove = true;
            break;
          }
        }
      }
    }else{
      for(int i = 0; i < moves.length; i++){
        PVector move = moves[i];
        if(move.x == y && move.y == x){
          if(move.z == 1){
            isValidMove = true;
            break;
          }
        }
      }
    }
    if(isValidMove){
      Figure figure = Game.cells[y][x].figure;
      isMoving = true;
      if(figure instanceof King) println("CHECKMATE");
      futurePos = new PVector(x*Game.cellWidth,y*Game.cellWidth);
      println(futurePos);
      Game.isBlackTurn = -Game.isBlackTurn;
      TransferData [][] cells = new TransferData[Game.boardDimension][Game.boardDimension];
      for (int i = 0; i < Game.boardDimension; i++) {
        for(int j = 0; j < Game.boardDimension; j++){
          Figure tempFigure = Game.cells[i][j].figure;
          TransferData data = new TransferData();
          if(tempFigure == null){
            data.index = 0;
          }else{
            data.index = tempFigure.index;
            data.movesCounter = tempFigure.movesCounter;
            data.figureImage = tempFigure.figureImage;
            data.pos = new PVector(tempFigure.pos.x, tempFigure.pos.y);
            data.isBlack = tempFigure.isBlack;
          }
          cells[i][j] = data;
        }
      }
      
      Game.history.add(cells);
      
      Game.isBlocked = true;
      movesCounter++;
    } 
  }
  void stopMove(){
    isMoving = false;
    Game.isBlocked = false; 
    Game.enemyMoves = null;
    Game.refreshCounter = 0;
    sound = minim.loadFile("../recources/step.mp3");
    sound.play();
  }
  void render(){
    image(figureImage, pos.x, pos.y);   
  }
  
  PVector arrive(){
    println(futurePos);
    float arrivingRadius = 50;
    PVector desired = PVector.sub(futurePos, pos);
    float dist = desired.mag();
    desired.setMag(maxSpeed);
    
    if(dist <= arrivingRadius){ 
      desired.mult(dist/arrivingRadius);
    }
    if(dist <= 1){
      pos = futurePos;
      stopMove();
      return new PVector();
    }
    PVector steer = PVector.sub(desired,vel);
    steer.limit(maxForce);
    return steer;
  }
  void update(){
    
    //pos = futurePos.copy();
    //stopMove();
    
    // PHYSICS STUFF
    
    PVector steer = arrive();
    acc.add(steer);
    vel.add(acc);
    vel.limit(maxSpeed);
    pos.add(acc);
    acc.mult(0);
    vel.mult(0);    
  }
  boolean isNegativeCoords(PVector coords){
    if(coords.x < 0 || coords.x > Game.boardDimension-1 || coords.y < 0 || coords.y > Game.boardDimension-1){
      return true;
    }
    return false;
  }
  boolean isKing(Figure figure){
    return (figure instanceof King) ? true : false;
  }
}