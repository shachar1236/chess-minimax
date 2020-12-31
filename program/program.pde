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

void setup() {
	size(800, 800);
	cellSize = width / rows;
}

void draw() {
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
