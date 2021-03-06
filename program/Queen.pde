int posEvalQueen(int i, int j) {
	int[] values = {
		-20,-10,-10, -5, -5,-10,-10,-20,
		-10,  0,  0,  0,  0,  0,  0,-10,
		-10,  0,  5,  5,  5,  5,  0,-10,
		-5,  0,  5,  5,  5,  5,  0, -5,
		 0,  0,  5,  5,  5,  5,  0, -5,
		-10,  5,  5,  5,  5,  5,  0,-10,
		-10,  0,  5,  0,  0,  0,  0,-10,
		-20,-10,-10, -5, -5,-10,-10,-20
	};
	return (int)(values[getIndex(j, i)] * evalPosPrecent);
}

class Queen extends Piece {
	
	final static int value = 900;
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
		Node firstEnemy = new Node(null);
		Node firstEmpty = new Node(null);
		
		Node currentEnemy = firstEnemy;
		Node currentEmpty = firstEmpty;
		for (int a = - 1; a < 2; a += 2) {
			
			int move = 1;
			while(inRange(i + a * move)) {
				if (isMySide(i + a * move, j, side, board)) {
					break;
				}
				if (isEnemy(i + a * move, j, side, board)) {
					currentEnemy = currentEnemy.add(new Cell(i + a * move, j));
					break;
				} else {
					currentEmpty = currentEmpty.add(new Cell(i + a * move, j));
				}
				move += 1;
			}
			
			move = 1;
			while(inRange(j + a * move)) {
				if (isMySide(i, j + a * move, side, board)) {
					break;
				}
				if (isEnemy(i, j + a * move, side, board)) {
					currentEnemy = currentEnemy.add(new Cell(i, j + a * move));
					break;
				} else {
					currentEmpty = currentEmpty.add(new Cell(i, j + a * move));
				}
				move += 1;
			}
			
			for (int b = - 1; b < 2; b += 2) {
				move = 1;
				while(inRange(i + a * move) && inRange(j + b * move)) {
					if (isMySide(i + a * move, j + b * move, side, board)) {
						break;
					}
					if (isEnemy(i + a * move, j + b * move, side, board)) {
						currentEnemy = currentEnemy.add(new Cell(i + a * move, j + b * move));
						break;
					} else {
						currentEmpty = currentEmpty.add(new Cell(i + a * move, j + b * move));
					}
					move += 1;
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

	int evalPos() {
		int x = i;
		int y = ((cols - j - 1) * ((side + 1) / 2)) + j * ((((side + 1) / 2) + 1) % 2);
		return posEvalQueen(x, y);
	}

	int evalPossibleCaptures(int[] board) {
		int score = 0;

		for (int a = - 1; a < 2; a += 2) {
			
			int move = 1;
			while(inRange(i + a * move)) {
				if (isMySide(i + a * move, j, side, board)) {
					break;
				}
				if (isEnemy(i + a * move, j, side, board)) {
					int enemyId = board[getIndex(i + a * move, j)] * -side;
					score += id_to_value(enemyId) * evalCapturesKillPrecent;
					break;
				}
				move += 1;
			}
			
			move = 1;
			while(inRange(j + a * move)) {
				if (isMySide(i, j + a * move, side, board)) {
					break;
				}
				if (isEnemy(i, j + a * move, side, board)) {
					int enemyId = board[getIndex(i, j + a * move)] * -side;
					score += id_to_value(enemyId) * evalCapturesKillPrecent;
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
					if (isEnemy(i + a * move, j + b * move, side, board)) {
						int enemyId = board[getIndex(i + a * move, j + b * move)] * -side;
						score += id_to_value(enemyId) * evalCapturesKillPrecent;
						break;
					}
					move += 1;
				}
			}
		}
		return score;
	}
}
