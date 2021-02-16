public class Rook extends Piece {
	
	final static int value = 500;
	final static int id = 2;
	
	public Rook(int i, int j, int side) {
		super(i, j, side);
	}
	
	Piece clone() {
		Rook newPiece = new Rook(i, j, side);
		newPiece.firstMove = firstMove;
		return newPiece;
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
			img = RookWhiteImg;
		} else {
			img = RookBlackImg;
		}
		return img;
	}
	
	int getId() {
		return id;
	}
	
	int getValue() {
		return value;
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
		}
		return score;
	}
}
