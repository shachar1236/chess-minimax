class King extends Piece {
	
	final static int value = 1000;
	final static int id = 6;
	
	public King(int i, int j, int side) {
		super(i, j, side);
	}
	
	public void show() {
		PImage img;
		if (side == 1) {
			img = KingWhiteImg;
		} else {
			img = KingBlackImg;
		}
		image(img, i * cellSize, j * cellSize, cellSize, cellSize);
	}

	Node getPossibleMoves(int[] board) {
		Node first = new Node(null);
		Node current = first;
		for (int a = -1; a < 2; a++) {
			for (int b = -1; b < 2; b++) {
				if (inRange(i + a) && inRange(j + b)) {
					if (board[getIndex(i + a, j + b)] * side < 1) {
						current = current.add(new PVector(i + a, j + b));
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
			img = KingWhiteImg;
		} else {
			img = KingBlackImg;
		}
		return img;
	}
}
