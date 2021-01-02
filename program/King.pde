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

	Node getPossibleMoves(int[] board, Piece[] myPieces) {
		Node first = new Node(null);
		Node current = first;
		for (int a = -1; a < 2; a++) {
			for (int b = -1; b < 2; b++) {
				if (inRange(i + a) && inRange(j + b)) {
					if (isEmptyOrEnemy(i + a, j + b, side, board)) {
						current = current.add(new Cell(i + a, j + b));
					}
				}
			}
		}

		if (firstMove) {
			for (int a = 0; a < myPieces.length; a++) {
				if (myPieces[a].getId() == Rook.id) {
					int dir = Math.abs(i - myPieces[a].i) / (myPieces[a].i - i);
					if (myPieces[a].firstMove && board[getIndex(i + dir, j)] == 0 && board[getIndex(i + dir * 2, j)] == 0) {
						current = current.add(new Cell(i + 2 * dir, j));
					}
				}
			}
		}

		if (first.data == null) {
			return null;
		}
		return first;
	}

	Cell move(int x, int y, int board[], Piece[] myPieces) {
		if (Math.abs(i - x) == 2) {
			int dir = Math.abs(i - x) / (x - i);
			for (int a = 0; a < myPieces.length; a++) {
				if (myPieces[a].getId() == Rook.id && (myPieces[a].i - i) * dir > 0) {
					myPieces[a].i = i + dir;
				}
			}
		}

		return super.move(x, y, board, myPieces);
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

	int getId() {
		return id;
	}
}
