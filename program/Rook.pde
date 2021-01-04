public class Rook extends Piece {
	
	final static int value = 500;
	final static int id = 2;
	
	public Rook(int i, int j, int side) {
		super(i, j, side);
	}
	
	Piece clone() {
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
	
	Node getPossibleMoves(int[] board, Piece[] myPieces) {
		Node first = new Node(null);
		Node current = first;
		for (int k = - 1; k < 2; k += 2) {
			int move = 1;
			while(inRange(i + k * move)) {
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
			while(inRange(j + k * move)) {
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
	
	PImage getImg() {
		PImage img;
		if (side == 1) {
			img = RookWhiteImg;
		} else {
			img = RookBlackImg;
		}
		return img;
	}
	
	int getId() {
		return id;
	}
	
	int getValue() {
		return value;
	}
}
