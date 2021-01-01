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

boolean moving = false;
Piece movingPiece;
Node movingPiecePossibleMoves;

PImage PawnWhiteImg;
PImage RookWhiteImg;
PImage KnightWhiteImg;
PImage BishopWhiteImg;
PImage KingWhiteImg;
PImage QueenWhiteImg;

PImage PawnBlackImg;
PImage RookBlackImg;
PImage KnightBlackImg;
PImage BishopBlackImg;
PImage KingBlackImg;
PImage QueenBlackImg;

int board[] = new int[rows*cols];

// int[][] board = {
// 	{ - Rook.id, - Knight.id, - Bishop.id, - Queen.id, - King.id, - Bishop.id, - Knight.id, - Rook.id} ,
// 	{ - Pawn.id, - Pawn.id, - Pawn.id, - Pawn.id, - Pawn.id, - Pawn.id, - Pawn.id, - Pawn.id} ,
// 	{0, 0, 0, 0, 0, 0, 0, 0} ,
// 	{0, 0, 0, 0, 0, 0, 0, 0} ,
// 	{0, 0, 0, 0, 0, 0, 0, 0} ,
// 	{0, 0, 0, 0, 0, 0, 0, 0} ,
// 	{Pawn.id, Pawn.id, Pawn.id, Pawn.id, Pawn.id, Pawn.id, Pawn.id, Pawn.id} ,
// 	{Rook.id, Knight.id, Bishop.id, King.id, Queen.id, Bishop.id, Knight.id, Rook.id}
// };

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
	board = updateBoard(white, black);
	
	PawnWhiteImg = loadImage("data/pawnWhite.png");
	PawnBlackImg = loadImage("data/pawnBlack.png");
	
	RookWhiteImg = loadImage("data/rookWhite.png");
	RookBlackImg = loadImage("data/rookBlack.png");
	
	KnightWhiteImg = loadImage("data/knightWhite.png");
	KnightBlackImg = loadImage("data/knightBlack.png");
	
	BishopWhiteImg = loadImage("data/bishopWhite.png");
	BishopBlackImg = loadImage("data/bishopBlack.png");
	
	KingWhiteImg = loadImage("data/kingWhite.png");
	KingBlackImg = loadImage("data/kingBlack.png");
	
	QueenWhiteImg = loadImage("data/queenWhite.png");
	QueenBlackImg = loadImage("data/queenBlack.png");
}

public void draw() {
	for (int i = 0; i < rows; i++)
	{
		for (int j = 0; j < cols; j++) {
			if ((i + j) % 2 == 1) {
				fill(255);
			} else {
				fill(30);
			}
			rect(i * cellSize, j * cellSize, cellSize, cellSize);
		}
	}
	
	if (moving) {
		Node move = movingPiecePossibleMoves;
		while(move != null) {
			fill(0, 200, 0);
			ellipse(move.data.x * cellSize + cellSize / 2, move.data.y * cellSize + cellSize / 2, cellSize / 2, cellSize / 2);
			move = move.next;
		}
	}
	
	for (int i = 0; i < white.length; i++) {
		if (white[i] != null) {
			if (moving && movingPiece.i == white[i].i && movingPiece.j == white[i].j) {
				PImage img = movingPiece.getImg();
				image(img, mouseX - cellSize / 2, mouseY - cellSize / 2, cellSize * 1.2f, cellSize * 1.2f);
			} else {
				white[i].show();
			}
		}
	}
	
	for (int i = 0; i < black.length; i++) {
		if (black[i] != null) {
			black[i].show();
		}
	}
}

public int[] updateBoard(Piece[] p1, Piece[] p2) {
	int[] newBoard = new int[rows*cols];
	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j++) {
			newBoard[getIndex(i, j)] = 0;
		}
	}
	for (int i = 0; i < p1.length; i++) {
		if (p1[i] != null) {
			newBoard[getIndex(p1[i].i, p1[i].j)] = p1[i].id * p1[i].side;
		}
	}
	for (int i = 0; i < p2.length; i++) {
		if (p2[i] != null) {
			newBoard[getIndex(p2[i].i, p2[i].j)] = p2[i].id * p2[i].side;
		}
	}
	return newBoard;
}

