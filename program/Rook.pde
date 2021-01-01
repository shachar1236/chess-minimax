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

	Node getPossibleMoves(int[] board) {
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
	
	PImage getImg() {
		PImage img;
		if (side == 1) {
			img = RookWhiteImg;
		} else {
			img = RookBlackImg;
		}
		return img;
	}
}
