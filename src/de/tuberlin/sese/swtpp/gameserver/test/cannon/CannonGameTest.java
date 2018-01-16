package de.tuberlin.sese.swtpp.gameserver.test.cannon;

import static org.junit.Assert.assertEquals;
import static org.junit.Assert.assertFalse;
import static org.junit.Assert.assertTrue;

import org.junit.Before;
import org.junit.Test;

import de.tuberlin.sese.swtpp.gameserver.control.GameController;
import de.tuberlin.sese.swtpp.gameserver.model.Player;
import de.tuberlin.sese.swtpp.gameserver.model.User;
import de.tuberlin.sese.swtpp.gameserver.model.cannon.CannonGame;

public class CannonGameTest {
	
	User user1 = new User("Alice", "alice");
	User user2 = new User("Bob", "bob");
	User user3 = new User("Eve", "eve");
	
	Player whitePlayer = null;
	Player blackPlayer = null;
	CannonGame game = null;
	GameController controller;
	
	@Before
	public void setUp() throws Exception {
		controller = GameController.getInstance();
		controller.clear();
		
		int gameID = controller.startGame(user1, "");
		
		game = (CannonGame) controller.getGame(gameID);
		whitePlayer = game.getPlayer(user1);
	}
	
	public void startGame() {
		controller.joinGame(user2);
		blackPlayer = game.getPlayer(user2);
	}

	
	@Test
	public void testWaitingGame() {
		assertTrue(game.getStatus().equals("Wait"));
		assertTrue(game.gameInfo().equals(""));
	}
	
	@Test
	public void testGameStarted() {
		assertEquals(game.getGameID(), controller.joinGame(user2));
		assertEquals(false, game.addPlayer(new Player(user3, game))); // no third player
		assertEquals("Started", game.getStatus());
		assertTrue(game.gameInfo().equals(""));
		assertTrue(game.isWhiteNext());
		assertFalse(game.didWhiteDraw());
		assertFalse(game.didBlackDraw());
		assertFalse(game.whiteGaveUp());
		assertFalse(game.blackGaveUp());
	}

	@Test
	public void testSetNextPlayer() {
		startGame();
		
		game.setNextPlayer(blackPlayer);
		
		assertFalse(game.isWhiteNext());
	}

	
	@Test
	public void testCallDraw() {	
		// call draw before start
		assertFalse(game.callDraw(whitePlayer));

		startGame();
		
		controller.callDraw(user1, game.getGameID());
		assertTrue(game.didWhiteDraw());
		assertFalse(game.didBlackDraw());
		assertEquals("white called draw", game.gameInfo());
		
		controller.callDraw(user2, game.getGameID());
		assertTrue(game.didBlackDraw());

		assertEquals("Draw", game.getStatus());
		assertEquals("draw game", game.gameInfo());
		
		// call draw after finish
		assertFalse(game.callDraw(whitePlayer));
	}
	
	@Test
	public void testCallDrawBlack() {
		startGame();
		
		controller.callDraw(user2, game.getGameID());
		assertFalse(game.didWhiteDraw());
		assertTrue(game.didBlackDraw());
		assertEquals("black called draw", game.gameInfo());
	}

	@Test
	public void testGiveUp() {
		// try before start 
		assertFalse(game.giveUp(whitePlayer));
		assertFalse(game.giveUp(blackPlayer));
		
		startGame();
		
		controller.giveUp(user1, game.getGameID());
		
		assertEquals("Surrendered", game.getStatus());
		assertEquals("white gave up", game.gameInfo());
		
		// try after finish
		assertFalse(game.giveUp(whitePlayer));
		assertFalse(game.giveUp(blackPlayer));

	}
	
	@Test
	public void testGiveUpBlack() {
		startGame();
		
		controller.giveUp(user2, game.getGameID());
		
		assertEquals("Surrendered", game.getStatus());
		assertEquals("black gave up", game.gameInfo());
	}

	@Test
	public void testGetMinPlayers() {
		assertEquals(2, game.getMinPlayers());
	}
	
	@Test
	public void testGetMaxPlayers() {
		assertEquals(2, game.getMaxPlayers());
	}

	@Test
	public void testFinish() {
		// test before start
		assertFalse(game.finish(whitePlayer));

		startGame();
		
		assertTrue(game.finish(whitePlayer));
		assertEquals("Finished", game.getStatus());
		assertEquals("white won", game.gameInfo());
		
		// test after finish
		assertFalse(game.finish(whitePlayer));
	}
	
	@Test
	public void testFinishBlack() {
		startGame();
		
		assertTrue(game.finish(blackPlayer));
		assertEquals("Finished", game.getStatus());
		assertEquals("black won", game.gameInfo());
	}

	@Test
	public void testError() {
		assertFalse(game.isError());
		game.setError(true);
		assertTrue(game.isError());
		assertEquals("Error", game.getStatus());
		game.setError(false);
		assertFalse(game.isError());
	}
}
