public class Bishop extends Piece {
	
	static int value = 200;
	static int id = 4;
	
	public Bishop(int i, int j) {
		this.i = i;
		this.j = j;
	}
	
	public void show() {
		if (side == 1) {
			fill(255);
			stroke(0);
		} else {
			fill(0);
			stroke(255);
		}
		textSize(20);
		text("B",((float)i + 0.5) * cellSize,((float)j + 0.5) * cellSize);
	}
}
