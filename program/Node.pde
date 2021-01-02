public class Node {
	
	Cell data;
	Node next;
	
	public Node(Cell data) {
		this.data = data;
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
}