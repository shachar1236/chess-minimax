final int rows = 8;
final int cols = 8;
final int lookAhed = 9;
final int infinity = 1000000000;
final float evalCapturesKillPrecent = 0.01;

// int evalMult = 1;

int cellSize;

// TranspositionTable transpositionTable = new TranspositionTable(100);

boolean moving = false;
Piece movingPiece;
Node movingPiecePossibleMoves;

boolean promoting = false;


Cell lastPos = new Cell(-1, -1);
Cell currentPos = new Cell(-1, -1);

PImage PawnWhiteImg;
PImage RookWhiteImg;
PImage KnightWhiteImg;
PImage BishopWhiteImg;
PImage KingWhiteImg;
PImage QueenWhiteImg;

PImage PawnBlackImg;
PImage RookBlackImg;
PImage KnightBlackImg;
PImage BishopBlackImg;
PImage KingBlackImg;
PImage QueenBlackImg;

int board[] = new int[rows * cols];

Piece[] white = new Piece[16];
Piece[] black = new Piece[16];

void setup() {
	// evalMult = ((lookAhed + 1) % 2) - lookAhed % 2;
	// println("eval mult: " + evalMult);
	size(800, 800);
	cellSize = width / rows;
	
	PawnWhiteImg = loadImage("data/pawnWhite.png");
	PawnBlackImg = loadImage("data/pawnBlack.png");
	
	RookWhiteImg = loadImage("data/rookWhite.png");
	RookBlackImg = loadImage("data/rookBlack.png");
	
	KnightWhiteImg = loadImage("data/knightWhite.png");
	KnightBlackImg = loadImage("data/knightBlack.png");
	
	BishopWhiteImg = loadImage("data/bishopWhite.png");
	BishopBlackImg = loadImage("data/bishopBlack.png");
	
	KingWhiteImg = loadImage("data/kingWhite.png");
	KingBlackImg = loadImage("data/kingBlack.png");
	
	QueenWhiteImg = loadImage("data/queenWhite.png");
	QueenBlackImg = loadImage("data/queenBlack.png");

	setupPieces();
}

int id_to_value(int id) {
	int[] map = {Pawn.value, Rook.value, Knight.value, Bishop.value, Queen.value, King.value};
	return map[id - 1];
}


