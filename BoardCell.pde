class BoardCell{
  int i;
  int j;
  Figure figure;
  BoardCell(Figure figure){
    this.figure = figure;
  }
  BoardCell(){
    figure = null;
  }
  boolean isEmpty(){
    return (figure == null) ? true : false; 
  }
  void clearCell(){
    figure = null; 
  }
}