int posEvalKnight(int i, int j) {
	int[] values = {
		-50,-40,-30,-30,-30,-30,-40,-50,
		-40,-20,  0,  0,  0,  0,-20,-40,
		-30,  0, 10, 15, 15, 10,  0,-30,
		-30,  5, 15, 20, 20, 15,  5,-30,
		-30,  0, 15, 20, 20, 15,  0,-30,
		-30,  5, 10, 15, 15, 10,  5,-30,
		-40,-20,  0,  5,  5,  0,-20,-40,
		-50,-40,-30,-30,-30,-30,-40,-50,
	};
	return values[getIndex(j, i)];
}


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

	int evalPos() {
		int x = i;
		int y = ((cols - j - 1) * ((side + 1) / 2)) + j * ((((side + 1) / 2) + 1) % 2);
		return posEvalKnight(x, y);
	}

	int evalPossibleCaptures(int[] board) {
		int score = 0;

		for (int a = - 1; a < 2; a += 2) {
			for (int b = - 1; b < 2; b += 2) {
				if (inRange(i + a * 2) && inRange(j + b)) {
					if (isEnemy(i + a * 2, j + b, side, board)) {
						int enemyId = board[getIndex(i + a * 2, j + b)] * -side;
						score += id_to_value(enemyId) * evalCapturesKillPrecent;
					}
				}
				if (inRange(i + a) && inRange(j + b * 2)) {
					if (isEnemy(i + a, j + b * 2, side, board)) {
						int enemyId = board[getIndex(i + a, j + b * 2)] * -side;
						score += id_to_value(enemyId) * evalCapturesKillPrecent;
					}
				}
			}
		}
		return score;
	}
}
