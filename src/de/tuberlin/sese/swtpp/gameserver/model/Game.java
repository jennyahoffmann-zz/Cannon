package de.tuberlin.sese.swtpp.gameserver.model;

import java.io.Serializable;
import java.util.LinkedList;
import java.util.List;

public abstract class Game implements Serializable{
	
	private static final long serialVersionUID = 2467695635164175201L;
	
	/**********************************
	 * Member
	 **********************************/
	
	// attributes (game status)
	protected int ID;
	protected boolean started = false;      // game is started
	protected boolean finished = false;     // game is over
	protected boolean draw = false;         // draw game; must be finished
	protected boolean surrendered = false;  // someone gave up; must be finished
	
	// associations 
	protected List<Player> players = new LinkedList<Player>();
	protected List<Move> history = new LinkedList<Move>();
	protected Player nextPlayer = null;

	// to create unique gameIDs
	protected static int lastID = 0;
	protected static synchronized int createID() {return lastID++;}
	public static synchronized int getLastID() {return lastID;}
	
	// this flag is only to restart a game when an error occurred. required for tournament
	protected boolean error = false;        
	protected final long createdTime = System.currentTimeMillis();
	
	/**********************************
	 * Constructors
	 **********************************/
	public Game() {
			ID = createID();
	}
	
	/**********************************
	 * Getter/Setter/Helper
	 **********************************/
	
	public List<Move> getHistory() {
		return history;
	}

	public static void setLastID(int id) {
		lastID = id;
	}
	
	public int getGameID() {
		return ID;
	}
	
	public long getCreatedTime() {
		return createdTime;
	}

	public boolean isStarted() {
		return started;
	}

	public boolean isFinished() {
		return finished;
	}

	public boolean isDraw() {
		return draw;
	}

	public boolean isSurrendered() {
		return surrendered;
	}
	
	public Player getNextPlayer() {
		return nextPlayer;
	}

	public List<Player> getPlayers() {
		return players;
	}
	
	public boolean isPlayer(User u) {
		for (Player p: players) {
			if (p.getUser() == u) return true;
		}
		return false;
	}
	
	public Player getPlayer(User u) {
		for (Player p: players) {
			if (p.getUser() == u) return p;
		}
		return null;
	}
	
	
	public int getMoveCount() {
		return history.size();
	}

	public boolean isError() {
		return error;
	}

	public void setError(boolean error) {
		this.error = error;
	}

	public boolean isItMyTurn(User u) {
		if (started && !finished) {
			return u == nextPlayer.getUser();
		}
		return false;
	}
	
	public boolean isItMyTurn(Player p) {
		if (started) {
			return p == nextPlayer;
		}
		return false;
	}
		
	/**********************************
	 * Local single game functionality
	 **********************************/

	/** 
	 * Returns a String representation of the game state (Zustand), e.g. a String describing
	 * the figures of the game board and its figures/positions.
	 * 
	 * @return
	 */
	public abstract String getBoard();
	
	/**
	 * Returns a String representations of the game state (Status), e.g. values such as finished,
	 * started, etc.
	 * 
	 * @return
	 */
	public abstract String getStatus();

	/**
	 * Returns additional info about the game state/status to the outside (GUI)
	 * 
	 * @return Info String (Format left to concrete implementation)
	 */
	public abstract String gameInfo();

	/**
	 * Adds a player to the game if possible.
	 * 
	 * @param player
	 * @return true iff successfully added
	 */
	public abstract boolean addPlayer(Player player);

	/**
	 * 
	 * @return The minimum number of players to start a concrete game.
	 */
	public abstract int getMinPlayers();
	
	/**
	 * 
	 * @return The maximum number of players to join the concrete game.
	 */
	
	public abstract int getMaxPlayers();

	/**
	 * This method checks if the supplied move is possible to perform 
	 * in the current game state/status and, if so, does it.
	 * The following has to be checked/might be changed:
	 * - it has to be checked if the move can be performed
	 * ---- it is a valid move
	 * ---- it is done by the right player
	 * ---- there is no other move that the player is forced to perform
	 * - if the move can be performed, the following has to be done:
	 * ---- the board state has to be updated (e.g. figures moved/deleted)
	 * ---- the board status has to be updated (check if game is finished)
	 * ---- the next player has to be set (if move is over, it's next player's turn)
	 * ---- history is updated
	 * 
	 * @param move String representation of move
	 * @param player The player that tries the move
	 * @return true if the move was performed
	 */
	public abstract boolean tryMove(String move, Player player);
	
	/**
	 * The supplied player calls draw for the game. This info has to be saved. 
	 * The concrete game instance has to finish the game when necessary 
	 * (for example: all players called draw)
	 * 
	 * @param player The player who did this.
	 * @return true if successful
	 */
	public abstract boolean callDraw(Player player);
	
	/**
	 * The supplied player gives up. This info has to be saved. 
	 * The concrete game instance has to finish the game when necessary 
	 * (for example: one player gives up and loses. The others win)
	 * 
	 * @param player The player who did this.
	 * @return true if successful
	 */
	public abstract boolean giveUp(Player player);

	/**********************************
	 * For testing/grading purpose
	 **********************************/
	
	public void setNextPlayer(Player player) {
		nextPlayer = player;
	}
	
	public void setHistory(List<Move> history) {
		this.history = history;
	}
	
	/**
	 * Sets any given state (String representation) to the concrete game (internal representation).
	 * @param state
	 */
	public abstract void setBoard(String boardFEN);
}
