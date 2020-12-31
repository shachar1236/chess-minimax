public class Piece {
	
	// 1 = white
	// -1 = black
	int side = 1;
	
	final static int value = 100;
	final static int id = 1;
	
	int i;
	int j;
	
	boolean firstMove = true;
	
	public Piece(int i, int j, int side) {
		this.i = i;
		this.j = j;
		this.side = side;
	}
	
	public Node getPossibleMoves(int[][] board) {
		return new Node(new PVector(i, j - 1));
	}
	
	public void show() {
		
	}
	
	PImage getImg() {
		return BishopWhiteImg;
	}
	
}
