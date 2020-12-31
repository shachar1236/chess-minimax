public class Node {
	
	Piece data;
	Node next;
	
	public Node(Piece data) {
		this.data = data;
		next = null;
	}
	
	public void add(Piece n) {
		next = new Node(n);
	}
}