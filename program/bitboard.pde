public class Bitboard {
    
    static final int width = 8;
    static final int height = 8;
    static final int size = width * height;

    long white_pawns = 0L;
    long white_rooks = 0L;
    long white_knights = 0L;
    long white_bishops = 0L;
    long white_queens = 0L;
    long white_king = 0L;

    long black_pawns = 0L;
    long black_rooks = 0L;
    long black_knights = 0L;
    long black_bishops = 0L;
    long black_queens = 0L;
    long black_king = 0L;

    public static void setupBoard() {
        String chessBoard[][]={
                {"r","n","b","q","k","b","n","r"},
                {"p","p","p","p","p","p","p","p"},
                {" "," "," "," "," "," "," "," "},
                {" "," "," "," "," "," "," "," "},
                {" "," "," "," "," "," "," "," "},
                {" "," "," "," "," "," "," "," "},
                {"P","P","P","P","P","P","P","P"},
                {"R","N","B","Q","K","B","N","R"}};
        arrayToBitboards(chessBoard);
    }

    public static void arrayToBitboards(String[][] chessBoard) {
        String Binary;
        for (int i=0;i<64;i++) {
            Binary="0000000000000000000000000000000000000000000000000000000000000000";
            Binary=Binary.substring(i+1)+"1"+Binary.substring(0, i);
            switch (chessBoard[i/8][i%8]) {
                case "P": white_pawns+=convertStringToBitboard(Binary);
                    break;
                case "N": white_knights+=convertStringToBitboard(Binary);
                    break;
                case "B": white_bishops+=convertStringToBitboard(Binary);
                    break;
                case "R": white_rooks+=convertStringToBitboard(Binary);
                    break;
                case "Q": white_queens+=convertStringToBitboard(Binary);
                    break;
                case "K": white_king+=convertStringToBitboard(Binary);
                    break;
                case "p": black_pawns+=convertStringToBitboard(Binary);
                    break;
                case "n": black_knights+=convertStringToBitboard(Binary);
                    break;
                case "b": black_bishops+=convertStringToBitboard(Binary);
                    break;
                case "r": black_rooks+=convertStringToBitboard(Binary);
                    break;
                case "q": black_queens+=convertStringToBitboard(Binary);
                    break;
                case "k": black_king+=convertStringToBitboard(Binary);
                    break;
            }
        }
    }

    public static long convertStringToBitboard(String Binary) {
        if (Binary.charAt(0)=='0') {//not going to be a negative number
            return Long.parseLong(Binary, 2);
        } else {
            return Long.parseLong("1"+Binary.substring(2), 2)*2;
        }
    }

    Bitboard() {
        setupBoard();
    }

    Node getWhitePawnMoves() {
        lng moves
    }

}