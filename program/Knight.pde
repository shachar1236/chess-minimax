public class Knight extends Piece {
	
	final static int value = 300;
	final static int id = 3;
	
	public Knight(int i, int j, int side) {
		super(i, j, side);
	}
	
	Piece clone() {
		Knight newPiece = new Knight(i, j, side);
		newPiece.firstMove = firstMove;
		return newPiece;
	}
	
	int getValue() {
		return value;
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
	
	Node getPossibleMoves(int[] board, Piece[] myPieces) {
		Node firstEnemy = new Node(null);
		Node firstEmpty = new Node(null);
		
		Node currentEnemy = firstEnemy;
		Node currentEmpty = firstEmpty;
		
		for (int a = - 1; a < 2; a += 2) {
			for (int b = - 1; b < 2; b += 2) {
				if (inRange(i + a * 2) && inRange(j + b)) {
					if (isEmpty(i + a * 2, j + b, board)) {
						currentEmpty = currentEmpty.add(new Cell(i + a * 2, j + b));
					} else if (isEnemy(i + a * 2, j + b, side, board)) {
						currentEnemy = currentEnemy.add(new Cell(i + a * 2, j + b));
					}
				}
				if (inRange(i + a) && inRange(j + b * 2)) {
					if (isEmpty(i + a, j + b * 2, board)) {
						currentEmpty = currentEmpty.add(new Cell(i + a, j + b * 2));
					} else if (isEnemy(i + a, j + b * 2, side, board)) {
						currentEnemy = currentEnemy.add(new Cell(i + a, j + b * 2));
					}
				}
			}
		}
		
		currentEnemy.addNode(firstEmpty);
		if (firstEnemy.data == null) {
			return null;
		}
		return firstEnemy;
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
	
	int getId() {
		return id;
	}
}
