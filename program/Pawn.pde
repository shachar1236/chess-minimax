public class Pawn extends Piece {
	
	final static int value = 100;
	final static int id = 1;
	
	public Pawn(int i, int j, int side) {
		super(i, j, side);
	}
	
	public void show() {
		strokeWeight(8);
		if (side == 1) {
			fill(255);
			stroke(0);
		} else {
			fill(0);
			stroke(255);
		}
		textSize(30);
		text("P",((float)i + 0.5) * cellSize,((float)j + 0.5) * cellSize);
	}
}
