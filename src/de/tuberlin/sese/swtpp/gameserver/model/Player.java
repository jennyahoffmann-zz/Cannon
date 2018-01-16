package de.tuberlin.sese.swtpp.gameserver.model;

import java.io.Serializable;

/**
 * The Player represents a User in one specific game. This way the user can act as a Player 
 * in many games with different attribute values in each of them.
 *
 */
public class Player implements Serializable{

	private static final long serialVersionUID = -7102992782236150705L;
	
	/**********************************
	 * Member
	 **********************************/
	
	// attributes
	private boolean requestedDraw = false;
	private boolean gaveUp = false;
	private boolean winner = false;
			
	// associations
	private User user = null;
	private Game game = null;
	
	/**********************************
	 * Constructors
	 **********************************/
	
	public Player(User u, Game g) {
		user = u;
		game = g;
	}
	
	/**********************************
	 * Getter/Setter/Helper
	 **********************************/
	
	public void finishGame() {
		user.finishGame(this);
	}
	
	public String getName() {
		if (user != null) return user.getName(); 
		return "";
	}
	
	public User getUser() {
		return user;
	}
	
	public Game getGame() {
		return game;
	}
	
	public boolean isWinner() {
		return winner;
	}
	
	public boolean surrendered() {
		return gaveUp;
	}
	
	public boolean requestedDraw()  {
		return requestedDraw;
	}
	
	public void requestDraw() {
		requestedDraw = true;
	}

	public void surrender() {
		gaveUp = true;
	}

	public void setWinner() {
		winner = true;
	}
	
}
