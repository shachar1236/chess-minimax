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

boolean promoting = false;

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
			ellipse(move.data.i * cellSize + cellSize / 2, move.data.j * cellSize + cellSize / 2, cellSize / 2, cellSize / 2);
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
	if (promoting) {
		fill(200, 20, 20);
		textSize(40);
		text("Promote Pawn", width / 2 - 135, 300);
		textSize(30);
		text("Press promotion number", width / 2 - 195, 350);
		text("1 - Queen", width / 2 - 115, 400);
		text("2 - Knight", width / 2 - 115, 450);
		text("3 - Bishop", width / 2 - 115, 500);
		text("4 - Rook", width / 2 - 115, 550);
	}
}

public int[] updateBoard(Piece[] p1, Piece[] p2) {
	int[] newBoard = new int[rows*cols];
	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j++) {
			// if (board[getIndex(i, j)] != Pawn.EnPassant) {
			newBoard[getIndex(i, j)] = 0;
			// }
		}
	}
	for (int i = 0; i < p1.length; i++) {
		if (p1[i] != null) {
			newBoard[getIndex(p1[i].i, p1[i].j)] = p1[i].getId() * p1[i].side;
		}
	}
	for (int i = 0; i < p2.length; i++) {
		if (p2[i] != null) {
			newBoard[getIndex(p2[i].i, p2[i].j)] = p2[i].getId() * p2[i].side;
		}
	}
	return newBoard;
}

public void mousePressed() {
	if (!promoting) {
		Piece[] playerPieces = white;

		int i = floor(mouseX / cellSize);
		int j = floor(mouseY / cellSize);
		
		boolean valid = false;
		Piece piece = null;
		
		for (int k = 0; k < playerPieces.length; k++) {
			if (playerPieces[k] != null) {
				if (playerPieces[k].i == i && playerPieces[k].j == j) {
					valid = true;
					piece = playerPieces[k];
					break;
				}
			}
		}
		
		if (valid) {
			moving = true;
			movingPiece = piece;
			movingPiecePossibleMoves = piece.getPossibleMoves(board, playerPieces);
		}
	}

}

public void mouseReleased() {

	Piece[] playerPieces = white;
	Piece[] enemyPieces = black;

	moving = false;
	int i = floor(mouseX / cellSize);
	int j = floor(mouseY / cellSize);
	
	boolean valid = false;
	Node move = movingPiecePossibleMoves;
	while(move != null) {
		if (move.data.i == i && move.data.j == j) {
			valid = true;
			// movingPiece.firstMove = false;
			break;
		}
		move = move.next;
	}
	
	if (inRange(i) && inRange(j) && valid) {
		Cell dead = movingPiece.move(i, j, board, playerPieces);
		if (movingPiece.getId() == Pawn.id) {
			if (movingPiece.needToPromote) {
				promoting = true;
				// for (int k = 0; k <  playerPieces.length; k++) {
				// 	if (playerPieces[k] != null) {
				// 		if (playerPieces[k].i == movingPiece.i && playerPieces[k].j == movingPiece.j) {
				// 			playerPieces[k] = new Queen(movingPiece.i, movingPiece.j, movingPiece.side);
				// 		}
				// 	}
				// }
			}
		}
		if (dead != null) {
			for (int k = 0; k <  enemyPieces.length; k++) {
				if (enemyPieces[k] != null) {
					if (enemyPieces[k].i == dead.i && enemyPieces[k].j == dead.j) {
						enemyPieces[k] = null;
					}
				}
			}
		}
		board = updateBoard(white, black);
		movingPiece.updateBoard(board);
	}
	println();
	for (int a = 0; a < 8; a++) {
		for (int b = 0; b < 8; b++) {
			print(board[getIndex(b, a)]);
			print(" ");
		}
		println();
	}
}

public void keyPressed() {
	if (promoting) {
		if (key == '1') {
			for (int k = 0; k <  white.length; k++) {
				if (white[k] != null) {
					if (white[k].i == movingPiece.i && white[k].j == movingPiece.j) {
						white[k] = new Queen(movingPiece.i, movingPiece.j, movingPiece.side);
					}
				}
			}
		} else if (key == '2') {
			for (int k = 0; k <  white.length; k++) {
				if (white[k] != null) {
					if (white[k].i == movingPiece.i && white[k].j == movingPiece.j) {
						white[k] = new Knight(movingPiece.i, movingPiece.j, movingPiece.side);
					}
				}
			}
		} else if (key == '3') {
			for (int k = 0; k <  white.length; k++) {
				if (white[k] != null) {
					if (white[k].i == movingPiece.i && white[k].j == movingPiece.j) {
						white[k] = new Bishop(movingPiece.i, movingPiece.j, movingPiece.side);
					}
				}
			}
		} else if (key == '4') {
			for (int k = 0; k <  white.length; k++) {
				if (white[k] != null) {
					if (white[k].i == movingPiece.i && white[k].j == movingPiece.j) {
						white[k] = new Rook(movingPiece.i, movingPiece.j, movingPiece.side);
					}
				}
			}
		}
		promoting = false;
	}
}

