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

		Node getPossibleMoves(int[] board) {
		Node first = new Node(null);
		Node current = first;
		for (int a = -1; a < 2; a += 2) {
			for (int b = -1; b < 2; b += 2) {
				int move = 1;
				while (inRange(i + a * move) && inRange(j + b * move)) {
					if (board[getIndex(i + a * move, j + b * move)] * side > 0) {
						break;
					}
					current = current.add(new PVector(i + a * move, j + b * move));
					if (board[getIndex(i + a * move, j + b * move)] * side < 0) {
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
}
