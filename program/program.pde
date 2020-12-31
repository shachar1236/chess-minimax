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
	{Rook.id, Knight.id, Bishop.id, King.id, Queen.id, Bishop.id, Knight.id, Rook.id} ,
}

void setup() {
	size(800, 800);
	cellSize = width / rows;
	for (int i = 0; i < rows; i++)
	{
		for (int j = 0; j < cols; j++) {
			board[i][j] = null;
		}
	}
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
}
