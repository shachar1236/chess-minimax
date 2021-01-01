public class Knight extends Piece {
	
	final static int value = 200;
	final static int id = 3;
	
	public Knight(int i, int j, int side) {
		super(i, j, side);
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

	Node getPossibleMoves(int[] board) {
		Node first = new Node(null);
		Node current = first;
		for (int a = -1; a < 2; a += 2) {
			for (int b = -1; b < 2; b += 2) {
				if (inRange(i + a * 2) && inRange(j + b)) {
					if (board[getIndex(i + a * 2, j + b)] * side < 1) {
						current = current.add(new PVector(i + a * 2, j + b));
					}
				}
				if (inRange(i + a) && inRange(j + b * 2)) {
					if (board[getIndex(i + a, j + b * 2)] * side < 1) {
						current = current.add(new PVector(i + a, j + b * 2));
					}
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
			img = KnightWhiteImg;
		} else {
			img = KnightBlackImg;
		}
		return img;
	}
}
