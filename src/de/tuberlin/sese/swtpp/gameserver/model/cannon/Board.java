package de.tuberlin.sese.swtpp.gameserver.model.cannon;

public class Board {
	//						A   B   C   D   E   F   G   H   I   J
	private char[] row9 = {'1','1','1','1','1','1','1','1','1','1'};
	private char[] row8 = {'1','w','1','w','1','w','1','w','1','w'};
	private char[] row7 = {'1','w','1','w','1','w','1','w','1','w'};
	private char[] row6 = {'1','w','1','w','1','w','1','w','1','w'};
	private char[] row5 = {'1','1','1','1','1','1','1','1','1','1'};
	private char[] row4 = {'1','1','1','1','1','1','1','1','1','1'};
	private char[] row3 = {'b','1','b','1','b','1','b','1','b','1'};
	private char[] row2 = {'b','1','b','1','b','1','b','1','b','1'};
	private char[] row1 = {'b','1','b','1','b','1','b','1','b','1'};
	private char[] row0 = {'1','1','1','1','1','1','1','1','1','1'};
	
	private char[][] boardState = {row9, row8, row7, row6, row5, row4, row3, row2, row1, row0};
	//boardState[row][column]
	
	private boolean whiteTownPlaced = false;
	private boolean blackTownPlaced = false;
	
	private boolean whiteNext = false;
	
	private int targetRow = 0;
	private int targetColumn = 0;
	private int startRow = 0;
	private int startColumn = 0;
	
	
	/*******************************
	* Board State
	*******************************/
	
	public String getBoard() {
		String boardStateString = "";
		
		for (char[] row : boardState) {
			int column = 0;
			while (column <= 9) {
				int emptyFields = 0;
				if (row[column] == '1') {
					while (column <= 9 && row[column] == '1') {
						emptyFields++;
						column++;
					}
					if (emptyFields == 10) {
						break;
					}
					boardStateString = boardStateString + Integer.toString(emptyFields);
				} else {
					boardStateString = boardStateString + row[column];
					column++;
				}
			}
			boardStateString = boardStateString + "/";
		}
		return boardStateString.substring(0, boardStateString.length() -1);
	}
	
	public void setBoard(String state) {
		int column;
		char[] newStateRowChars;
		String[] newStateRows = state.split("/");
		clearBoard();
		for (int row = 0; row < newStateRows.length; row++) {
			column = 0;
			// row empty
			if (newStateRows[row].length() == 0) {
				for (int i = column; i <= 9; i++ ) {
					boardState[row][i] = '1';
				}
			} else {
				newStateRowChars = newStateRows[row].toCharArray();
				for (char c : newStateRowChars) {
					if (c == 'b' || c == 'B' || c == 'w' || c == 'W' ) {
						if(c == 'B') blackTownPlaced = true;
						if(c == 'W') whiteTownPlaced = true;
						boardState[row][column] = c;
						column++;
					} else {
						for (int i = column; column < i+Character.getNumericValue(c); column++) {
							boardState[row][column] = '1';
						}
					}
				}
			}
		}
	}

	private void clearBoard() {
		for (int i = 0; i <= 9; i++) {
			for (int j = 0; j <= 9; j++) {
				boardState[i][j] = '1';
			}
		}
	}
	
	/*******************************
	 * Coordinate Mapping
	 ******************************/
	
	private void mapMoveString(String moveString) {
		char[] c = moveString.toCharArray();
		startColumn = convertChar(c[0]);
		startRow = Character.getNumericValue(c[1]);
		targetColumn = convertChar(c[3]);
		targetRow = Character.getNumericValue(c[4]);
	}
	
	private int convertChar(char c) {
		return c == 'a'? 0 : c == 'b'? 1 : c == 'c'? 2 : c == 'd'? 3 : c == 'e'? 4 : c == 'f'? 5 : c == 'g'? 6 : c == 'h'? 7 : c == 'i'? 8 : 9;
	}
	
	/*******************************
	* Try Move
	*******************************/

	public boolean tryMove(String moveString, boolean whiteNext) {
		this.whiteNext = whiteNext;
		mapMoveString(moveString);
		
		if (isTownPlaced()) {
			return placeTown();
		}
		// is move valid
		return false;
	}
	
	private boolean isTownPlaced() {
		if (whiteNext) {
			return whiteTownPlaced;
		}
		return blackTownPlaced;
	}
	
	private boolean placeTown() {
		// coordinates valid
		if (startRow == targetRow && startColumn == targetColumn && targetColumn != 0 && targetColumn != 9) {
			if (whiteNext && targetRow == 9) {
				boardState[targetRow][targetColumn] = 'W';
				whiteTownPlaced = true;
			}
			if (!whiteNext && targetRow == 0) {
				boardState[targetRow][targetColumn] = 'B';
				blackTownPlaced = true;
			}
		}
		return false;
	}
	
	public boolean isGameFinished() {
		// TODO Auto-generated method stub
		return false;
	}
	

}
