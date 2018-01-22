package de.tuberlin.sese.swtpp.gameserver.model.cannon;

import java.util.ArrayList;
import java.util.Arrays;

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
		if (!isTownPlaced()) return placeTown();
		if (!mySoldier()) return false;
		if (isTargetOwnedByMyself()) return false;
		if (startRow == targetRow && Math.abs(targetColumn-startColumn) == 1) return captureSideways();
		if (whiteNext && startRow == targetRow+1 && Math.abs(targetColumn-startColumn) < 2) return moveForward();
		if (!whiteNext && startRow == targetRow-1 && Math.abs(targetColumn-startColumn) < 2) return moveForward();
		if (whiteNext && startRow == targetRow-2 && (Math.abs(targetColumn-startColumn) == 2 || targetColumn == startColumn)) return retreat();
		if (!whiteNext && startRow == targetRow+2 && (Math.abs(targetColumn-startColumn) == 2 || targetColumn == startColumn)) return retreat();
		if (Math.abs(targetColumn-startColumn) == 4 || Math.abs(targetColumn-startColumn) == 5) return gunshot();
		if (Math.abs(targetRow-startRow) == 4 || Math.abs(targetRow-startRow) == 5) return gunshot();
		if (Math.abs(targetRow-startRow) == 3 || Math.abs(targetColumn-startColumn) == 3) return moveCannon();
		return false;
	}
	
	/*******************************
	* Field Analysis
	*******************************/
	
	private boolean mySoldier() {
		if (whiteNext) return boardState[startRow][startColumn] == 'w'; 
		return boardState[startRow][startColumn] == 'b'; 
	}
	
	private boolean isFieldFree(int row, int column) {
		return boardState[row][column] == '1';
	}
		
	private boolean isTargetTownOfOpponent() {
		if (whiteNext) {
			return boardState[targetRow][targetColumn] == 'B';
		}
		return boardState[targetRow][targetColumn] == 'W';
	}
	
	private boolean isTargetOwnedByOpponent() {
		if (whiteNext) {
			return boardState[targetRow][targetColumn] == 'b' || boardState[targetRow][targetColumn] == 'B';
		}
		return boardState[targetRow][targetColumn] == 'w' || boardState[targetRow][targetColumn] == 'W';
	}
	
	private boolean isTargetOwnedByMyself() {
		if (whiteNext) {
			return boardState[targetRow][targetColumn] == 'w' || boardState[targetRow][targetColumn] == 'W';
		}
		return boardState[targetRow][targetColumn] == 'b' || boardState[targetRow][targetColumn] == 'B';
	}
	
	private boolean isTargetFree() {
		return boardState[targetRow][targetColumn] == '1';
	}
	
	private boolean isFieldSoldierOfOpponent(int row, int column) {
		if (whiteNext) {
			return boardState[row][column] == 'b';
		}
		return boardState[row][column] == 'w';
	}
	
	private boolean isFieldOwnedByMyself(int row, int column) {
		if (whiteNext) {
			return boardState[row][column] == 'w' || boardState[row][column] == 'W';
		}
		return boardState[row][column] == 'b' || boardState[row][column] == 'B';
	}
	
	private boolean isFieldOwnedByMyselfOrFree(int row, int column) {
		if(isFieldOwnedByMyself(row, column)) {
			return true;
		}
		if (isFieldFree(row, column)) {
			return true;
		}
		return false;
		//return isFieldOwnedByMyself(row, column) || isFieldFree(row, column);
	}
			
	/*******************************
	* Move Cannon
	*******************************/
	
	private boolean moveCannon() {
		int[] row = getToBeExaminedRows(3);
		int[] column = getToBeExaminedColumns(3);
		if (isCannon(row, column) && isTargetFree()) {
			executeMove();
			return true;
		}
		return false;
	}
	
	/*******************************
	* Gunshot
	*******************************/
	
	private boolean gunshot() {
		int[] row = getToBeExaminedRows(4);
		int[] column = getToBeExaminedColumns(4);
		if (isCannon(Arrays.copyOfRange(row, 0, 3), Arrays.copyOfRange(column, 0, 3)) && isFieldFree(row[3], column[3])) {
			if (isTargetOwnedByOpponent()) {
				executeShot();
				return true;
			}
		}
		return false;
	}
	
	private boolean isCannon(int[] row, int[] column) {
		if (!(Math.abs(targetRow-startRow) == Math.abs(targetColumn-startColumn) || targetRow-startRow == 0 || targetColumn-startColumn == 0)) return false;
		char color = whiteNext ? 'w' : 'b';
		boolean isCannon = true;
		for (int i = 0; i < row.length; i++) {
					isCannon &= boardState[row[i]][column[i]] == color;
		}
		return isCannon;
	}
	
	private int[] getToBeExaminedRows(int length) {
		int[] row = new int[length];
		for (int i = 0; i < length; i++) row[i] = startRow;
		if (targetRow > startRow) for (int i = 0; i < length; i++) row[i] = startRow + i;
		if (targetRow < startRow) for (int i = 0; i < length; i++) row[i] = startRow - i;
		return row;
	}
	
	private int[] getToBeExaminedColumns(int length) {
		int[] column = new int[length];
		for (int i = 0; i < length; i++) column[i] = startColumn;
		if (targetColumn > startColumn) for (int i = 0; i < length; i++) column[i] = startColumn + i;
		if (targetColumn < startColumn) for (int i = 0; i < length; i++) column[i] = startColumn - i;
		return column;
	}
	
	/*******************************
	* Capture Sideways
	*******************************/
	
	private boolean captureSideways() {
		if (isTargetOwnedByOpponent()) {
			executeMove();
			return true;
		}
		return false;
	}
	
	/*******************************
	* Move/Capture Forward
	*******************************/
	
	private boolean moveForward() {
		executeMove();
		return true;
	}
	
	/*******************************
	* Retreat
	*******************************/
	
	private boolean retreat() {
		if (isThreatened() && isTargetFree() && isFieldFree((targetRow+startRow)/2,(targetColumn+startColumn)/2)) {
					executeMove();
					return true;		
		}
		return false;
	}
	
	private boolean isThreatened() {
		boolean isThreatend = false;
		if (startColumn > 0) isThreatend |= isFieldSoldierOfOpponent(startRow, startColumn-1);
		if (startColumn < 9) isThreatend |= isFieldSoldierOfOpponent(startRow, startColumn+1);
		if (whiteNext) {
			if (startRow > 0) {
				isThreatend |= isFieldSoldierOfOpponent(startRow-1, startColumn);
				if (startColumn > 0) isThreatend |= isFieldSoldierOfOpponent(startRow-1, startColumn-1);
				if (startColumn < 9) isThreatend |= isFieldSoldierOfOpponent(startRow-1, startColumn+1);
			}
		} else {
			if (startRow < 9) {
				isThreatend |= isFieldSoldierOfOpponent(startRow+1, startColumn);
				if (startColumn > 0) isThreatend |= isFieldSoldierOfOpponent(startRow+1, startColumn-1);
				if (startColumn < 9) isThreatend |= isFieldSoldierOfOpponent(startRow+1, startColumn+1);
			}
		}
		return isThreatend;
	}
	
	/*******************************
	* Execute Move/Shoot
	*******************************/
	
	private void executeMove() {
		if (isTargetTownOfOpponent()) {
			gameFinished = true;
		}
		if (whiteNext) {
				boardState[targetRow][targetColumn] = 'w';
		}
		if (!whiteNext) {
				boardState[targetRow][targetColumn] = 'b';
		}
		boardState[startRow][startColumn] = '1';
	}
	
	private void executeShot() {
		if (isTargetTownOfOpponent()) {
			gameFinished = true;
		}
		boardState[targetRow][targetColumn] = '1';
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
		return gameFinished |= isStalemate();
	}
	
	private boolean isStalemate() {
		ArrayList<Position> positionsOfOpponentSoldiers = getPostionsOfOpponentSoldier();
		for (Position pos : positionsOfOpponentSoldiers) {
			if (canOpponentMove(pos.getRow(), pos.getColumn())) return false;
		}
		if (opponentHasHorizontalCannon()) return false;
		return true;
	}
	
	private boolean opponentHasHorizontalCannon() {
		int count;
		for (int i = 0; i <= 9; i++) {
			count = 0;
			for (int j = 0; j <= 9; j++) {
				if (isFieldSoldierOfOpponent(i, j)) {
					count++;
				} else {
					count = 0;
				}
				if (count >= 3) return true;
			}
		}
		return false;
	}
	
	private boolean canOpponentMove(int row,int column) {
		boolean canCapture = false;
		if (column > 0) canCapture |= isFieldOwnedByMyself(row, column-1);
		if (column < 9) canCapture |= isFieldOwnedByMyself(row, column+1);
		if (whiteNext) {
			if (row < 9) {
				canCapture |= isFieldOwnedByMyself(row+1, column);
				if (column > 0) {
					canCapture |= isFieldOwnedByMyselfOrFree(row+1, column-1);
				}
				if (column < 9) {
					canCapture |= isFieldOwnedByMyselfOrFree(row+1, column+1);
				}
			}
		} else {
			if (row > 0) {
				canCapture |= isFieldOwnedByMyself(row-1, column);
				if (column > 0) {
					canCapture |= isFieldOwnedByMyselfOrFree(row-1, column-1);
				}
				if (column < 9) {
					canCapture |= isFieldOwnedByMyselfOrFree(row-1, column+1);
				}
			}
		}
		return canCapture;
	} 
		
	private ArrayList<Position> getPostionsOfOpponentSoldier() {
		ArrayList<Position> positionsOfSoldiers = new ArrayList<Position>();
		for (int row = 0; row <= 9; row++) {
			for (int column = 0; column <= 9; column++) {
				if (isFieldSoldierOfOpponent(row, column)) {
					positionsOfSoldiers.add(new Position(row, column));
				};
			}
		}
		return positionsOfSoldiers;
	}
}
