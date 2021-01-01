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

void setup() {
	size(800, 800);
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

void draw() {
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
				image(img, mouseX - cellSize / 2, mouseY - cellSize / 2, cellSize * 1.2, cellSize * 1.2);
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

int[] updateBoard(Piece[] p1, Piece[] p2) {
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

void mousePressed() {
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

void mouseReleased() {
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

boolean inRange(int num) {
	return num > - 1 && num < 8;
}

int getIndex(int i, int j) {
	return i * rows + j;
}