public class Node {
	
	PVector data;
	Node next;
	
	public Node(PVector data) {
		this.data = data;
		next = null;
	}
	
	public void add(PVector n) {
		next = new Node(n);
	}
}