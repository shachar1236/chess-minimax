final int rows = 8;
final int cols = 8;
final int lookAhed = 5;
final int promoteReward = 200;

int cellSize;

// boolean moving = false;
// Piece movingPiece;
// Node movingPiecePossibleMoves;

// boolean promoting = false;

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
}

void draw() {
	// for (int i = 0; i < rows; i++)
	// {
	// 	for (int j = 0; j < cols; j++) {
	// 		if ((i + j) % 2 == 1) {
	// 			fill(255);
	// 		} else {
	// 			fill(30);
	// 		}
	// 		rect(i * cellSize, j * cellSize, cellSize, cellSize);
	// 	}
	// }
	
	// if (moving) {
	// 	Node move = movingPiecePossibleMoves;
	// 	while(move != null) {
	// 		fill(0, 200, 0);
	// 		ellipse(move.data.i * cellSize + cellSize / 2, move.data.j * cellSize + cellSize / 2, cellSize / 2, cellSize / 2);
	// 		move = move.next;
	// 	}
	// }
	
	// for (int i = 0; i < white.length; i++) {
	// 	if (white[i] != null) {
	// 		if (moving && movingPiece.i == white[i].i && movingPiece.j == white[i].j) {
	// 			PImage img = movingPiece.getImg();
	// 			image(img, mouseX - cellSize / 2, mouseY - cellSize / 2, cellSize * 1.2, cellSize * 1.2);
	// 		} else {
	// 			white[i].show();
	// 		}
	// 	}
	// }
	
	// for (int i = 0; i < black.length; i++) {
	// 	if (black[i] != null) {
	// 		black[i].show();
	// 	}
	// }
	// if (promoting) {
	// 	fill(200, 20, 20);
	// 	textSize(40);
	// 	text("Promote Pawn", width / 2 - 135, 300);
	// 	textSize(30);
	// 	text("Press promotion number", width / 2 - 195, 350);
	// 	text("1 - Queen", width / 2 - 115, 400);
	// 	text("2 - Knight", width / 2 - 115, 450);
	// 	text("3 - Bishop", width / 2 - 115, 500);
	// 	text("4 - Rook", width / 2 - 115, 550);
	// }
}



void mousePressed() {

}

void mouseReleased() {
	
}

// void keyPressed() {
// 	if (promoting) {
// 		if (key == '1') {
// 			for (int k = 0; k <  white.length; k++) {
// 				if (white[k] != null) {
// 					if (white[k].i == movingPiece.i && white[k].j == movingPiece.j) {
// 						white[k] = new Queen(movingPiece.i, movingPiece.j, movingPiece.side);
// 					}
// 				}
// 			}
// 		} else if (key == '2') {
// 			for (int k = 0; k <  white.length; k++) {
// 				if (white[k] != null) {
// 					if (white[k].i == movingPiece.i && white[k].j == movingPiece.j) {
// 						white[k] = new Knight(movingPiece.i, movingPiece.j, movingPiece.side);
// 					}
// 				}
// 			}
// 		} else if (key == '3') {
// 			for (int k = 0; k <  white.length; k++) {
// 				if (white[k] != null) {
// 					if (white[k].i == movingPiece.i && white[k].j == movingPiece.j) {
// 						white[k] = new Bishop(movingPiece.i, movingPiece.j, movingPiece.side);
// 					}
// 				}
// 			}
// 		} else if (key == '4') {
// 			for (int k = 0; k <  white.length; k++) {
// 				if (white[k] != null) {
// 					if (white[k].i == movingPiece.i && white[k].j == movingPiece.j) {
// 						white[k] = new Rook(movingPiece.i, movingPiece.j, movingPiece.side);
// 					}
// 				}
// 			}
// 		}
// 		promoting = false;
// 	}
// }