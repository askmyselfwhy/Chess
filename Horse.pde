class Horse extends Figure{
  Horse(int isBlack){
    super(isBlack);
  }
  PVector[] getPossibleMovesImp(){
    this.possibleMoves = null;
    ArrayList<PVector> moves = new ArrayList();
    int i = floor(pos.y/Game.cellWidth);
    int j = floor(pos.x/Game.cellWidth);
    // THERE ARE ONLY 8 MOVES AND THEY'RE EQUAL TO WHITES AND BLACKS
    int [] presets = {
      // MOVE ON THE TOP
      i-2, j+1,
      i-2, j-1,
      // MOVE ON THE LEFT
      i-1, j-2,
      i+1, j-2,
      // MOVE ON THE BOTTOM
      i+2, j-1,
      i+2, j+1,
      // MOVE ON THE RIGHT
      i-1, j+2,
      i+1, j+2
    };
    
    for(int k = 0; k < presets.length; k+=2){
      PVector coords = new PVector(presets[k], presets[k+1],1);
      // IF COORDINATES HAVE NEGATIVE VALUES
      if(isNegativeCoords(coords)){
        continue;
      }
      Figure figure = Game.cells[(int)coords.x][(int)coords.y].figure;
      // IF IN THE POSSIBLE THERE IS A FIGURE
      if(figure != null){
        // IF THE FIGURES HAVE THE SAME COLOR U CAN'T MOVE
        if(figure.isBlack != this.isBlack){
          if(isKing(figure)){
            if(this.isBlack == -1){
              Game.isBlackKingUnderCheck = true;
            }else{
              Game.isWhiteKingUnderCheck = true;
            }
            println("CHECK");
          }
          moves.add(coords);
        }else{
          coords.z = 0;
          moves.add(coords); 
        }
      }else{
        moves.add(coords); 
      }
    }
    return moves.toArray(new PVector[moves.size()]);
  }
  String toString(){
    return "HORSE"; 
  }
}