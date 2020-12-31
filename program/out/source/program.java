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

int[][] board = {
	{ - Rook.id, - Knight.id, - Bishop.id, - Queen.id, - King.id, - Bishop.id, - Knight.id, - Rook.id} ,
	{ - Pawn.id, - Pawn.id, - Pawn.id, - Pawn.id, - Pawn.id, - Pawn.id, - Pawn.id, - Pawn.id} ,
	{0, 0, 0, 0, 0, 0, 0, 0} ,
	{0, 0, 0, 0, 0, 0, 0, 0} ,
	{0, 0, 0, 0, 0, 0, 0, 0} ,
	{0, 0, 0, 0, 0, 0, 0, 0} ,
	{Pawn.id, Pawn.id, Pawn.id, Pawn.id, Pawn.id, Pawn.id, Pawn.id, Pawn.id} ,
	{Rook.id, Knight.id, Bishop.id, King.id, Queen.id, Bishop.id, Knight.id, Rook.id}
};

Piece[] white = {
	new Pawn(0, 6, 1), new Pawn(1, 6, 1), new Pawn(2, 6, 1), new Pawn(3, 6, 1), new Pawn(4, 6, 1), new Pawn(5, 6, 1), new Pawn(6, 6, 1), new Pawn(7, 6, 1),
		new Rook(0, 7, 1), new Knight(1, 7, 1),  new Bishop(2, 7, 1), new King(3, 7, 1), new Queen(4, 7, 1), new Bishop(5, 7, 1), new Knight(6, 7, 1), new Rook(7, 7, 1)
	};

Piece[] black = {
	new Rook(0, 0, - 1), new Knight(1, 0, - 1),  new Bishop(2, 0, - 1), new Queen(3, 0, - 1), new King(4, 0, - 1), new Bishop(5, 0, - 1), new Knight(6, 0, - 1), new Rook(7, 0, - 1),
		new Pawn(0, 1, - 1), new Pawn(1, 1, - 1), new Pawn(2, 1, - 1), new Pawn(3, 1, - 1), new Pawn(4, 1, - 1), new Pawn(5, 1, - 1), new Pawn(6, 1, - 1), new Pawn(7, 1, - 1),
	};

public void setup() {
	
	cellSize = width / rows;
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
	for (int i = 0; i < white.length; i++) {
		white[i].show();
	}
	for (int i = 0; i < black.length; i++) {
		black[i].show();
	}
}
public class Bishop extends Piece {
	
	final static int value = 200;
	final static int id = 4;
	
	public Bishop(int i, int j, int side) {
		super(i, j, side);
	}
	
	public void show() {
		strokeWeight(8);
		if (side == 1) {
			fill(255);
			stroke(0);
		} else {
			fill(0);
			stroke(255);
		}
		textSize(30);
		text("B",((float)i + 0.5f) * cellSize,((float)j + 0.5f) * cellSize);
	}
}
class King extends Piece {
	
	final static int value = 1000;
	final static int id = 6;
	
	public King(int i, int j, int side) {
		super(i, j, side);
	}
	
	public void show() {
		strokeWeight(8);
		if (side == 1) {
			fill(255);
			stroke(0);
		} else {
			fill(0);
			stroke(255);
		}
		textSize(30);
		text("K",((float)i + 0.5f) * cellSize,((float)j + 0.5f) * cellSize);
	}
}
public class Knight extends Piece {
	
	final static int value = 200;
	final static int id = 3;
	
	public Knight(int i, int j, int side) {
		super(i, j, side);
	}
	
	public void show() {
		strokeWeight(8);
		if (side == 1) {
			fill(255);
			stroke(0);
		} else {
			fill(0);
			stroke(255);
		}
		textSize(30);
		text("Kn",((float)i + 0.5f) * cellSize,((float)j + 0.5f) * cellSize);
	}
}
public class Node {
	
	Piece data;
	Node next;
	
	public Node(Piece data) {
		this.data = data;
		next = null;
	}
	
	public void add(Piece n) {
		next = new Node(n);
	}
}
public class Pawn extends Piece {
	
	final static int value = 100;
	final static int id = 1;
	
	public Pawn(int i, int j, int side) {
		super(i, j, side);
	}
	
	public void show() {
		strokeWeight(8);
		if (side == 1) {
			fill(255);
			stroke(0);
		} else {
			fill(0);
			stroke(255);
		}
		textSize(30);
		text("P",((float)i + 0.5f) * cellSize,((float)j + 0.5f) * cellSize);
	}
}
public class Piece {
	
	// 1 = white
	// -1 = black
	int side = 1;
	
	final static int value = 100;
	final static int id = 1;
	
	int i;
	int j;
	
	public Piece(int i, int j, int side) {
		this.i = i;
		this.j = j;
		this.side = side;
	}
	
	public void show() {
		
	}
	
}
class Queen extends Piece {
	
	final static int value = 500;
	final static int id = 5;
	
	public Queen(int i, int j, int side) {
		super(i, j, side);
	}
	
	public void show() {
		strokeWeight(8);
		if (side == 1) {
			fill(255);
			stroke(0);
		} else {
			fill(0);
			stroke(255);
		}
		textSize(30);
		text("Q",((float)i + 0.5f) * cellSize,((float)j + 0.5f) * cellSize);
	}
}
public class Rook extends Piece {
	
	final static int value = 300;
	final static int id = 2;
	
	public Rook(int i, int j, int side) {
		super(i, j, side);
	}
	
	public void show() {
		strokeWeight(8);
		if (side == 1) {
			fill(255);
			stroke(0);
		} else {
			fill(0);
			stroke(255);
		}
		ellipse(((float)i + 0.5f) * cellSize,((float)j + 0.5f) * cellSize, cellSize, cellSize);
		// textSize(30);
		// text("R",((float)i + 0.5) * cellSize,((float)j + 0.5) * cellSize);
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
