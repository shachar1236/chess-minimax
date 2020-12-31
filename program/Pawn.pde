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
