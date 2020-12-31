class King extends Piece {
	int value = 1000;
	
	public King(int i, int j) {
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
		text("K",((float)i + 0.5) * cellSize,((float)j + 0.5) * cellSize);
	}
}
