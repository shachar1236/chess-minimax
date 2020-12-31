public class Knight extends Piece {
	
	final static int value = 200;
	final static int id = 3;
	
	public Knight(int i, int j, int side) {
		super(i, j, side);
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
	
	PImage getImg() {
		PImage img;
		if (side == 1) {
			img = KnightWhiteImg;
		} else {
			img = KnightBlackImg;
		}
		return img;
	}
}
