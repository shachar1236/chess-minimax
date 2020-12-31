public class Pawn extends Piece {
	
	final static int value = 100;
	final static int id = 1;
	
	public Pawn(int i, int j, int side) {
		super(i, j, side);
	}
	
	public void show() {
		PImage img;
		if (side == 1) {
			img = PawnWhiteImg;
		} else {
			img = PawnBlackImg;
		}
		image(img, i * cellSize, j * cellSize, cellSize, cellSize);
	}
	
	Node getPossibleMoves(int[][] board) {
		Node first = new Node(null);
		Node current = first;
		if (inRange(j - side)) {
			if (board[i][j - side] == 0) {
				current = current.add(new PVector(i, j - side));
			}
		}
		if (inRange(j - side * 2) && firstMove) {
			if (board[i][j - side * 2] == 0) {
				current = current.add(new PVector(i, j - side * 2));
			}
		}
		for (int k = - 1; k < 2; k += 2) {
			if (inRange(i + k) && inRange(j - side)) {
				if (board[i + k][j - side] * side < 0) {
					current = current.add(new PVector(i + k, j - side));
				}
			}
		}
		return first;
	}
	
	PImage getImg() {
		PImage img;
		if (side == 1) {
			img = PawnWhiteImg;
		} else {
			img = PawnBlackImg;
		}
		return img;
	}
}
