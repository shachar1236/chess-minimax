import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.HashMap; 
import java.util.ArrayList; 
import java.io.File; 
import java.io.BufferedReader; 
import java.io.PrintWriter; 
import java.io.InputStream; 
import java.io.OutputStream; 
import java.io.IOException; 

public class program extends PApplet {


final int rows = 8;
final int cols = 8;

int cellSize; 

Piece[][] board = new Piece[8][8];

public void setup() {
	
	cellSize = width / rows;
	for (int i = 0; i < rows; i++)
	{
		for (int j = 0; j < cols; j++) {
			board[i][j] = null;
		}
	}
}

public void draw() {
	for (int i = 0; i < rows; i++)
	{
		for (int j = 0; j < cols; j++) {
			if ((i + j) % 2 == 1) {
				fill(255);
			} else {
				fill(0);
			}
			rect(i * cellSize, j * cellSize, cellSize, cellSize);
		}
	}
}
public class Bishop extends Piece {
    int value = 200;

    public Piece(int i, int j) {
        this.i = i;
        this.j = j;
    }
}
class King extends Piece {
	int value = 1000;

	public King(int i, int j) {
		this.i = i;
		this.j = j;
	}
}
public class Knight extends Piece {
    int value = 200;

    public Knight(int i, int j) {
        this.i = i;
        this.j = j;
    }
}
public class Pawn extends Piece {
    int value = 100;

    public Pawn(int i, int j) {
        this.i = i;
        this.j = j;
    }
}
public class Piece {
  int value = 100;
  
  int i;
  int j;
  
  public Piece(int i, int j) {
    this.i = i;
    this.j = j;
  }
  
  public void show() {
    
  }
 
}
class Queen extends Piece {
    int value = 500;

    public Queen(int i, int j) {
        this.i = i;
        this.j = j;
    }
}
public class Rook extends Piece {
    int value = 300;
    
    public Rook(int i, int j) {
        this.i = i;
        this.j = j;
    }
}
  public void settings() { 	size(800, 800); }
  static public void main(String[] passedArgs) {
    String[] appletArgs = new String[] { "program" };
    if (passedArgs != null) {
      PApplet.main(concat(appletArgs, passedArgs));
    } else {
      PApplet.main(appletArgs);
    }
  }
}