void setupPieces() {
	char[][] b = {
		{'r', 'n', 'b', 'k', 'q', 'b', 'n', 'r'},
		{'p', 'p', 'p', 'p', 'p', 'p', 'p', 'p'},
		{' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
		{' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
		{' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
		{' ', ' ', ' ', ' ', ' ', ' ', ' ', ' '},
		{'P', 'P', 'P', 'P', 'P', 'P', 'P', 'P'},
		{'R', 'N', 'B', 'K', 'Q', 'B', 'N', 'R'}
	};

	int blackIndex = 0;
	int whiteIndex = 0;

	for (int i = 0; i < 8; i++) {
		for (int j = 0; j < 8; j++) {
			char c = b[i][j];
			switch (c) {
				case 'r':
					black[blackIndex] = new Rook(j, i, -1);
					blackIndex++;
					break;
				case 'n':
					black[blackIndex] = new Knight(j, i, -1);
					blackIndex++;
					break;
				case 'b':
					black[blackIndex] = new Bishop(j, i, -1);
					blackIndex++;
					break;
				case 'k':
					black[blackIndex] = new King(j, i, -1);
					blackIndex++;
					break;
				case 'q':
					black[blackIndex] = new Queen(j, i, -1);
					blackIndex++;
					break;
				case 'p':
					black[blackIndex] = new Pawn(j, i, -1);
					blackIndex++;
					break;
				case 'R':
					white[whiteIndex] = new Rook(j, i, 1);
					whiteIndex++;
					break;
				case 'N':
					white[whiteIndex] = new Knight(j, i, 1);
					whiteIndex++;
					break;
				case 'B':
					white[whiteIndex] = new Bishop(j, i, 1);
					whiteIndex++;
					break;
				case 'K':
					white[whiteIndex] = new King(j, i, 1);
					whiteIndex++;
					break;
				case 'Q':
					white[whiteIndex] = new Queen(j, i, 1);
					whiteIndex++;
					break;
				case 'P':
					white[whiteIndex] = new Pawn(j, i, 1);
					whiteIndex++;
					break;
			}
		}
	}
	board = updateBoard(white, black);
}

void draw() {
	for (int i = 0; i < rows; i++)
	{
		for (int j = 0; j < cols; j++) {
			if ((i + j) % 2 == 1) {
				fill(255);
			} else {
				fill(30);
			}
			rect(i * cellSize, j * cellSize, cellSize, cellSize);
		}
	}

	fill(20, 40, 170);
	rect(lastPos.i * cellSize, lastPos.j * cellSize, cellSize, cellSize);
	rect(currentPos.i * cellSize, currentPos.j * cellSize, cellSize, cellSize);
	
	if (moving) {
		Node move = movingPiecePossibleMoves;
		while(move != null) {
			fill(0, 200, 0);
			ellipse(move.data.i * cellSize + cellSize / 2, move.data.j * cellSize + cellSize / 2, cellSize / 2, cellSize / 2);
			move = move.next;
		}
	}
	
	
	for (int i = 0; i < white.length; i++) {
		if (white[i] != null) {
			if (moving && movingPiece.i == white[i].i && movingPiece.j == white[i].j) {
				PImage img = movingPiece.getImg();
				image(img, mouseX - cellSize / 2, mouseY - cellSize / 2, cellSize * 1.2, cellSize * 1.2);
			} else {
				white[i].show();
			}
		}
	}
	
	for (int i = 0; i < black.length; i++) {
		if (black[i] != null) {
			black[i].show();
		}
	}
	if (promoting) {
		fill(200, 20, 20);
		textSize(40);
		text("Promote Pawn", width / 2 - 135, 300);
		textSize(30);
		text("Press promotion number", width / 2 - 195, 350);
		text("1 - Queen", width / 2 - 115, 400);
		text("2 - Knight", width / 2 - 115, 450);
		text("3 - Bishop", width / 2 - 115, 500);
		text("4 - Rook", width / 2 - 115, 550);
	}
}

int[] updateBoard(Piece[] p1, Piece[] p2) {
	int[] newBoard = new int[rows * cols];
	for (int i = 0; i < rows; i++) {
		for (int j = 0; j < cols; j++) {
			// if (board[getIndex(i, j)] != Pawn.EnPassant) {
			newBoard[getIndex(i, j)] = 0;
			// }
		}
	}
	for (int i = 0; i < p1.length; i++) {
		if (p1[i] != null) {
			newBoard[getIndex(p1[i].i, p1[i].j)] = p1[i].getId() * p1[i].side;
		}
	}
	for (int i = 0; i < p2.length; i++) {
		if (p2[i] != null) {
			newBoard[getIndex(p2[i].i, p2[i].j)] = p2[i].getId() * p2[i].side;
		}
	}
	return newBoard;
}


int evalPos(int[] board, Piece[] white, Piece[] black) {
	int score = 0;
	for (int i = 0; i < white.length; i++) {
		if (white[i] != null) {
			score -= white[i].getValue();
			score -= white[i].evalPossibleCaptures(board);
		}
		if (black[i] != null) {
			score += black[i].getValue();
			score += black[i].evalPossibleCaptures(board);
		}
	}
	return score;
}

int search(int depth, int alpha, int beta, int[] board, Piece[] white, Piece[] black, int blackTurn) {
	Piece[] player = black;
	Piece[] enemy = white;
	if (blackTurn == -1) {
		player = white;
		enemy = black;
	}

	boolean dontHaveBlackKing = true;
	boolean dontHaveWhiteKing = true;
	for (int i = 0; i < black.length; i++) {
		if (black[i] != null) {
			if (black[i].getId() == King.id) {
				dontHaveBlackKing = false;
			}
		}
		if (white[i] != null) {
			if (white[i].getId() == King.id) {
				dontHaveWhiteKing = false;
			}
		}
	}

	if (dontHaveBlackKing) {
		return - infinity * blackTurn;
	} else if (dontHaveWhiteKing) {
		return infinity * blackTurn;
	}
	
	if (depth == 0) {
		return evalPos(board, white, black) * blackTurn;
	}

	int value = -infinity;

	boolean running = true;

	Node regularMoves = new Node(null);

	for (int i = 0; i < player.length && running; i++) {
			
		if (player[i] != null) {
			
			Node move = player[i].getPossibleMoves(board, player);
			
			while(move != null) {
				Piece[] myPieces = copyPlayer(player);
				Piece[] enemyPieces = copyPlayer(enemy);
				int[] newBoard = board.clone();
				
				Cell dead = myPieces[i].move(move.data.i, move.data.j, board, myPieces);

				
				if (myPieces[i].getId() == Pawn.id) {
					if (myPieces[i].needToPromote()) {
						myPieces[i] = new Queen(myPieces[i].i, myPieces[i].j, myPieces[i].side);
					}
				}
				
				if (dead != null) {
					for (int k = 0; k <  enemyPieces.length; k++) {
						if (enemyPieces[k] != null) {
							if (enemyPieces[k].i == dead.i && enemyPieces[k].j == dead.j) {
								enemyPieces[k] = null;
								break;
							}
						}
					}
				} else {
					move.fromPos = new Cell(player[i].i, player[i].j);
					regularMoves.addNode(move);
					break;
				}
				
				newBoard = updateBoard(myPieces, enemyPieces);
				myPieces[i].updateBoard(newBoard);
				
				move = move.next;

				Piece[] w = myPieces;
				Piece[] b = enemyPieces;

				if (blackTurn == 1) {
					w = enemyPieces;
					b = myPieces;
				}

				int eval = - search(depth - 1, -beta, -alpha, newBoard, w, b, -blackTurn);

				value = max(value, eval);

				alpha = max(alpha, value);

				if (alpha > beta - 1) {
					running = false;
					break;
				}
			}
		}
	}

	Node move = regularMoves;
	if (move.data == null) {
		move = null;
	}
	int i = 0;

	while (move != null && running) {

		if (move.fromPos != null) {
			for (int k = 0; k <  player.length; k++) {
				if (player[k] != null) {
					if (player[k].i == move.fromPos.i && player[k].j == move.fromPos.j) {
						i = k;
						break;
					}
				}
			}
		}

		Piece[] myPieces = copyPlayer(player);
		Piece[] enemyPieces = copyPlayer(enemy);
		int[] newBoard = board.clone();
		
		Cell dead = myPieces[i].move(move.data.i, move.data.j, board, myPieces);
		
		if (myPieces[i].getId() == Pawn.id) {
			if (myPieces[i].needToPromote()) {
				myPieces[i] = new Queen(myPieces[i].i, myPieces[i].j, myPieces[i].side);
			}
		}
		
		if (dead != null) {
			for (int k = 0; k <  enemyPieces.length; k++) {
				if (enemyPieces[k] != null) {
					if (enemyPieces[k].i == dead.i && enemyPieces[k].j == dead.j) {
						enemyPieces[k] = null;
						break;
					}
				}
			}
		}
		
		newBoard = updateBoard(myPieces, enemyPieces);
		myPieces[i].updateBoard(newBoard);
		
		move = move.next;

		Piece[] w = myPieces;
		Piece[] b = enemyPieces;

		if (blackTurn == 1) {
			w = enemyPieces;
			b = myPieces;
		}

		int eval = - search(depth - 1, -beta, -alpha, newBoard, w, b, -blackTurn);

		value = max(value, eval);

		alpha = max(alpha, value);

		if (alpha > beta - 1) {
			running = false;
			break;
		}
	}

	return value;
}


Piece[] copyPlayer(Piece[] player) {
	Piece[] copy = new Piece[player.length];
	for (int i = 0; i < player.length; i++) {
		if (player[i] != null) {
			copy[i] = player[i].clone();
		}
	}
	return copy;
}

PieceMove pickMove() {
	Cell bestMove = null;
	Cell moveIndex = null;
	int best = - infinity;
	
	for (int i = 0; i < black.length; i++) {
		
		if (black[i] != null) {
			
			Node move = black[i].getPossibleMoves(board, black);
			
			while(move != null) {
				
				Piece[] myPieces = copyPlayer(black);
				Piece[] enemyPieces = copyPlayer(white);
				int[] newBoard = board.clone();
				
				Cell dead = myPieces[i].move(move.data.i, move.data.j, board, myPieces);
				
				if (myPieces[i].getId() == Pawn.id) {
					if (myPieces[i].needToPromote()) {
						myPieces[i] = new Queen(myPieces[i].i, myPieces[i].j, myPieces[i].side);
					}
				}
				
				if (dead != null) {
					for (int k = 0; k <  enemyPieces.length; k++) {
						if (enemyPieces[k] != null) {
							if (enemyPieces[k].i == dead.i && enemyPieces[k].j == dead.j) {
								enemyPieces[k] = null;
							}
						}
					}
				}
				
				newBoard = updateBoard(myPieces, enemyPieces);
				myPieces[i].updateBoard(newBoard);
				int value = -search(lookAhed - 1, - infinity, infinity, newBoard, enemyPieces, myPieces, -1);
				// println("main value: " + value);
				// int value = minimax(lookAhed - 1, - infinity, infinity, false, newBoard, enemyPieces, myPieces);
				
				if (value > best) {
					best = value;
					bestMove = move.data;
					moveIndex = new Cell(black[i].i, black[i].j);
				}
				
				move = move.next;
			}
		}
	}
	
	println("best: " + best);
	return new PieceMove(moveIndex, bestMove);
}

void mousePressed() {
	if (!promoting) {
		Piece[] playerPieces = white;
		
		int i = floor(mouseX / cellSize);
		int j = floor(mouseY / cellSize);
		
		boolean valid = false;
		Piece piece = null;
		
		for (int k = 0; k < playerPieces.length; k++) {
			if (playerPieces[k] != null) {
				if (playerPieces[k].i == i && playerPieces[k].j == j) {
					valid = true;
					piece = playerPieces[k];
					break;
				}
			}
		}
		
		if (valid) {
			moving = true;
			movingPiece = piece;
			movingPiecePossibleMoves = piece.getPossibleMoves(board, playerPieces);
			Node current = movingPiecePossibleMoves;
			Node last = current;
			boolean first = true;
			while (current != null) {
				boolean changed = false;
				if (!isLegalMove(i, j, current.data, white, board)) {
					if (!first) {
						last.next = current.next;
					} else {
						movingPiecePossibleMoves = movingPiecePossibleMoves.next;
						changed = true;
					}
				} else {
					last = current;
				}
				current = current.next;
				if (!changed) {
					first = false;
				}
			}
		}
	}
	
}

void mouseReleased() {
	
	Piece[] playerPieces = white;
	Piece[] enemyPieces = black;
	
	moving = false;
	int i = floor(mouseX / cellSize);
	int j = floor(mouseY / cellSize);
	
	boolean valid = false;
	Node move = movingPiecePossibleMoves;
	
	while(move != null) {
		if (move.data.i == i && move.data.j == j) {
			valid = true;
			// movingPiece.firstMove = false;
			break;
		}
		move = move.next;
	}

	if (i == movingPiece.i && j == movingPiece.j) {
		valid = false;
	}
	
	if (inRange(i) && inRange(j) && valid) {
		Cell dead = movingPiece.move(i, j, board, playerPieces);
		if (movingPiece.getId() == Pawn.id) {
			if (movingPiece.needToPromote()) {
				promoting = true;
			}
		}

		if (dead != null) {
			for (int k = 0; k <  enemyPieces.length; k++) {
				if (enemyPieces[k] != null) {
					if (enemyPieces[k].i == dead.i && enemyPieces[k].j == dead.j) {
						enemyPieces[k] = null;
					}
				}
			}
		}
		board = updateBoard(white, black);
		movingPiece.updateBoard(board);
		
		draw();
		
		PieceMove computerMove = pickMove();
		
		Piece piece = null;
		int pieceIndex = 0;
		for (int k = 0; k < black.length; k++) {
			if (black[k] != null) {
				if (black[k].i == computerMove.pos.i && black[k].j == computerMove.pos.j) {
					piece = black[k];
					pieceIndex = k;
					break;
				}
			}
		}

		lastPos.i = piece.i;
		lastPos.j = piece.j;
		currentPos.i = computerMove.move.i;
		currentPos.j = computerMove.move.j;
		
		dead = piece.move(computerMove.move.i, computerMove.move.j, board, black);
		
		if (piece.getId() == Pawn.id) {
			if (piece.needToPromote()) {
				black[pieceIndex] = new Queen(piece.i, piece.j, piece.side);
			}
		}
		
		if (dead != null) {
			for (int k = 0; k <  white.length; k++) {
				if (white[k] != null) {
					if (white[k].i == dead.i && white[k].j == dead.j) {
						white[k] = null;
					}
				}
			}
		}
		
		board = updateBoard(white, black);
		piece.updateBoard(board);
		
		// transpositionTable.pr();
		
	}
	println();
	for (int a = 0; a < 8; a++) {
		for (int b = 0; b < 8; b++) {
			print(board[getIndex(b, a)]);
			print(" ");
		}
		println();
	}
}

void keyPressed() {
	if (promoting) {
		if (key == '1') {
			for (int k = 0; k <  white.length; k++) {
				if (white[k] != null) {
					if (white[k].i == movingPiece.i && white[k].j == movingPiece.j) {
						white[k] = new Queen(movingPiece.i, movingPiece.j, movingPiece.side);
					}
				}
			}
		} else if (key == '2') {
			for (int k = 0; k <  white.length; k++) {
				if (white[k] != null) {
					if (white[k].i == movingPiece.i && white[k].j == movingPiece.j) {
						white[k] = new Knight(movingPiece.i, movingPiece.j, movingPiece.side);
					}
				}
			}
		} else if (key == '3') {
			for (int k = 0; k <  white.length; k++) {
				if (white[k] != null) {
					if (white[k].i == movingPiece.i && white[k].j == movingPiece.j) {
						white[k] = new Bishop(movingPiece.i, movingPiece.j, movingPiece.side);
					}
				}
			}
		} else if (key == '4') {
			for (int k = 0; k <  white.length; k++) {
				if (white[k] != null) {
					if (white[k].i == movingPiece.i && white[k].j == movingPiece.j) {
						white[k] = new Rook(movingPiece.i, movingPiece.j, movingPiece.side);
					}
				}
			}
		}
		promoting = false;
	}
}

boolean inRange(int num) {
	return num > - 1 && num < 8;
}

int getIndex(int i, int j) {
	return i * rows + j;
}

boolean isEmpty(int i, int j, int[] board) {
	int value = board[getIndex(i, j)];
	return value == 0 || Math.abs(value) == Pawn.EnPassant;
}

boolean isEmptyOrEnemy(int i, int j, int side, int[] board) {
	int value = board[getIndex(i, j)];
	return value * side < 1 || Math.abs(value) == Pawn.EnPassant;
}

boolean isEnemy(int i, int j, int side, int[] board) {
	int value = board[getIndex(i, j)];
	return value * side < 0 && Math.abs(value) != Pawn.EnPassant;
}

boolean isMySide(int i, int j, int side, int[] board) {
	int value = board[getIndex(i, j)];
	return value * side > 0 && Math.abs(value) != Pawn.EnPassant;
}

boolean isLegalMove(int i, int j, Cell moveTo, Piece[] p, int[] _board) {
	int[] board = _board.clone();

	Piece king = null;

	for (int a = 0; a < p.length; a++) {
		if (p[a] != null) {
			if (p[a].getId() == King.id) {
				king = p[a];
				break;
			}
		}
	}

	int piece = board[getIndex(i, j)];
	board[getIndex(i, j)] = 0;
	board[getIndex(moveTo.i, moveTo.j)] = piece;

	if (abs(piece) == King.id) {
		king = king.clone();
		king.i = moveTo.i;
		king.j = moveTo.j;
	}

	return !isInCheck(king, board);
}

boolean isInCheck(Piece king, int[] board) {
	int side = king.side;

	for (int a = - 1; a < 2; a += 2) {
		
		// rook
		int move = 1;
		while(inRange(king.i + a * move)) {
			if (isMySide(king.i + a * move, king.j, side, board)) {
				break;
			}
			if (isEnemy(king.i + a * move, king.j, side, board)) {
				int enemy = board[getIndex(king.i + a * move, king.j)] * side * -1;
				if (enemy == Rook.id || enemy == Queen.id) {
					return true;
				}
				break;
			}
			move += 1;
		}
		
		// rook
		move = 1;
		while(inRange(king.j + a * move)) {
			if (isMySide(king.i, king.j + a * move, side, board)) {
				break;
			}
			if (isEnemy(king.i, king.j + a * move, side, board)) {
				int enemy = board[getIndex(king.i, king.j + a * move)] * side * -1;
				if (enemy == Rook.id || enemy == Queen.id) {
					return true;
				}
				break;
			}
			move += 1;
		}
		
		for (int b = - 1; b < 2; b += 2) {
			// bishop
			move = 1;
			while(inRange(king.i + a * move) && inRange(king.j + b * move)) {
				if (isMySide(king.i + a * move, king.j + b * move, side, board)) {
					break;
				}
				if (isEnemy(king.i + a * move, king.j + b * move, side, board)) {
					int enemy = board[getIndex(king.i + a * move, king.j + b * move)] * side * -1;
					if (enemy == Bishop.id || enemy == Queen.id || (enemy == Pawn.id && move == 1)) {
						return true;
					}
					break;
				}
				move += 1;
			}
			
			// knight
			if (inRange(king.i + a * 2) && inRange(king.j + b)) {
				    if (isEnemy(king.i + a * 2, king.j + b, side, board)) {
						int enemy = board[getIndex(king.i + a * 2, king.j + b)] * side * -1;
						if (enemy == Knight.id) {
							return true;
						}
					}
				}
			if (inRange(king.i + a) && inRange(king.j + b * 2)) {
				if (isEnemy(king.i + a, king.j + b * 2, side, board)) {
					int enemy = board[getIndex(king.i + a, king.j + b * 2)] * side * -1;
					if (enemy == Knight.id) {
						return true;
					}
				}
			}
		}
	}

	return false;
}