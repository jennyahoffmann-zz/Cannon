package de.tuberlin.sese.swtpp.gameserver.model;

import java.io.Serializable;

/**
 * Container class for user statistics values.
 *
 */
public class Statistics implements Serializable{
	
	private static final long serialVersionUID = -4716603786323427507L;

	/**********************************
	 * Member
	 **********************************/
	
	// attributes
	public int numWon;
	public int numLost;
	public int numDraw;
	public double avgMoves;
	public double percentWon;
	public double percentDraw;
	public double percentLost;

	/**********************************
	 * Derived values (for tournament)
	 **********************************/
	public int points() {
		return numWon * 3 + numDraw;
	}
	
	public float avgPoints() {
		int games = numWon + numLost + numDraw;
		
		if (games==0) return (float)0;
		else return (float)points() / (float)games;
	}
}
