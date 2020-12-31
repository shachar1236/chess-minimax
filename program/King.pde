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