public boolean inRange(int num) {
	return num > - 1 && num < 8;
}

public int getIndex(int i, int j) {
	return i * rows + j;
}

public boolean isEmpty(int i, int j, int[] board) {
	int value = board[getIndex(i, j)];
	return value == 0 || Math.abs(value) == Pawn.EnPassant;
}

public boolean isEmptyOrEnemy(int i, int j, int side, int[] board) {
	int value = board[getIndex(i, j)];
	return value * side < 1 || Math.abs(value) == Pawn.EnPassant;
}

public boolean isEnemy(int i, int j, int side, int[] board) {
	int value = board[getIndex(i, j)];
	return value * side < 0 && Math.abs(value) != Pawn.EnPassant;
}

public boolean isMySide(int i, int j, int side, int[] board) {
	int value = board[getIndex(i, j)];
	return value * side > 0 && Math.abs(value) != Pawn.EnPassant;
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

	public Node getPossibleMoves(int[] board, Piece[] myPieces) {
		Node first = new Node(null);
		Node current = first;
		for (int a = -1; a < 2; a += 2) {
			for (int b = -1; b < 2; b += 2) {
				int move = 1;
				while (inRange(i + a * move) && inRange(j + b * move)) {
					if (isMySide(i + a * move, j + b * move, side, board)) {
						break;
					}
					current = current.add(new Cell(i + a * move, j + b * move));
					if (isEnemy(i + a * move, j + b * move, side, board)) {
						break;
					}
					move += 1;
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
			img = BishopWhiteImg;
		} else {
			img = BishopBlackImg;
		}
		return img;
	}

	public int getId() {
		return id;
	}
}
public class Cell {
    
    int i;
    int j;

    Cell(int i, int j) {
        this.i = i;
        this.j = j;
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

	public Node getPossibleMoves(int[] board, Piece[] myPieces) {
		Node first = new Node(null);
		Node current = first;
		for (int a = -1; a < 2; a++) {
			for (int b = -1; b < 2; b++) {
				if (inRange(i + a) && inRange(j + b)) {
					if (isEmptyOrEnemy(i + a, j + b, side, board)) {
						current = current.add(new Cell(i + a, j + b));
					}
				}
			}
		}

		if (firstMove) {
			for (int a = 0; a < myPieces.length; a++) {
				if (myPieces[a].getId() == Rook.id) {
					int dir = Math.abs(i - myPieces[a].i) / (myPieces[a].i - i);
					if (myPieces[a].firstMove && board[getIndex(i + dir, j)] == 0 && board[getIndex(i + dir * 2, j)] == 0) {
						current = current.add(new Cell(i + 2 * dir, j));
					}
				}
			}
		}

		if (first.data == null) {
			return null;
		}
		return first;
	}

	public Cell move(int x, int y, int board[], Piece[] myPieces) {
		if (Math.abs(i - x) == 2) {
			int dir = Math.abs(i - x) / (x - i);
			for (int a = 0; a < myPieces.length; a++) {
				if (myPieces[a].getId() == Rook.id && (myPieces[a].i - i) * dir > 0) {
					myPieces[a].i = i + dir;
				}
			}
		}

		return super.move(x, y, board, myPieces);
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

	public int getId() {
		return id;
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

	public Node getPossibleMoves(int[] board, Piece[] myPieces) {
		Node first = new Node(null);
		Node current = first;
		for (int a = -1; a < 2; a += 2) {
			for (int b = -1; b < 2; b += 2) {
				if (inRange(i + a * 2) && inRange(j + b)) {
					if (isEmptyOrEnemy(i + a * 2, j + b, side, board)) {
						current = current.add(new Cell(i + a * 2, j + b));
					}
				}
				if (inRange(i + a) && inRange(j + b * 2)) {
					if (isEmptyOrEnemy(i + a, j + b * 2, side, board)) {
						current = current.add(new Cell(i + a, j + b * 2));
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

	public int getId() {
		return id;
	}
}
public class Node {
	
	Cell data;
	Node next;
	
	public Node(Cell data) {
		this.data = data;
		next = null;
	}
	
	public Node add(Cell n) {
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
	final static int EnPassant = 100;

	Cell putEnPassant = null;

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
	
	public Node getPossibleMoves(int[] board, Piece[] myPieces) {
		Node first = new Node(null);
		Node current = first;
		if (inRange(j - side)) {
			if (isEmpty(i, j - side, board)) {
				current = current.add(new Cell(i, j - side));
			}
		}
		if (inRange(j - side * 2) && firstMove) {
			if (isEmpty(i, j - side * 2, board) && isEmpty(i, j - side, board)) {
				current = current.add(new Cell(i, j - side * 2));
			}
		}
		for (int k = - 1; k < 2; k += 2) {
			if (inRange(i + k) && inRange(j - side)) {
				if (isEnemy(i + k, j - side, side, board) || board[getIndex(i + k, j - side)] == EnPassant * side * -1) {
					current = current.add(new Cell(i + k, j - side));
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

	public void updateBoard(int[] board) {
		if (putEnPassant != null) {
			board[getIndex(putEnPassant.i, putEnPassant.j)] = EnPassant * side;
		}
		putEnPassant = null;
	}

	public Cell move(int x, int y, int board[], Piece[] myPieces) {

		if (Math.abs(y - j) == 2) {
			putEnPassant = new Cell(x, j - side);
		}

		Cell result = super.move(x, y, board, myPieces);

		// println((8 - 1) % 9);
		// print("j: ");
		// println(j);
		// print("end: ");
		// println((cols + side) % (cols + 1));
		if (j == (cols + side) % (cols + 1)) {
			println("here");
			needToPromote = true;
		}

		
		if (result != null) {
			return result;
		}


		if (board[getIndex(i, j)] == EnPassant * side * -1) {
			return new Cell(i, j + side);
		}
		return result;
	}

	public int getId() {
		return id;
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

	boolean needToPromote = false;
	boolean firstMove = true;
	
	public Piece(int i, int j, int side) {
		this.i = i;
		this.j = j;
		this.side = side;
	}
	
	public Node getPossibleMoves(int[] board, Piece[] myPieces) {
		return new Node(new Cell(i, j - 1));
	}
	
	public void show() {
		
	}
	
	public PImage getImg() {
		return BishopWhiteImg;
	}

	public void updateBoard(int[] board) {

	}

	public Cell move(int x, int y, int[] board, Piece[] myPieces) {
		i = x;
		j = y;
		firstMove = false;
		if (isEnemy(i, j, side, board)) {
			return new Cell(i, j);
		}
		return null;
	}

	public int getId() {
		return id;
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

	public Node getPossibleMoves(int[] board, Piece[] myPieces) {
		Node first = new Node(null);
		Node current = first;
		for (int a = -1; a < 2; a += 2) {

			int move = 1;
			while (inRange(i + a * move)) {
				if (isMySide(i + a * move, j, side, board)) {
					break;
				}
				current = current.add(new Cell(i + a * move, j));
				if (isEnemy(i + a * move, j, side, board)) {
					break;
				}
				move += 1;
			}

			move = 1;
			while (inRange(j + a * move)) {
				if (isMySide(i, j + a * move, side, board)) {
					break;
				}
				current = current.add(new Cell(i, j + a * move));
				if (isEnemy(i, j + a * move, side, board)) {
					break;
				}
				move += 1;
			}

			for (int b = -1; b < 2; b += 2) {
				move = 1;
				while (inRange(i + a * move) && inRange(j + b * move)) {
					if (isMySide(i + a * move, j + b * move, side, board)) {
						break;
					}
					current = current.add(new Cell(i + a * move, j + b * move));
					if (isEnemy(i + a * move, j + b * move, side, board)) {
						break;
					}
					move += 1;
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
			img = QueenWhiteImg;
		} else {
			img = QueenBlackImg;
		}
		return img;
	}

	public int getId() {
		return id;
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

	public Node getPossibleMoves(int[] board, Piece[] myPieces) {
		Node first = new Node(null);
		Node current = first;
		for (int k = -1; k < 2; k += 2) {
			int move = 1;
			while (inRange(i + k * move)) {
				if (isMySide(i + k * move, j, side, board)) {
					break;
				}
				current = current.add(new Cell(i + k * move, j));
				if (isEnemy(i + k * move, j, side, board)) {
					break;
				}
				move += 1;
			}
			move = 1;
			while (inRange(j + k * move)) {
				if (isMySide(i, j + k * move, side, board)) {
					break;
				}
				current = current.add(new Cell(i, j + k * move));
				if (isEnemy(i, j + k * move, side, board)) {
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

	public int getId() {
		return id;
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
