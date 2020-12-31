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
