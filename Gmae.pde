static class Game{
  static ArrayList<TransferData[][]> history = new ArrayList();
  static StringDict enemyMoves = null;
  static boolean isBlackKingUnderCheck = false;
  static boolean isWhiteKingUnderCheck = false;
  static int refreshCounter = 0;
  static int boardDimension = 8;
  static String [] chessNames = {"king", "queen", "bishop", "rook", "horse", "pawn"};
  static ArrayList<PImage> whiteFigures;
  static ArrayList<PImage> blackFigures;
  
  static int cellWidth;
  static float imageSize;
  static float imageOffset;
  static int isBlackTurn = 1;
  static boolean isBlocked = false;
  //FLAG FOR BLOCKING TILL THE FIGURE IS MOVING THROUGH THE BOARD
  static PVector lastSelectedCell = null;
  static PVector newSelectedCell = new PVector();
  
  static BoardCell[][] cells = new BoardCell[boardDimension][boardDimension];
  static int [][] board = {
    {-4,-5,-3,-1,-2,-3,-5,-4},
    {-6,-6,-6,-6,-6,-6,-6,-6},
    {0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0},
    {0,0,0,0,0,0,0,0},
    {6,6,6,6,6,6,6,6},
    {4,5,3,1,2,3,5,4}
  };
    
}