public class Knight extends Piece {
	
	final static int value = 200;
	final static int id = 3;
	
	public Knight(int i, int j, int side) {
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
		text("Kn",((float)i + 0.5) * cellSize,((float)j + 0.5) * cellSize);
	}
}
