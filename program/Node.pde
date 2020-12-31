public class Node {
	
	PVector data;
	Node next;
	
	public Node(PVector data) {
		this.data = data;
		next = null;
	}
	
	public Node add(PVector n) {
		if (data == null) {
			data = n;
			return this;
		}
		next = new Node(n);
		return next;
	}
}