class Queen extends Piece {
	
	final static int value = 500;
	final static int id = 5;
	
	public Queen(int i, int j, int side) {
		super(i, j, side);
	}
	
	Piece clone() {
		Queen newPiece = new Queen(i, j, side);
		newPiece.firstMove = firstMove;
		return newPiece;
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
	
	Node getPossibleMoves(int[] board, Piece[] myPieces) {
		Node first = new Node(null);
		Node current = first;
		for (int a = - 1; a < 2; a += 2) {
			
			int move = 1;
			while(inRange(i + a * move)) {
				if (isMySide(i + a * move, j, side, board)) {
					break;
				}
				current = current.add(new Cell(i + a * move, j));
				if (isEnemy(i + a * move, j, side, board)) {
					break;
				}
				move += 1;
			}
			
			move = 1;
			while(inRange(j + a * move)) {
				if (isMySide(i, j + a * move, side, board)) {
					break;
				}
				current = current.add(new Cell(i, j + a * move));
				if (isEnemy(i, j + a * move, side, board)) {
					break;
				}
				move += 1;
			}
			
			for (int b = - 1; b < 2; b += 2) {
				move = 1;
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
			img = QueenWhiteImg;
		} else {
			img = QueenBlackImg;
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
