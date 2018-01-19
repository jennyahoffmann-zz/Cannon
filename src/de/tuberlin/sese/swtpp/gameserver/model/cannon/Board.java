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
	
	private char[][] boardState = {row0, row1, row2, row3, row4, row5, row6, row7, row8, row9};
	//boardState[row][column]
	
	private boolean whiteTownPlaced = false;
	private boolean blackTownPlaced = false;
	
	private boolean whiteNext = false;
	
	private int targetRow = 0;
	private int targetColumn = 0;
	private int startRow = 0;
	private int startColumn = 0;
	
	private boolean gameFinished = false;
	
	
	/*******************************
	* Board State
	*******************************/
	
	public String getBoard() {
		String boardStateString = "";
		
		for (char[] row : boardState) {
			int column = 9;
			while (column >= 0) {
				int emptyFields = 0;
				if (row[column] == '1') {
					while (column >= 0 && row[column] == '1') {
						emptyFields++;
						column--;
					}
					if (emptyFields == 10) {
						break;
					}
					boardStateString = Integer.toString(emptyFields) + boardStateString;
				} else {
					boardStateString = row[column] + boardStateString;
					column--;
				}
			}
			boardStateString = "/" + boardStateString;
		}
		return boardStateString.substring(1, boardStateString.length());
	}
	
	public void setBoard(String state) {
		int column;
		char[] newStateRowChars;
		String[] newStateRows = state.split("/");
		clearBoard();
		for (int row = 0; row < newStateRows.length; row++) {
			column = 0;
			if (newStateRows[row].length() == 0) { // row empty
				for (int i = column; i <= 9; i++ ) {
					boardState[9-row][i] = '1';
				}
			} else {
				newStateRowChars = newStateRows[row].toCharArray();
				for (char c : newStateRowChars) {
					if (c == 'b' || c == 'B' || c == 'w' || c == 'W' ) {
						if(c == 'B') blackTownPlaced = true;
						if(c == 'W') whiteTownPlaced = true;
						boardState[9-row][column] = c;
						column++;
					} else {
						for (int i = column; column < i+Character.getNumericValue(c); column++) {
							boardState[9-row][column] = '1';
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
		if (c == 'a') return 0;
		if (c == 'b') return 1;
		if (c == 'c') return 2;
		if (c == 'd') return 3;
		if (c == 'e') return 4;
		if (c == 'f') return 5;
		if (c == 'g') return 6;
		if (c == 'h') return 7;
		if (c == 'i') return 8;
		return 9;
	}
	
	/*******************************
	* Try Move
	*******************************/

	public boolean tryMove(String moveString, boolean whiteNext) {
		this.whiteNext = whiteNext;
		mapMoveString(moveString);
		if (!isTownPlaced()) {
			return placeTown();
		} else {
			if (!mySoldier()) return false;
			if (startRow == targetRow && (targetColumn == startColumn-1 || targetColumn == startColumn+1)) return captureSidewards();
			if (whiteNext && startRow == targetRow+1 && (Math.abs(targetColumn-startColumn)<2)) return moveForward();
			if (!whiteNext && startRow == targetRow-1 && (Math.abs(targetColumn-startColumn)<2)) return moveForward();
		}
		return false;
	}
	
	private boolean mySoldier() {
		if (whiteNext) return boardState[startRow][startColumn] == 'w'; 
		return boardState[startRow][startColumn] == 'b'; 
	}
	
	/*******************************
	* Capture Sidewards
	*******************************/
	
	private boolean captureSidewards() {
		if (whiteNext && boardState[targetRow][targetColumn] == 'B') {
			executeMove();
			gameFinished = true;
			return true;
		}
		if (whiteNext && boardState[targetRow][targetColumn] == 'b') {
			executeMove();
			return true;
		}
		if (!whiteNext && boardState[targetRow][targetColumn] == 'W') {
			executeMove();
			gameFinished = true;
			return true;
		}
		if (!whiteNext && boardState[targetRow][targetColumn] == 'w') {
			executeMove();
			return true;
		}
		return false;
	}
	
	/*******************************
	* Move/Capture Forward
	*******************************/
	
	private boolean moveForward() {
		if (boardState[targetRow][targetColumn] == '1') {
			executeMove();
			return true;
		}
		if (whiteNext && boardState[targetRow][targetColumn] == 'b') {
			executeMove();
			return true;
		}
		if (whiteNext && boardState[targetRow][targetColumn] == 'B') {
			executeMove();
			gameFinished = true;
			return true;
		}
		if (!whiteNext && boardState[targetRow][targetColumn] == 'w') {
			executeMove();
			return true;
		}
		if (!whiteNext && boardState[targetRow][targetColumn] == 'W') {
			executeMove();
			gameFinished = true;
			return true;
		}
		return false;
	}
	
	/*******************************
	* Execute Move/Shoot
	*******************************/
	
	private void executeMove() {
		if (whiteNext) {
				boardState[targetRow][targetColumn] = 'w';
		}
		if (!whiteNext) {
				boardState[targetRow][targetColumn] = 'b';
		}
		boardState[startRow][startColumn] = '1';
	}
	
	/*******************************
	* Place Town
	*******************************/
	
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
				return whiteTownPlaced = true;
			}
			if (!whiteNext && targetRow == 0) {
				boardState[targetRow][targetColumn] = 'B';
				return blackTownPlaced = true;
			}
		}
		return false;
	}
	
	/*******************************
	* Is Game Finished?
	*******************************/
	
	public boolean isGameFinished() {
		return gameFinished;
	}
	

}
