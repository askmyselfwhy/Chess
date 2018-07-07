class FigureFactory{
  Figure makeFigure(int index, int isBlack){
    switch(index){
      case 0:
        return new King(isBlack);
      case 1:
        return new Queen(isBlack);
      case 2:
        return new Bishop(isBlack);
      case 3:
        return new Rook(isBlack);
      case 4:
        return new Horse(isBlack);
      case 5:
        return new Pawn(isBlack);
      default: return null; 
    }
  }
}