public void mousePressed() {
	int i = floor(mouseX / cellSize);
	int j = floor(mouseY / cellSize);
	
	boolean valid = false;
	Piece piece = null;
	
	for (int k = 0; k < white.length; k++) {
		if (white[k] != null) {
			if (white[k].i == i && white[k].j == j) {
				valid = true;
				piece = white[k];
				break;
			}
		}
	}
	
	if (valid) {
		moving = true;
		movingPiece = piece;
		movingPiecePossibleMoves = piece.getPossibleMoves(board);
	}
}

public void mouseReleased() {
	moving = false;
	int i = floor(mouseX / cellSize);
	int j = floor(mouseY / cellSize);
	
	boolean valid = false;
	Node move = movingPiecePossibleMoves;
	while(move != null) {
		if (move.data.x == i && move.data.y == j) {
			valid = true;
			movingPiece.firstMove = false;
			break;
		}
		move = move.next;
	}
	
	if (inRange(i) && inRange(j) && valid) {
		if (board[getIndex(i, j)] < 0) {
			Piece piece = null;
			for (int k = 0; k <  black.length; k++) {
				if (black[k] != null) {
					if (black[k].i == i && black[k].j == j) {
						black[k] = null;
						// piece = black[i];
					}
				}
			}
			board[getIndex(i, j)] = 0;
			movingPiece.i = i;
			movingPiece.j = j;
		} else if (board[getIndex(i, j)] == 0) {
			movingPiece.i = i;
			movingPiece.j = j;
		}
	}
	board = updateBoard(white, black);
}

public boolean inRange(int num) {
	return num > - 1 && num < 8;
}

public int getIndex(int i, int j) {
	return i * rows + j;
}
public class Bishop extends Piece {
	
	final static int value = 200;
	final static int id = 4;
	
	public Bishop(int i, int j, int side) {
		super(i, j, side);
	}
	
	public void show() {
		PImage img;
		if (side == 1) {
			img = BishopWhiteImg;
		} else {
			img = BishopBlackImg;
		}
		image(img, i * cellSize, j * cellSize, cellSize, cellSize);
	}
	
	public PImage getImg() {
		PImage img;
		if (side == 1) {
			img = BishopWhiteImg;
		} else {
			img = BishopBlackImg;
		}
		return img;
	}
}
class King extends Piece {
	
	final static int value = 1000;
	final static int id = 6;
	
	public King(int i, int j, int side) {
		super(i, j, side);
	}
	
	public void show() {
		PImage img;
		if (side == 1) {
			img = KingWhiteImg;
		} else {
			img = KingBlackImg;
		}
		image(img, i * cellSize, j * cellSize, cellSize, cellSize);
	}
	
	
	public PImage getImg() {
		PImage img;
		if (side == 1) {
			img = KingWhiteImg;
		} else {
			img = KingBlackImg;
		}
		return img;
	}
}
public class Knight extends Piece {
	
	final static int value = 200;
	final static int id = 3;
	
	public Knight(int i, int j, int side) {
		super(i, j, side);
	}
	
	public void show() {
		PImage img;
		if (side == 1) {
			img = KnightWhiteImg;
		} else {
			img = KnightBlackImg;
		}
		image(img, i * cellSize, j * cellSize, cellSize, cellSize);
	}

	public Node getPossibleMoves(int[] board) {
		Node first = new Node(null);
		Node current = first;
		for (int a = -1; a < 2; a += 2) {
			for (int b = -1; b < 2; b += 2) {
				if (inRange(i + a * 2) && inRange(j + b)) {
					if (board[getIndex(i + a * 2, j + b)] * side < 1) {
						current = current.add(new PVector(i + a * 2, j + b));
					}
				}
				if (inRange(i + a) && inRange(j + b * 2)) {
					if (board[getIndex(i + a, j + b * 2)] * side < 1) {
						current = current.add(new PVector(i + a, j + b * 2));
					}
				}
			}
		}
		if (first.data == null) {
			return null;
		}
		return first;
	}
	
