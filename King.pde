class King extends Figure{
  King(int isBlack){
    super(isBlack);
  }
  PVector[] getPossibleMovesImp(){
    ArrayList<PVector> moves = new ArrayList();
    int i = floor(pos.y/Game.cellWidth);
    int j = floor(pos.x/Game.cellWidth);
    Figure figure;
    for(int k = -1; k <= 1; k++){
      for(int g = -1; g <= 1; g++){
        PVector coords = new PVector(0,0,1);
        
        int tempI = i + k;
        int tempJ = j + g;
        coords.x = tempI;
        coords.y = tempJ;
        if(isNegativeCoords(coords)){
          continue; 
        }else{
          figure = Game.cells[tempI][tempJ].figure;
          if(figure != null){
            if(figure.isBlack != this.isBlack){
             moves.add(coords);
            }else{
              continue; 
            }
          }else{
            moves.add(coords);
          }
        }
      }
    }
    
    //IF THE KING UNDER THE CHECK FIND POSSIBLE MOVES
    // U CAN'T GO TO THE CELL, THAT ARE UNDER THE POSSIBLE MOVE OF THE ENEMY FIGURES
    HashSet<String> kingMoves = new HashSet();
    HashSet<String> enemyMoves = new HashSet();
    HashSet<String> alliesMoves = new HashSet();
    // FILLING FIRST SET 
    for(PVector move : moves){
      kingMoves.add(move.x + "," + move.y); 
    }
    moves = null;
    for(int k = 0; k < Game.boardDimension; k++){
      for(int g = 0; g < Game.boardDimension; g++){
        Figure cellFigure = Game.cells[k][g].figure;
        // IF THE CELL IS EMPTY WE SKIP IT
        // FOR NOW WE'RE SKIPPING THE KING, BUT I WILL FIX THIS LATER
        if(cellFigure == null || cellFigure instanceof King){
          continue;
        }
        if(cellFigure instanceof Pawn){
          // FORMING TWO SETS OF ALLIES MOVES AND ENEMY MOVES
          PVector [] figureMoves = cellFigure.getPossibleMoves();
          if(cellFigure.isBlack == this.isBlack){
            for(int p = 2; p < figureMoves.length; p++){
              PVector move = figureMoves[p];
              alliesMoves.add(move.x +"," + move.y);
            }
          }else{
            for(int p = 0; p < 2; p++){
              PVector move = figureMoves[p];
              if(!isNegativeCoords(move)){
                enemyMoves.add(move.x +"," + move.y);
              }
            }
          }          
        }else{
          // FORMING TWO SETS OF ALLIES MOVES AND ENEMY MOVES
          PVector [] figureMoves = cellFigure.getPossibleMoves();
          if(cellFigure.isBlack == this.isBlack){
            for(int p = 0; p < figureMoves.length; p++){
              PVector move = figureMoves[p];
              alliesMoves.add(move.x +"," + move.y);
            }
          }else{
            for(int p = 0; p < figureMoves.length; p++){
              PVector move = figureMoves[p];
              enemyMoves.add(move.x +"," + move.y);
            }
          }
        }
      }
    }
    Iterator<String> iter = kingMoves.iterator();
    // THIS SET CONTAITNS ALL ALLIES POSSIBLE MOVES TO PROTECT THE KING FROM DYING
    HashSet<String> intersectionWithAllies = new HashSet();
    // THIS SET CONTAINS ALL KING'S POSSIBLE MOVES WITH CONDITION OF ENEMIES KNOWN MOVES
    HashSet<String> differenceWithEnemies = new HashSet();
    while(iter.hasNext()){
      String next = iter.next();
      if(alliesMoves.contains(next)){
        intersectionWithAllies.add(next); 
      }
      if(!enemyMoves.contains(next)){
        differenceWithEnemies.add(next); 
      }
    }
    moves = new ArrayList();
    for(String str : differenceWithEnemies){
      String [] subStr = str.split(",");
      PVector coords = new PVector(parseFloat(subStr[0]),parseFloat(subStr[1]), 1);
      moves.add(coords);
    }
    if(intersectionWithAllies.size() == 0 && differenceWithEnemies.size() == 0){
      println("CHECKMATE");
      return new PVector[0];
    }
    println(moves);
    return moves.toArray(new PVector[moves.size()]);
  }
  String toString(){
    return "KING"; 
  }
}