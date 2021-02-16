public class Node {
	
	Cell data;
	// Cell from;
	Node next;
	
	public Node(Cell data) {
		this.data = data;
		// from = data;
		next = null;
	}
	
	public Node add(Cell n) {
		if (data == null) {
			data = n;
			return this;
		}
		next = new Node(n);
		return next;
	}
	
	public void addNode(Node n) {
		if (n.data == null) {
			return;
		}
		if (data == null) {
			data = n.data;
			next = n.next;
		} else {
			next = n;
		}
	}
}