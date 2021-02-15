final int rows = 8;
final int cols = 8;
final int lookAhed = 5;
final int infinity = 1000000000;

int cellSize;

// TranspositionTable transpositionTable = new TranspositionTable(100);

boolean moving = false;
Piece movingPiece;
Node movingPiecePossibleMoves;

boolean promoting = false;

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

// Piece[] white = {
// 	new Pawn(0, 6, 1), new Pawn(1, 6, 1), new Pawn(2, 6, 1), new Pawn(3, 6, 1), new Pawn(4, 6, 1), new Pawn(5, 6, 1), new Pawn(6, 6, 1), new Pawn(7, 6, 1),
// 		new Rook(0, 7, 1), new Knight(1, 7, 1),  new Bishop(2, 7, 1), new King(3, 7, 1), new Queen(4, 7, 1), new Bishop(5, 7, 1), new Knight(6, 7, 1), new Rook(7, 7, 1)
// 	};

// Piece[] black = {
// 	new Rook(0, 0, - 1), new Knight(1, 0, - 1),  new Bishop(2, 0, - 1), new Queen(4, 0, - 1), new King(3, 0, - 1), new Bishop(5, 0, - 1), new Knight(6, 0, - 1), new Rook(7, 0, - 1),
// 		new Pawn(0, 1, - 1), new Pawn(1, 1, - 1), new Pawn(2, 1, - 1), new Pawn(3, 1, - 1), new Pawn(4, 1, - 1), new Pawn(5, 1, - 1), new Pawn(6, 1, - 1), new Pawn(7, 1, - 1),
// 	};

Piece[] white = new Piece[16];
Piece[] black = new Piece[16];

void setup() {
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
		}
	}
	for (int i = 0; i < black.length; i++) {
		if (black[i] != null) {
			score += black[i].getValue();
		}
	}
	return score;
}

int minimax(int depth, int alpha, int beta, boolean maximizing, int[] board, Piece[] white, Piece[] black) {
	boolean dontHaveBlackKing = true;
	boolean dontHaveWhiteKing = true;
	for (int i = 0; i < board.length; i++) {
		if (board[i] == - King.id) {
			dontHaveBlackKing = false;
		} else if (board[i] == King.id) {
			dontHaveWhiteKing = false;
		}
	}
	
	if (dontHaveBlackKing) {
		return - infinity;
	} else if (dontHaveWhiteKing) {
		return infinity;
	}
	
	if (depth == 0) {
		return evalPos(board, white, black);
	}
	
	// if (random(0, 1) < 0.005) {
	// 	println("score: " + score);
	// 	println("depth: " + depth);
	// 	println("maximizing: " + maximizing);
	// }
	
	if (maximizing) {
		
		int best = - infinity;
		for (int i = 0; i < black.length; i++) {
			
			if (black[i] != null) {
				
				Node move = black[i].getPossibleMoves(board, black);
				
				while(move != null) {
					
					// int currentScore = score;
					
					Piece[] myPieces = copyPlayer(black);
					Piece[] enemyPieces = copyPlayer(white);
					int[] newBoard = board.clone();
					
					Cell dead = myPieces[i].move(move.data.i, move.data.j, board, myPieces);
					
					if (myPieces[i].getId() == Pawn.id) {
						if (myPieces[i].needToPromote()) {
							myPieces[i] = new Queen(myPieces[i].i, myPieces[i].j, myPieces[i].side);
							// currentScore += promoteReward;
						}
					}
					
					if (dead != null) {
						for (int k = 0; k <  enemyPieces.length; k++) {
							if (enemyPieces[k] != null) {
								if (enemyPieces[k].i == dead.i && enemyPieces[k].j == dead.j) {
									// currentScore += enemyPieces[k].getValue();
									enemyPieces[k] = null;
								}
							}
						}
					}
					
					newBoard = updateBoard(myPieces, enemyPieces);
					myPieces[i].updateBoard(newBoard);
					
					int value = minimax(depth - 1, alpha, beta, false, newBoard, enemyPieces, myPieces);
					
					best = max(best, value);
					
					alpha = max(alpha,  value);
					
					if (beta < alpha + 1) {
						// println(score);
						break;
					}
					
					move = move.next;
				}
			}
		}
		return best;
	} else {
		int best = infinity;

		for (int i = 0; i < white.length; i++) {
			
			if (white[i] != null) {
				
				Node move = white[i].getPossibleMoves(board, white);
				
				while(move != null) {
					
					// int currentScore = score;
					
					Piece[] myPieces = copyPlayer(white);
					Piece[] enemyPieces = copyPlayer(black);
					int[] newBoard = board.clone();
					
					Cell dead = myPieces[i].move(move.data.i, move.data.j, board, myPieces);
					
					if (myPieces[i].getId() == Pawn.id) {
						if (myPieces[i].needToPromote()) {
							myPieces[i] = new Queen(myPieces[i].i, myPieces[i].j, myPieces[i].side);
							// currentScore -= promoteReward;
						}
					}
					
					if (dead != null) {
						for (int k = 0; k <  enemyPieces.length; k++) {
							if (enemyPieces[k] != null) {
								if (enemyPieces[k].i == dead.i && enemyPieces[k].j == dead.j) {
									// currentScore -= enemyPieces[k].getValue();
									enemyPieces[k] = null;
								}
							}
						}
					}
					
					newBoard = updateBoard(myPieces, enemyPieces);
					myPieces[i].updateBoard(newBoard);
					
					int value = minimax(depth - 1, alpha, beta, true, newBoard, myPieces, enemyPieces);
					
					best = min(best, value);
					
					beta = min(beta, value);
					
					if (beta < alpha + 1) {
						break;
					}
					
					move = move.next;
				}
			}
		}
		return best;
	}
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
				int value = minimax(lookAhed - 1, - infinity, infinity, false, newBoard, enemyPieces, myPieces);
				
				if (value > best) {
					best = value;
					bestMove = move.data;
					moveIndex = new Cell(black[i].i, black[i].j);
				}
				
				move = move.next;
			}
		}
	}
	
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