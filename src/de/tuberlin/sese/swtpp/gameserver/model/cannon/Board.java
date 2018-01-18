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
	
	/***********************
	* Board State
	***********************/
	
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
					continue;
				}
				if (row[column] == 'b' || row[column] == 'B' || row[column] == 'w' || row[column] == 'W') {
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
	

}
