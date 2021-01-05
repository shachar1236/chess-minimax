public class TranspositionTableNode {
	
	int[] board;
	int side;
	
	public TranspositionTableNode(int[] board, int side) {
		this.board = board;
		this.side = side;
	}
}