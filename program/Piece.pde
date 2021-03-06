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
	
	Piece clone() {
		Piece newPiece = new Piece(i, j, side);
		newPiece.firstMove = firstMove;
		return newPiece;
	}
	
	public Node getPossibleMoves(int[] board, Piece[] myPieces) {
		return new Node(new Cell(i, j - 1));
	}
	
	public void show() {
		
	}
	
	boolean needToPromote() {
		return false;
	}
	
	PImage getImg() {
		return BishopWhiteImg;
	}
	
	void updateBoard(int[] board) {
		
	}
	
	Cell move(int x, int y, int[] board, Piece[] myPieces) {
		i = x;
		j = y;
		firstMove = false;
		if (isEnemy(i, j, side, board)) {
			return new Cell(i, j);
		}
		return null;
	}
	
	int getId() {
		return id;
	}
	
	int getValue() {
		return value;
	}

	int evalPossibleCaptures(int[] board) {
		return 0;
	}

	int evalPos() {
		return 0;
	}
	
}
