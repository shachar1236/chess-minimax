public class Bishop extends Piece {
	
	final static int value = 200;
	final static int id = 4;
	
	public Bishop(int i, int j, int side) {
		super(i, j, side);
	}
	
	public void show() {
		PImage img;
		if (side == 1) {
			img = BishopWhiteImg;
		} else {
			img = BishopBlackImg;
		}
		image(img, i * cellSize, j * cellSize, cellSize, cellSize);
	}
	
	PImage getImg() {
		PImage img;
		if (side == 1) {
			img = BishopWhiteImg;
		} else {
			img = BishopBlackImg;
		}
		return img;
	}
}
