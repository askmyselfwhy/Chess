class Rook extends Figure{
  Rook(int isBlack){
    super(isBlack);
  }
  PVector[] getPossibleMovesImp(){
    ArrayList<PVector> moves = new ArrayList();
    int i = floor(pos.y/Game.cellWidth);
    int j = floor(pos.x/Game.cellWidth);
    
    // TRAVERSING THROUGH THE ALL 4 SIDES 
    for(int k = 0; k < 2; k++){
      Figure figure;
      int c = 1;
      do{
        PVector coords = new PVector(0,0,1);
        float tempI = i + c * pow(-1, k + 1);
        coords.x = tempI;
        coords.y = j;
        if(isNegativeCoords(coords)){
          break; 
        }else{
          figure = Game.cells[(int)tempI][j].figure;
          if(figure != null){
            if(figure.isBlack == this.isBlack){
              coords.z = 0;
              moves.add(coords);
              break; 
            }else{
              moves.add(coords);
              if(isKing(figure)){
                if(this.isBlack == -1){
                  Game.isBlackKingUnderCheck = true;
                }else{
                  Game.isWhiteKingUnderCheck = true;
                }
                println("CHECK");
                c++;
                tempI = i + c * pow(-1, k + 1);
                coords.x = tempI;
                coords.y = j;
                if(isNegativeCoords(coords)){
                  break; 
                }else{
                  coords.z = 0;
                  moves.add(coords);
                }
              }
              break;
            }
          }else{
            moves.add(coords);
            c++;
          }
        }
      }while(true);
      
      c = 1;
      do{
        PVector coords = new PVector(0,0,1);
        float tempJ = j + c * pow(-1, k + 1);
        coords.x = i;
        coords.y = tempJ;
        if(isNegativeCoords(coords)){
          break; 
        }else{
          figure = Game.cells[i][(int)tempJ].figure;
          if(figure != null){
            if(figure.isBlack == this.isBlack){
              coords.z = 0;
              moves.add(coords);
              break; 
            }else{
              moves.add(coords);
              if(isKing(figure)){
                if(this.isBlack == -1){
                  Game.isBlackKingUnderCheck = true;
                }else{
                  Game.isWhiteKingUnderCheck = true;
                }
                c++;
                tempJ = j + c * pow(-1, k + 1);
                coords.x = i;
                coords.y = tempJ;
                if(isNegativeCoords(coords)){
                  break; 
                }else{
                  coords.z = 0;
                  moves.add(coords);
                }
                println("CHECK");
              }
              break;
            }
          }else{
            moves.add(coords);
            c++;
          }
        }
      }while(true);
    }
    return moves.toArray(new PVector[moves.size()]);
  }
  String toString(){
    return "ROOK"; 
  }
}