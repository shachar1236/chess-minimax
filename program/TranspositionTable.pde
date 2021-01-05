import java.util.Map;

public class TranspositionTable {
	
	int maxSize = 64;
	int size = 0;
	HashMap<TranspositionTableNode, Integer> table;
	
	public TranspositionTable(int maxSize) {
		this.maxSize = maxSize;
		table = new HashMap<TranspositionTableNode, Integer>();
	}
	
	boolean has(int[] board, int side) {
		TranspositionTableNode node = new TranspositionTableNode(board, side);
		// for (Map.Entry me : table.entrySet()) {
		// 	print(me.getKey() + " is ");
		// 	println(me.getValue());
		// }
		return table.containsKey(node);
	}
	
	void put(int[] board, int side, int score) {
		size++;
		TranspositionTableNode node = new TranspositionTableNode(board, side);
		table.put(node, score);
	}
	
	int get(int[] board, int side) {
		TranspositionTableNode node = new TranspositionTableNode(board, side);
		return table.get(node);
	}
	
	void pr() {
			for (Map.Entry me : table.entrySet()) {
			print(me.getKey() + " is ");
			println(me.getValue());
		}
	}
}