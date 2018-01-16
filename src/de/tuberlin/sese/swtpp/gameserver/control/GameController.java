package de.tuberlin.sese.swtpp.gameserver.control;

import java.io.Serializable;
import java.util.LinkedList;

import de.tuberlin.sese.swtpp.gameserver.model.Game;
import de.tuberlin.sese.swtpp.gameserver.model.Player;
import de.tuberlin.sese.swtpp.gameserver.model.User;

/**
 * This class holds game-related use case and additional functionality required by these.
 *
 */
public class GameController implements Serializable{
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

	//associations
	protected LinkedList<Game> games = new LinkedList<Game>();

	// singleton instance
	private static GameController gameController;
	
	
	protected GameController () {
	}
	
	/*******************************
	 * Getters/Setters
	 ******************************/
	
	
	public LinkedList<Game> getGames() {
		return games;
	}

	public void setGames(LinkedList<Game> games) {
		this.games = games;
	}
	
	/**
	 * getInstance (Singleton)
	 * @return
	 */
	public static GameController getInstance() {
		if (gameController == null)
			gameController = new GameController();
	
		return gameController;
	}
	
	/*******************************
	 * Use Case functionality
	 ******************************/
	
		
	/***
	 * Creates a new game (Type is determined by game factory).
	 * The starting user is the first player. If bots are requested, they are created as well.
	 * The game implementation itself determined whether there are actually enough players
	 * to start the game.
	 * 
	 * @param u
	 * @param bots
	 * @return ID of new game
	 */
	public int startGame(User u, String bots) {
	
		Game newGame = GameFactory.createGame();
		
		Player p = new Player(u, newGame);
		u.addParticipation(p);
		
		newGame.addPlayer(p);
		
		if(bots!="") {
			String[] bTypes = bots.split(";");
			for (String bot : bTypes) {
				User botG = GameFactory.createBot(bot, newGame);
				Player botP = new Player(botG, newGame);
				newGame.addPlayer(botP);
			}

		}
		
		this.games.add(newGame);
		
		return newGame.getGameID();
	}
	
	/**
	 * The supplied User joins an existing game (creating a Player object) 
	 * that is waiting for players.
	 * 
	 * @param u
	 * @return -1 if there was no game waiting, otherwise: gameID
	 */
	public int joinGame(User u) {
		int ID; 
		Game gameWaiting = findOldestGameWaitingforPlayers(u);
	
		if (gameWaiting == null) {
			return -1;
		} else {
			Player p = new Player(u, gameWaiting);
			u.addParticipation(p);
			
			gameWaiting.addPlayer(p);
		
			ID = gameWaiting.getGameID();
			
		}
		
		return ID;
	}
	
	/**
	 * Move request of player is passed to the right game 
	 * 
	 * @param u
	 * @param gameID
	 * @param move
	 * @return true if move was allowed and performed
	 */
	public boolean tryMove(User u, int gameID, String move) {
		Game g = getGame(gameID);
		
		if (g != null) {
			return g.tryMove(move, g.getPlayer(u));
		}
		
		return false;
	}
	
	/**
	 * GiveUp request of player is passed to the right game 
	 * 
	 * @param u
	 * @param gameID
	 * @param move
	 * @return true if move was allowed and performed
	 */
	public void giveUp(User u, int gameID) {
		Game g = getGame(gameID);
		
		if (g!= null){
			g.giveUp(g.getPlayer(u));
		}
	}
	
	/**
	 * Call draw (Remis) request of player is passed to the right game 
	 * 
	 * @param u
	 * @param gameID
	 * @param move
	 * @return true if move was allowed and performed
	 */
	public void callDraw(User u, int gameID) {
		Game g = getGame(gameID);
		
		if (g!= null){
			g.callDraw(g.getPlayer(u));
		}
	}

	/**
	 * Retrieves the game state from the concrete game. 
	 * @param g
	 * @return game info
	 */
	public String getGameState(int gameID) {
		Game g = getGame(gameID);
		
		if (g!= null){
			return g.getBoard();
		} else {
			return "";
		}
	}
	
	/**
	 * Retrieves status text from the concrete game. 
	 * @param g
	 * @return game info
	 */
	public String getGameStatus(int gameID) {
		Game g = getGame(gameID);
		
		if (g!= null){
			return g.getStatus();
		} else {
			return "";
		}
	}
	
	/**
	 * Retrieves additional info text about the game state from the concrete game. 
	 * @param g
	 * @return game info
	 */
	public String gameInfo(int gameID) {
		Game g = getGame(gameID);
		
		if (g!= null){
			return g.gameInfo();
		} else {
			return "";
		}
	}
	
	/*******************************
	 * Helpers
	 ******************************/
	
	
	public Game getGame(int gameID) {
		
		for (Game g: games) {
			if (g.getGameID() == gameID) return g;
		}
		
		return null;
	}
	
	public Game findOldestGameWaitingforPlayers(User u) {
		
		for (Game g: games) {
			if (!g.isStarted() && !g.isPlayer(u)) return g;
		}

		return null;
	}	
	
	public void clear() {
		games = new LinkedList<Game>();
	}
		
}
