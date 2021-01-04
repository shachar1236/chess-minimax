public class Bishop extends Piece {
	
	final static int value = 300;
	final static int id = 4;
	
	public Bishop(int i, int j, int side) {
		super(i, j, side);
	}
	
	Piece clone() {
		Bishop newPiece = new Bishop(i, j, side);
		newPiece.firstMove = firstMove;
		return newPiece;
	}
	
	int getValue() {
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
	
	Node getPossibleMoves(int[] board, Piece[] myPieces) {
		Node first = new Node(null);
		Node current = first;
		for (int a = - 1; a < 2; a += 2) {
			for (int b = - 1; b < 2; b += 2) {
				int move = 1;
				while(inRange(i + a * move) && inRange(j + b * move)) {
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
	
	PImage getImg() {
		PImage img;
		if (side == 1) {
			img = BishopWhiteImg;
		} else {
			img = BishopBlackImg;
		}
		return img;
	}
	
	int getId() {
		return id;
	}
}
