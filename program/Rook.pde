public class Rook extends Piece {
	
	final static int value = 300;
	final static int id = 2;
	
	public Rook(int i, int j, int side) {
		super(i, j, side);
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
	
	PImage getImg() {
		PImage img;
		if (side == 1) {
			img = RookWhiteImg;
		} else {
			img = RookBlackImg;
		}
		return img;
	}
}
