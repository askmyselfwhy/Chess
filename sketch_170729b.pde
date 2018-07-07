import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.effects.*;
import ddf.minim.signals.*;
import ddf.minim.spi.*;
import ddf.minim.ugens.*;

import java.util.*;

Minim minim;
AudioPlayer sound;

class TransferData{
  int index;
  int movesCounter;
  PImage figureImage;
  PVector pos;
  int isBlack;
  TransferData(){
     figureImage = new PImage();
     pos = new PVector();
  }
}

void loadFiles(){
  for(int i = 0; i < Game.chessNames.length; i++){
    String nameW = Game.chessNames[i];
    String nameB = Game.chessNames[i];
    PImage imageW = loadImage("recources/" + nameW + "_w.png");
    PImage imageB = loadImage("recources/" + nameB + "_b.png");
    Game.whiteFigures.add(imageW);
    Game.blackFigures.add(imageB);
  }
  Game.imageSize = Game.whiteFigures.get(0).width;
}

void initBoard(){
  FigureFactory ff = new FigureFactory();
  for(int i = 0; i < Game.boardDimension; i++){
    for(int j = 0; j < Game.boardDimension; j++){
      int index = Game.board[i][j];
      int tempIndex = index;
      // BLACK
      if(index < 0){
        index = -index - 1;
        Figure figure = ff.makeFigure(index, -1);
        figure.pos = new PVector(j * Game.cellWidth,i * Game.cellWidth);
        figure.figureImage = Game.blackFigures.get(index);
        figure.index = tempIndex;
        Game.cells[i][j] = new BoardCell(figure);
      }
      // WHITE
      else if(index > 0){
        index -= 1;
        Figure figure = ff.makeFigure(index, 1);
        figure.pos = new PVector(j * Game.cellWidth,i * Game.cellWidth);
        figure.figureImage = Game.whiteFigures.get(index);
        figure.index = tempIndex;
        Game.cells[i][j] = new BoardCell(figure);
      }
      // EMPTY CELLS
      else{
        Game.cells[i][j] = new BoardCell();
      }
    }
  }
}

void setup(){
  size(500, 500);
  
  minim = new Minim(this);
  sound = minim.loadFile("../recources/step.mp3");
  Game.cellWidth = (width)/Game.boardDimension;
  Game.imageOffset = (Game.cellWidth-Game.imageSize)/2;
  
  Game.whiteFigures = new ArrayList();
  Game.blackFigures = new ArrayList();
  
  loadFiles();
  initBoard();
}


void draw(){
  background(255);
  stroke(0);
  strokeWeight(1);
  
  // DRAWING CHESS GRID
  for(int i = 0; i < Game.boardDimension; i++){
    for(int j = 0; j < Game.boardDimension; j++){
      if((i + j) % 2 != 0) fill(0);
      else fill(255); 
      rect(j*Game.cellWidth,i*Game.cellWidth,Game.cellWidth,Game.cellWidth);
    }
  }
    
  for(int i = 0; i < Game.boardDimension; i++){
    for(int j = 0; j < Game.boardDimension; j++){
      // DRAWING CHESS FIGURES
      Figure figure = Game.cells[i][j].figure;
      if(figure != null){
        if(figure.isMoving){
          figure.update();
          if(!figure.isMoving){
            Game.cells[(int)Game.newSelectedCell.y][(int)Game.newSelectedCell.x].figure = Game.cells[(int)Game.lastSelectedCell.y][(int)Game.lastSelectedCell.x].figure;
            Game.cells[(int)Game.lastSelectedCell.y][(int)Game.lastSelectedCell.x].clearCell();
            //println( Game.cells[(int)Game.newSelectedCell.y][(int)Game.newSelectedCell.x].figure);
            //println( Game.cells[(int)Game.lastSelectedCell.y][(int)Game.lastSelectedCell.x].figure);
            Game.lastSelectedCell = null;
            Game.newSelectedCell = null;
          }
        }
        figure.render();
      }
    }
  }
  
  
  // SHOWING POSSIBLE MOVEMENTS FOR SELECTED FIGURE IF FIGURE IS NOT MOVING
  if(!Game.isBlocked){
    noFill();
    stroke(255,0,0);
    strokeWeight(3);
    if(Game.lastSelectedCell != null && Game.cells[(int)Game.lastSelectedCell.y][(int)Game.lastSelectedCell.x].figure != null){
      rect(Game.lastSelectedCell.x*Game.cellWidth, Game.lastSelectedCell.y*Game.cellWidth,Game.cellWidth,Game.cellWidth);
      Figure selectedFigure = Game.cells[(int)Game.lastSelectedCell.y][(int)Game.lastSelectedCell.x].figure;
      selectedFigure.showMoves();
    }
  }
  fill(0,255,0);
  textSize(25);
  text((Game.isBlackTurn == -1) ? "BLACK TURN" : "WHITE TURN", 0, 50);
}

