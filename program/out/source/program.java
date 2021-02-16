import processing.core.*; 
import processing.data.*; 
import processing.event.*; 
import processing.opengl.*; 

import java.util.Map; 

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
final int lookAhed = 5;
final int infinity = 1000000000;

// int evalMult = 1;

int cellSize;

// TranspositionTable transpositionTable = new TranspositionTable(100);

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

int board[] = new int[rows * cols];

Piece[] white = new Piece[16];
Piece[] black = new Piece[16];

public void setup() {
	// evalMult = ((lookAhed + 1) % 2) - lookAhed % 2;
	// println("eval mult: " + evalMult);
	
	cellSize = width / rows;
	
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

	setupPieces();
}


public void setupPieces() {
	// char[][] b = {
	// 	{'r', 'n', 'b', 'k', 'q', 'b', 'n', 'r'},
	// 	{'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'},
	// 	{' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
	// 	{' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
	// 	{' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
	// 	{' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
	// 	{'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'},
	// 	{'R', 'N', 'B', 'K', 'Q', 'B', 'N', 'R'}
	// };

	char[][] b = {
		{'r', 'n', ' ', 'k', 'q', 'b', 'n', 'r'},
		{'p', 'p', 'p', ' ', 'p', 'p', 'p', 'p'},
		{' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
		{' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
		{' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
		{' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
		{'P', 'P', 'P', 'R', 'P', 'P', 'P', 'P'},
		{'R', 'N', 'B', 'K', 'Q', 'B', 'N', 'R'}
	};

	int blackIndex = 0;
	int whiteIndex = 0;

	for (int i = 0; i < 8; i++) {
		for (int j = 0; j < 8; j++) {
			char c = b[i][j];
			switch (c) {
				case 'r':
					black[blackIndex] = new Rook(j, i, -1);
					blackIndex++;
					break;
				case 'n':
					black[blackIndex] = new Knight(j, i, -1);
					blackIndex++;
					break;
				case 'b':
					black[blackIndex] = new Bishop(j, i, -1);
					blackIndex++;
					break;
				case 'k':
					black[blackIndex] = new King(j, i, -1);
					blackIndex++;
					break;
				case 'q':
					black[blackIndex] = new Queen(j, i, -1);
					blackIndex++;
					break;
				case 'p':
					black[blackIndex] = new Pawn(j, i, -1);
					blackIndex++;
					break;
				case 'R':
					white[whiteIndex] = new Rook(j, i, 1);
					whiteIndex++;
					break;
				case 'N':
					white[whiteIndex] = new Knight(j, i, 1);
					whiteIndex++;
					break;
				case 'B':
					white[whiteIndex] = new Bishop(j, i, 1);
					whiteIndex++;
					break;
				case 'K':
					white[whiteIndex] = new King(j, i, 1);
					whiteIndex++;
					break;
				case 'Q':
					white[whiteIndex] = new Queen(j, i, 1);
					whiteIndex++;
					break;
				case 'P':
					white[whiteIndex] = new Pawn(j, i, 1);
					whiteIndex++;
					break;
			}
		}
	}
	board = updateBoard(white, black);
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
	int[] newBoard = new int[rows * cols];
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


public int evalPos(int[] board, Piece[] white, Piece[] black) {
	int score = 0;
	for (int i = 0; i < white.length; i++) {
		if (white[i] != null) {
			score -= white[i].getValue();
		}
	}
	for (int i = 0; i < black.length; i++) {
		if (black[i] != null) {
			score += black[i].getValue();
		}
	}
	return score;
}

public int search(int depth, int alpha, int beta, int[] board, Piece[] white, Piece[] black, int blackTurn) {
	Piece[] player = black;
	Piece[] enemy = white;
	if (blackTurn == -1) {
		player = white;
		enemy = black;
	}

	boolean dontHaveBlackKing = true;
	boolean dontHaveWhiteKing = true;
	for (int i = 0; i < black.length; i++) {
		if (black[i] != null) {
			if (black[i].getId() == King.id) {
				dontHaveBlackKing = false;
			}
		}
		if (white[i] != null) {
			if (white[i].getId() == King.id) {
				dontHaveWhiteKing = false;
			}
		}
	}

	if (dontHaveBlackKing) {
		return - infinity * blackTurn;
	} else if (dontHaveWhiteKing) {
		return infinity * blackTurn;
	}
	
	if (depth == 0) {
		return evalPos(board, white, black) * blackTurn;
	}

	int value = -infinity;

	boolean running = true;

	for (int i = 0; i < player.length && running; i++) {
			
		if (player[i] != null) {
			
			Node move = player[i].getPossibleMoves(board, player);
			
			while(move != null) {
				
				
				Piece[] myPieces = copyPlayer(player);
				Piece[] enemyPieces = copyPlayer(enemy);
				int[] newBoard = board.clone();
				
				Cell dead = myPieces[i].move(move.data.i, move.data.j, board, myPieces);
				
				if (myPieces[i].getId() == Pawn.id) {
					if (myPieces[i].needToPromote()) {
						myPieces[i] = new Queen(myPieces[i].i, myPieces[i].j, myPieces[i].side);
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
				
				newBoard = updateBoard(myPieces, enemyPieces);
				myPieces[i].updateBoard(newBoard);
				
				move = move.next;

				Piece[] w = myPieces;
				Piece[] b = enemyPieces;

				if (blackTurn == 1) {
					w = enemyPieces;
					b = myPieces;
				}

				int eval = - search(depth - 1, -beta, -alpha, newBoard, w, b, -blackTurn);

				// if (random(0, 1) < 0.005) {
				// 	println("depth: " + depth);
				// 	println("eval: " + eval);
				// }

				value = max(value, eval);

				alpha = max(alpha, value);

				if (alpha > beta - 1) {
					running = false;
					break;
				}
			}
		}
	}

	return value;
}


public Piece[] copyPlayer(Piece[] player) {
	Piece[] copy = new Piece[player.length];
	for (int i = 0; i < player.length; i++) {
		if (player[i] != null) {
			copy[i] = player[i].clone();
		}
	}
	return copy;
}

public PieceMove pickMove() {
	Cell bestMove = null;
	Cell moveIndex = null;
	int best = - infinity;
	
	for (int i = 0; i < black.length; i++) {
		
		if (black[i] != null) {
			
			Node move = black[i].getPossibleMoves(board, black);
			
			while(move != null) {
				
				Piece[] myPieces = copyPlayer(black);
				Piece[] enemyPieces = copyPlayer(white);
				int[] newBoard = board.clone();
				
				Cell dead = myPieces[i].move(move.data.i, move.data.j, board, myPieces);
				
				if (myPieces[i].getId() == Pawn.id) {
					if (myPieces[i].needToPromote()) {
						myPieces[i] = new Queen(myPieces[i].i, myPieces[i].j, myPieces[i].side);
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
				
				newBoard = updateBoard(myPieces, enemyPieces);
				myPieces[i].updateBoard(newBoard);
				int value = -search(lookAhed - 1, - infinity, infinity, newBoard, enemyPieces, myPieces, -1);
				// println("main value: " + value);
				// int value = minimax(lookAhed - 1, - infinity, infinity, false, newBoard, enemyPieces, myPieces);
				
				if (value > best) {
					best = value;
					bestMove = move.data;
					moveIndex = new Cell(black[i].i, black[i].j);
				}
				
				move = move.next;
			}
		}
	}
	
	println("best: " + best);
	return new PieceMove(moveIndex, bestMove);
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
			Node current = movingPiecePossibleMoves;
			Node last = current;
			boolean first = true;
			while (current != null) {
				boolean changed = false;
				if (!isLegalMove(i, j, current.data, white, board)) {
					if (!first) {
						last.next = current.next;
					} else {
						movingPiecePossibleMoves = movingPiecePossibleMoves.next;
						changed = true;
					}
				} else {
					last = current;
				}
				current = current.next;
				if (!changed) {
					first = false;
				}
			}
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

	if (i == movingPiece.i && j == movingPiece.j) {
		valid = false;
	}
	
	if (inRange(i) && inRange(j) && valid) {
		Cell dead = movingPiece.move(i, j, board, playerPieces);
		if (movingPiece.getId() == Pawn.id) {
			if (movingPiece.needToPromote()) {
				promoting = true;
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
		
		draw();
		
		PieceMove computerMove = pickMove();
		
		Piece piece = null;
		int pieceIndex = 0;
		for (int k = 0; k < black.length; k++) {
			if (black[k] != null) {
				if (black[k].i == computerMove.pos.i && black[k].j == computerMove.pos.j) {
					piece = black[k];
					pieceIndex = k;
					break;
				}
			}
		}
		
		dead = piece.move(computerMove.move.i, computerMove.move.j, board, black);
		
		if (piece.getId() == Pawn.id) {
			if (piece.needToPromote()) {
				black[pieceIndex] = new Queen(piece.i, piece.j, piece.side);
			}
		}
		
		if (dead != null) {
			for (int k = 0; k <  white.length; k++) {
				if (white[k] != null) {
					if (white[k].i == dead.i && white[k].j == dead.j) {
						white[k] = null;
					}
				}
			}
		}
		
		board = updateBoard(white, black);
		piece.updateBoard(board);
		
		// transpositionTable.pr();
		
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

public boolean isLegalMove(int i, int j, Cell moveTo, Piece[] p, int[] _board) {
	int[] board = _board.clone();

	Piece king = null;

	for (int a = 0; a < p.length; a++) {
		if (p[a] != null) {
			if (p[a].getId() == King.id) {
				king = p[a];
				break;
			}
		}
	}

	int piece = board[getIndex(i, j)];
	board[getIndex(i, j)] = 0;
	board[getIndex(moveTo.i, moveTo.j)] = piece;

	if (abs(piece) == King.id) {
		king = king.clone();
		king.i = moveTo.i;
		king.j = moveTo.j;
	}

	return !isInCheck(king, board);
}

public boolean isInCheck(Piece king, int[] board) {
	int side = king.side;

	for (int a = - 1; a < 2; a += 2) {
		
		// rook
		int move = 1;
		while(inRange(king.i + a * move)) {
			if (isMySide(king.i + a * move, king.j, side, board)) {
				break;
			}
			if (isEnemy(king.i + a * move, king.j, side, board)) {
				int enemy = board[getIndex(king.i + a * move, king.j)] * side * -1;
				if (enemy == Rook.id || enemy == Queen.id) {
					return true;
				}
				break;
			}
			move += 1;
		}
		
		// rook
		move = 1;
		while(inRange(king.j + a * move)) {
			if (isMySide(king.i, king.j + a * move, side, board)) {
				break;
			}
			if (isEnemy(king.i, king.j + a * move, side, board)) {
				int enemy = board[getIndex(king.i, king.j + a * move)] * side * -1;
				if (enemy == Rook.id || enemy == Queen.id) {
					return true;
				}
				break;
			}
			move += 1;
		}
		
		for (int b = - 1; b < 2; b += 2) {
			// bishop
			move = 1;
			while(inRange(king.i + a * move) && inRange(king.j + b * move)) {
				if (isMySide(king.i + a * move, king.j + b * move, side, board)) {
					break;
				}
				if (isEnemy(king.i + a * move, king.j + b * move, side, board)) {
					int enemy = board[getIndex(king.i + a * move, king.j + b * move)] * side * -1;
					if (enemy == Bishop.id || enemy == Queen.id || (enemy == Pawn.id && move == 1)) {
						return true;
					}
					break;
				}
				move += 1;
			}
			
			// knight
			if (inRange(king.i + a * 2) && inRange(king.j + b)) {
				    if (isEnemy(king.i + a * 2, king.j + b, side, board)) {
						int enemy = board[getIndex(king.i + a * 2, king.j + b)] * side * -1;
						if (enemy == Knight.id) {
							return true;
						}
					}
				}
			if (inRange(king.i + a) && inRange(king.j + b * 2)) {
				if (isEnemy(king.i + a, king.j + b * 2, side, board)) {
					int enemy = board[getIndex(king.i + a, king.j + b * 2)] * side * -1;
					if (enemy == Knight.id) {
						return true;
					}
				}
			}
		}
	}

	return false;
}
public class Bishop extends Piece {
	
	final static int value = 300;
	final static int id = 4;
	
	public Bishop(int i, int j, int side) {
		super(i, j, side);
	}
	
	public Piece clone() {
		Bishop newPiece = new Bishop(i, j, side);
		newPiece.firstMove = firstMove;
		return newPiece;
	}
	
	public int getValue() {
		return value;
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
		Node firstEnemy = new Node(null);
		Node firstEmpty = new Node(null);
		
		Node currentEnemy = firstEnemy;
		Node currentEmpty = firstEmpty;
		for (int a = - 1; a < 2; a += 2) {
			for (int b = - 1; b < 2; b += 2) {
				int move = 1;
				while(inRange(i + a * move) && inRange(j + b * move)) {
					if (isMySide(i + a * move, j + b * move, side, board)) {
						break;
					}
					if (isEnemy(i + a * move, j + b * move, side, board)) {
						currentEnemy = currentEnemy.add(new Cell(i + a * move, j + b * move));
						break;
					} else {
						currentEmpty = currentEmpty.add(new Cell(i + a * move, j + b * move));
					}
					move += 1;
				}
			}
		}
		currentEnemy.addNode(firstEmpty);
		if (firstEnemy.data == null) {
			return null;
		}
		return firstEnemy;
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
	
	final static int value = 100000;
	final static int id = 6;
	
	public King(int i, int j, int side) {
		super(i, j, side);
	}
	
	public Piece clone() {
		King newPiece = new King(i, j, side);
		newPiece.firstMove = firstMove;
		return newPiece;
	}
	
	public int getValue() {
		return value;
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
		Node firstEnemy = new Node(null);
		Node firstEmpty = new Node(null);
		
		Node currentEnemy = firstEnemy;
		Node currentEmpty = firstEmpty;
		
		for (int a = - 1; a < 2; a++) {
			for (int b = - 1; b < 2; b++) {
				if (inRange(i + a) && inRange(j + b)) {
					if (isEmpty(i + a, j + b, board)) {
						currentEmpty = currentEmpty.add(new Cell(i + a, j + b));
					} else if (isEnemy(i + a, j + b, side, board)) {
						currentEnemy = currentEnemy.add(new Cell(i + a, j + b));
					}
				}
			}
		}
		
		if (firstMove) {
			for (int a = 0; a < myPieces.length; a++) {
				if (myPieces[a] != null) {
					if (myPieces[a].getId() == Rook.id && (myPieces[a].i - i) != 0) {
						int dir = Math.abs(i - myPieces[a].i) / (myPieces[a].i - i);
						if (myPieces[a].firstMove && board[getIndex(i + dir, j)] == 0 && board[getIndex(i + dir * 2, j)] == 0) {
							currentEmpty = currentEmpty.add(new Cell(i + 2 * dir, j));
						}
					}
				}
			}
		}
		
		currentEnemy.addNode(firstEmpty);
		if (currentEnemy.data == null) {
			return null;
		}
		return firstEnemy;
	}
	
	public Cell move(int x, int y, int board[], Piece[] myPieces) {
		if (Math.abs(i - x) == 2) {
			int dir = Math.abs(i - x) / (x - i);
			for (int a = 0; a < myPieces.length; a++) {
				if (myPieces[a] != null) {
					if (myPieces[a].getId() == Rook.id && (myPieces[a].i - i) * dir > 0) {
						myPieces[a].i = i + dir;
					}
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
	
	final static int value = 300;
	final static int id = 3;
	
	public Knight(int i, int j, int side) {
		super(i, j, side);
	}
	
	public Piece clone() {
		Knight newPiece = new Knight(i, j, side);
		newPiece.firstMove = firstMove;
		return newPiece;
	}
	
	public int getValue() {
		return value;
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
		Node firstEnemy = new Node(null);
		Node firstEmpty = new Node(null);
		
		Node currentEnemy = firstEnemy;
		Node currentEmpty = firstEmpty;
		
		for (int a = - 1; a < 2; a += 2) {
			for (int b = - 1; b < 2; b += 2) {
				if (inRange(i + a * 2) && inRange(j + b)) {
					if (isEmpty(i + a * 2, j + b, board)) {
						currentEmpty = currentEmpty.add(new Cell(i + a * 2, j + b));
					} else if (isEnemy(i + a * 2, j + b, side, board)) {
						currentEnemy = currentEnemy.add(new Cell(i + a * 2, j + b));
					}
				}
				if (inRange(i + a) && inRange(j + b * 2)) {
					if (isEmpty(i + a, j + b * 2, board)) {
						currentEmpty = currentEmpty.add(new Cell(i + a, j + b * 2));
					} else if (isEnemy(i + a, j + b * 2, side, board)) {
						currentEnemy = currentEnemy.add(new Cell(i + a, j + b * 2));
					}
				}
			}
		}
		
		currentEnemy.addNode(firstEmpty);
		if (firstEnemy.data == null) {
			return null;
		}
		return firstEnemy;
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
	// Cell from;
	Node next;
	
	public Node(Cell data) {
		this.data = data;
		// from = data;
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
	
	public void addNode(Node n) {
		if (n.data == null) {
			return;
		}
		if (data == null) {
			data = n.data;
			next = n.next;
		} else {
			next = n;
		}
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
	
	public Piece clone() {
		Pawn newPiece = new Pawn(i, j, side);
		newPiece.firstMove = firstMove;
		newPiece.putEnPassant = putEnPassant;
		return newPiece;
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

		for (int k = - 1; k < 2; k += 2) {
			if (inRange(i + k) && inRange(j - side)) {
				if (isEnemy(i + k, j - side, side, board) || board[getIndex(i + k, j - side)] == EnPassant * side * - 1) {
					Cell move = new Cell(i + k, j - side);
					current = current.add(move);
				}
			}
		}

		if (inRange(j - side)) {
			if (isEmpty(i, j - side, board)) {
				Cell move = new Cell(i, j - side);
				current = current.add(move);
			}
		}

		if (inRange(j - side * 2) && firstMove) {
			if (isEmpty(i, j - side * 2, board) && isEmpty(i, j - side, board)) {
				Cell move = new Cell(i, j - side * 2);
				current = current.add(move);
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
		
		// if (j == (cols + side) % (cols + 1)) {
		// 	println("here");
		// 	needToPromote = true;
		// }
		
		
		if (result != null) {
			return result;
		}
		
		
		if (board[getIndex(i, j)] == EnPassant * side * - 1) {
			return new Cell(i, j + side);
		}
		return result;
	}
	
	public boolean needToPromote() {
		return j == ((cols + side) % (cols + 1));
	}
	
	public int getId() {
		return id;
	}
	
	public int getValue() {
		return value;
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
	
	public Piece clone() {
		Piece newPiece = new Piece(i, j, side);
		newPiece.firstMove = firstMove;
		return newPiece;
	}
	
	public Node getPossibleMoves(int[] board, Piece[] myPieces) {
		return new Node(new Cell(i, j - 1));
	}
	
	public void show() {
		
	}
	
	public boolean needToPromote() {
		return false;
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
	
	public int getValue() {
		return value;
	}
	
}
class Queen extends Piece {
	
	final static int value = 900;
	final static int id = 5;
	
	public Queen(int i, int j, int side) {
		super(i, j, side);
	}
	
	public Piece clone() {
		Queen newPiece = new Queen(i, j, side);
		newPiece.firstMove = firstMove;
		return newPiece;
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
		Node firstEnemy = new Node(null);
		Node firstEmpty = new Node(null);
		
		Node currentEnemy = firstEnemy;
		Node currentEmpty = firstEmpty;
		for (int a = - 1; a < 2; a += 2) {
			
			int move = 1;
			while(inRange(i + a * move)) {
				if (isMySide(i + a * move, j, side, board)) {
					break;
				}
				if (isEnemy(i + a * move, j, side, board)) {
					currentEnemy = currentEnemy.add(new Cell(i + a * move, j));
					break;
				} else {
					currentEmpty = currentEmpty.add(new Cell(i + a * move, j));
				}
				move += 1;
			}
			
			move = 1;
			while(inRange(j + a * move)) {
				if (isMySide(i, j + a * move, side, board)) {
					break;
				}
				if (isEnemy(i, j + a * move, side, board)) {
					currentEnemy = currentEnemy.add(new Cell(i, j + a * move));
					break;
				} else {
					currentEmpty = currentEmpty.add(new Cell(i, j + a * move));
				}
				move += 1;
			}
			
			for (int b = - 1; b < 2; b += 2) {
				move = 1;
				while(inRange(i + a * move) && inRange(j + b * move)) {
					if (isMySide(i + a * move, j + b * move, side, board)) {
						break;
					}
					if (isEnemy(i + a * move, j + b * move, side, board)) {
						currentEnemy = currentEnemy.add(new Cell(i + a * move, j + b * move));
						break;
					} else {
						currentEmpty = currentEmpty.add(new Cell(i + a * move, j + b * move));
					}
					move += 1;
				}
			}
		}
		
		currentEnemy.addNode(firstEmpty);
		if (firstEnemy.data == null) {
			return null;
		}
		return firstEnemy;
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
	
	public int getValue() {
		return value;
	}
}
public class Rook extends Piece {
	
	final static int value = 500;
	final static int id = 2;
	
	public Rook(int i, int j, int side) {
		super(i, j, side);
	}
	
	public Piece clone() {
		Rook newPiece = new Rook(i, j, side);
		newPiece.firstMove = firstMove;
		return newPiece;
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
		Node firstEnemy = new Node(null);
		Node firstEmpty = new Node(null);
		
		Node currentEnemy = firstEnemy;
		Node currentEmpty = firstEmpty;
		for (int a = - 1; a < 2; a += 2) {
			
			int move = 1;
			while(inRange(i + a * move)) {
				if (isMySide(i + a * move, j, side, board)) {
					break;
				}
				if (isEnemy(i + a * move, j, side, board)) {
					currentEnemy = currentEnemy.add(new Cell(i + a * move, j));
					break;
				} else {
					currentEmpty = currentEmpty.add(new Cell(i + a * move, j));
				}
				move += 1;
			}
			
			move = 1;
			while(inRange(j + a * move)) {
				if (isMySide(i, j + a * move, side, board)) {
					break;
				}
				if (isEnemy(i, j + a * move, side, board)) {
					currentEnemy = currentEnemy.add(new Cell(i, j + a * move));
					break;
				} else {
					currentEmpty = currentEmpty.add(new Cell(i, j + a * move));
				}
				move += 1;
			}
		}
		
		currentEnemy.addNode(firstEmpty);
		if (firstEnemy.data == null) {
			return null;
		}
		return firstEnemy;
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
	
	public int getValue() {
		return value;
	}
}


public class TranspositionTable {
	
	int maxSize = 64;
	int size = 0;
	HashMap<TranspositionTableNode, Integer> table;
	
	public TranspositionTable(int maxSize) {
		this.maxSize = maxSize;
		table = new HashMap<TranspositionTableNode, Integer>();
	}
	
	public boolean has(int[] board, int side) {
		TranspositionTableNode node = new TranspositionTableNode(board, side);
		// for (Map.Entry me : table.entrySet()) {
		// 	print(me.getKey() + " is ");
		// 	println(me.getValue());
		// }
		return table.containsKey(node);
	}
	
	public void put(int[] board, int side, int score) {
		size++;
		TranspositionTableNode node = new TranspositionTableNode(board, side);
		table.put(node, score);
	}
	
	public int get(int[] board, int side) {
		TranspositionTableNode node = new TranspositionTableNode(board, side);
		return table.get(node);
	}
	
	public void pr() {
			for (Map.Entry me : table.entrySet()) {
			print(me.getKey() + " is ");
			println(me.getValue());
		}
	}
}
public class TranspositionTableNode {
	
	int[] board;
	int side;
	
	public TranspositionTableNode(int[] board, int side) {
		this.board = board;
		this.side = side;
	}
}
public class PieceMove {
	
	Cell pos;
	Cell move; 
	
	public PieceMove(Cell pos_, Cell m) {
		pos = pos_;
		move = m;
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