	public PImage getImg() {
		PImage img;
		if (side == 1) {
			img = KnightWhiteImg;
		} else {
			img = KnightBlackImg;
		}
		return img;
	}
}
public class Node {
	
	PVector data;
	Node next;
	
	public Node(PVector data) {
		this.data = data;
		next = null;
	}
	
	public Node add(PVector n) {
		if (data == null) {
			data = n;
			return this;
		}
		next = new Node(n);
		return next;
	}
}
public class Pawn extends Piece {
	
	final static int value = 100;
	final static int id = 1;
	
	public Pawn(int i, int j, int side) {
		super(i, j, side);
	}
	
	public void show() {
		PImage img;
		if (side == 1) {
			img = PawnWhiteImg;
		} else {
			img = PawnBlackImg;
		}
		image(img, i * cellSize, j * cellSize, cellSize, cellSize);
	}
	
	public Node getPossibleMoves(int[] board) {
		Node first = new Node(null);
		Node current = first;
		if (inRange(j - side)) {
			if (board[getIndex(i, j - side)] == 0) {
				current = current.add(new PVector(i, j - side));
			}
		}
		if (inRange(j - side * 2) && firstMove) {
			if (board[getIndex(i, j - side * 2)] == 0) {
				current = current.add(new PVector(i, j - side * 2));
			}
		}
		for (int k = - 1; k < 2; k += 2) {
			if (inRange(i + k) && inRange(j - side)) {
				if (board[getIndex(i + k, j - side)] * side < 0) {
					current = current.add(new PVector(i + k, j - side));
				}
			}
		}
		if (first.data == null) {
			return null;
		}
		return first;
	}
	
	public PImage getImg() {
		PImage img;
		if (side == 1) {
			img = PawnWhiteImg;
		} else {
			img = PawnBlackImg;
		}
		return img;
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
	
	boolean firstMove = true;
	
	public Piece(int i, int j, int side) {
		this.i = i;
		this.j = j;
		this.side = side;
	}
	
	public Node getPossibleMoves(int[] board) {
		return new Node(new PVector(i, j - 1));
	}
	
	public void show() {
		
	}
	
	public PImage getImg() {
		return BishopWhiteImg;
	}
	
}
class Queen extends Piece {
	
	final static int value = 500;
	final static int id = 5;
	
	public Queen(int i, int j, int side) {
		super(i, j, side);
	}
	
	public void show() {
		PImage img;
		if (side == 1) {
			img = QueenWhiteImg;
		} else {
			img = QueenBlackImg;
		}
		image(img, i * cellSize, j * cellSize, cellSize, cellSize);
	}
	
	public PImage getImg() {
		PImage img;
		if (side == 1) {
			img = QueenWhiteImg;
		} else {
			img = QueenBlackImg;
		}
		return img;
	}
}
public class Rook extends Piece {
	
	final static int value = 300;
	final static int id = 2;
	
	public Rook(int i, int j, int side) {
		super(i, j, side);
	}
	
	public void show() {
		PImage img;
		if (side == 1) {
			img = RookWhiteImg;
		} else {
			img = RookBlackImg;
		}
		image(img, i * cellSize, j * cellSize, cellSize, cellSize);
	}

	public Node getPossibleMoves(int[] board) {
		Node first = new Node(null);
		Node current = first;
		for (int k = -1; k < 2; k += 2) {
			int move = 1;
			while (inRange(i + k * move)) {
				if (board[getIndex(i + k * move, j)] * side > 0) {
					break;
				}
				current = current.add(new PVector(i + k * move, j));
				if (board[getIndex(i + k * move, j)] * side < 0) {
					break;
				}
				move += 1;
			}
			move = 1;
			while (inRange(j + k * move)) {
				if (board[getIndex(i , j + k * move)] * side > 0) {
					break;
				}
				current = current.add(new PVector(i, j + k * move));
				if (board[getIndex(i , j + k * move)] * side < 0) {
					break;
				}
				move += 1;
			}
		}
		if (first.data == null) {
			return null;
		}
		return first;
	}
	
	public PImage getImg() {
		PImage img;
		if (side == 1) {
			img = RookWhiteImg;
		} else {
			img = RookBlackImg;
		}
		return img;
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
