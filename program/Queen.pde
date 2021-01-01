class Queen extends Piece {
	
	final static int value = 500;
	final static int id = 5;
	
	public Queen(int i, int j, int side) {
		super(i, j, side);
	}
	
	public void show() {
		PImage img;
		if (side == 1) {
			img = QueenWhiteImg;
		} else {
			img = QueenBlackImg;
		}
		image(img, i * cellSize, j * cellSize, cellSize, cellSize);
	}

	Node getPossibleMoves(int[] board) {
		Node first = new Node(null);
		Node current = first;
		for (int a = -1; a < 2; a += 2) {

			int move = 1;
			while (inRange(i + a * move)) {
				if (board[getIndex(i + a * move, j)] * side > 0) {
					break;
				}
				current = current.add(new PVector(i + a * move, j));
				if (board[getIndex(i + a * move, j)] * side < 0) {
					break;
				}
				move += 1;
			}

			move = 1;
			while (inRange(j + a * move)) {
				if (board[getIndex(i , j + a * move)] * side > 0) {
					break;
				}
				current = current.add(new PVector(i, j + a * move));
				if (board[getIndex(i , j + a * move)] * side < 0) {
					break;
				}
				move += 1;
			}

			for (int b = -1; b < 2; b += 2) {
				move = 1;
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
			img = QueenWhiteImg;
		} else {
			img = QueenBlackImg;
		}
		return img;
	}
}
