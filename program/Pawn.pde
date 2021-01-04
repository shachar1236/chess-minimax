public class Pawn extends Piece {
	
	final static int value = 100;
	final static int id = 1;
	final static int EnPassant = 100;
	
	Cell putEnPassant = null;
	
	public Pawn(int i, int j, int side) {
		super(i, j, side);
	}
	
	Piece clone() {
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
	
	Node getPossibleMoves(int[] board, Piece[] myPieces) {
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
				if (isEnemy(i + k, j - side, side, board) || board[getIndex(i + k, j - side)] == EnPassant * side * - 1) {
					current = current.add(new Cell(i + k, j - side));
				}
			}
		}
		if (first.data == null) {
			return null;
		}
		return first;
	}
	
	PImage getImg() {
		PImage img;
		if (side == 1) {
			img = PawnWhiteImg;
		} else {
			img = PawnBlackImg;
		}
		return img;
	}
	
	void updateBoard(int[] board) {
		if (putEnPassant != null) {
			board[getIndex(putEnPassant.i, putEnPassant.j)] = EnPassant * side;
		}
		putEnPassant = null;
	}
	
	Cell move(int x, int y, int board[], Piece[] myPieces) {
		
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
	
	boolean needToPromote() {
		return j == ((cols + side) % (cols + 1));
	}
	
	int getId() {
		return id;
	}
	
	int getValue() {
		return value;
	}
}