void keyPressed(KeyEvent e){
  FigureFactory ff = new FigureFactory();
  println(keyCode);
  if(keyCode == 66){
    if(Game.history.size() > 0){
      TransferData[][] history = Game.history.get(Game.history.size()-1);
      Game.history.remove(Game.history.size()-1);
      for(int i = 0; i < Game.boardDimension; i++){
        for(int j = 0; j < Game.boardDimension; j++){
          TransferData data = history[i][j];
          print(data.index);
          int currentIndex = data.index;
          int index = currentIndex;
          
          if(currentIndex < 0){
            currentIndex = -currentIndex - 1;
            Figure finalFigure = ff.makeFigure(currentIndex, -1);
            finalFigure.pos = new PVector(data.pos.x,data.pos.y);
            finalFigure.figureImage = data.figureImage;
            finalFigure.index = index;
            finalFigure.movesCounter = data.movesCounter;
            Game.cells[i][j] = new BoardCell(finalFigure);
          }
          // WHITE
          else if(currentIndex > 0){
            currentIndex -= 1;
            Figure finalFigure = ff.makeFigure(currentIndex, 1);
            finalFigure.pos = new PVector(data.pos.x,data.pos.y);
            finalFigure.figureImage = data.figureImage;
            finalFigure.index = index;
            finalFigure.movesCounter = data.movesCounter;
            Game.cells[i][j] = new BoardCell(finalFigure);
          }
          // EMPTY CELLS
          else{
            Game.cells[i][j] = new BoardCell();
          }
        }
        println();
      }
      Game.isBlackTurn = -Game.isBlackTurn;
    }
  }
  
}

void mousePressed(MouseEvent e){
  if(!Game.isBlocked){
    int button = e.getButton();
    int x = floor(mouseX/Game.cellWidth);
    int y = floor(mouseY/Game.cellWidth);
    if(x < 0 || x >= Game.boardDimension || y < 0 || y >= Game.boardDimension){
      return; 
    }
    if(Game.lastSelectedCell == null){
      if(Game.cells[y][x].figure == null){
        return; 
      }
      if(Game.cells[y][x].figure.isBlack == Game.isBlackTurn){
        if(Game.cells[y][x].figure != null){
          Game.lastSelectedCell = new PVector(x,y);
        }
      }
    }
    else{
      if(button == 39){
        Game.newSelectedCell = new PVector();
        Figure figure = Game.cells[(int)Game.lastSelectedCell.y][(int)Game.lastSelectedCell.x].figure;
        figure.move(x,y);
        Game.newSelectedCell.x = x;
        Game.newSelectedCell.y = y;
        return;
      }
      if(Game.cells[y][x].figure == null){
        Game.lastSelectedCell = null;
        return;
      }
      if(Game.cells[y][x].figure.isBlack == Game.isBlackTurn){
        if(button == 37){
          Game.lastSelectedCell.x = x;
          Game.lastSelectedCell.y = y;
          Game.refreshCounter = 0;
        }
      }
    }
  }
}