class Pawn extends Figure{
  Pawn(int isBlack){
    super(isBlack);
  }
  
  PVector[] getPossibleMovesImp(){
    ArrayList<PVector> moves = new ArrayList();
    int i = floor(pos.y/Game.cellWidth);
    int j = floor(pos.x/Game.cellWidth);
    
    int [] presets = {
      i-1, j-1,
      i-1, j+1,
      i-1, j,
      i-2, j
    };
    int plength = presets.length;
    if(this.isBlack == -1){
      for(int k = 0; k < plength; k+=2)
        presets[k] = abs(presets[k]) + 2;
    }
    
    // DIAGONAL CELLS
    Figure figure;
    for(int k = 0; k < 2; k++){
      PVector coords = new PVector(presets[k*2], presets[k*2+1],1); 
      if(isNegativeCoords(coords)){
        coords.z = 0;
        moves.add(coords);
      }
      else{
        figure = Game.cells[(int)coords.x][(int)coords.y].figure;
        if(figure != null){
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
            continue; 
          }
        }else{
          coords.z = 0;
          moves.add(coords);
        }
      }
    }
    
    if(movesCounter == 0){
      for(int k = 4; k < presets.length; k+=2){
        PVector coords = new PVector(presets[k], presets[k+1],1);
        if(isNegativeCoords(coords)) 
          break; 
        else{
          figure = Game.cells[(int)coords.x][(int)coords.y].figure;
          if(figure == null)
            moves.add(coords);
          else 
            break; 
        }
      }
    }else{
      PVector coords = new PVector(presets[4], presets[5],1);
      if(!isNegativeCoords(coords)){
        figure = Game.cells[(int)coords.x][(int)coords.y].figure;
        if(figure == null) 
          moves.add(coords); 
      }
    }

    println(moves);
    return moves.toArray(new PVector[moves.size()]);
  }
  String toString(){
    return "PAWN"; 
  }
}