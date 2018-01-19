package de.tuberlin.sese.swtpp.gameserver.test.cannon;

import static org.junit.Assert.assertEquals;

import org.junit.Before;
import org.junit.Test;

import de.tuberlin.sese.swtpp.gameserver.control.GameController;
import de.tuberlin.sese.swtpp.gameserver.model.Player;
import de.tuberlin.sese.swtpp.gameserver.model.User;
import de.tuberlin.sese.swtpp.gameserver.model.cannon.CannonGame;

public class TryMoveTest {

	User user1 = new User("Alice", "alice");
	User user2 = new User("Bob", "bob");
	
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
	
	public void startGame(String initialBoard, boolean whiteNext) {
		controller.joinGame(user2);		
		blackPlayer = game.getPlayer(user2);
		
		game.setBoard(initialBoard);
		game.setNextPlayer(whiteNext? whitePlayer:blackPlayer);
	}
	
	public void assertMove(String move, boolean white, boolean expectedResult) {
		if (white)
			assertEquals(expectedResult, game.tryMove(move, whitePlayer));
		else 
			assertEquals(expectedResult,game.tryMove(move, blackPlayer));
	}
	
	public void assertGameState(String expectedBoard, boolean whiteNext, boolean finished, boolean whiteWon) {
		assertEquals(expectedBoard,game.getBoard().replaceAll("e", ""));
		assertEquals(whiteNext, game.isWhiteNext());

		assertEquals(finished, game.isFinished());
		if (!game.isFinished()) {
			assertEquals(whiteNext, game.isWhiteNext());
		} else {
			assertEquals(whiteWon, whitePlayer.isWinner());
			assertEquals(!whiteWon, blackPlayer.isWinner());
		}
	}
	

	/*******************************************
	 * !!!!!!!!! To be implemented !!!!!!!!!!!!
	 *******************************************/
	
	@Test
	public void exampleTest() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w3w1w1w/2w7/5b4/b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true);
		assertMove("h6-h5",true,true);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w3w3w/2w4w2/5b4/b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false,false,false);
	}
	
	
	/*******************************
	* Board State
	*******************************/
	
	@Test
	public void stateBoardWithEmptyLines() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w3w1w1w/2w7//b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w3w1w1w/2w7//b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true, false, false);
	}
	
	@Test
	public void stateBoard() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w3w1w1w/2w7/5b4/b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w3w1w1w/2w7/5b4/b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true, false, false);
	}
	
	/*******************************
	* Players Turn (all negative)
	*******************************/
	
	@Test
	public void whitesTurnBlackMoving() {
		startGame("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true);
		assertMove("d9-d9",false,false);
		assertGameState("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true,false,false);
	}
	
	@Test
	public void blacksTurnWhiteMoving() {
		startGame("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",false);
		assertMove("d9-d9",true,false);
		assertGameState("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",false,false,false);
	}
	
	@Test
	public void whitesTurnBlackMoving2() {
		startGame("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true);
		assertMove("d0-d0",false,false);
		assertGameState("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true,false,false);
	}
	
	@Test
	public void blacksTurnWhiteMoving2() {
		startGame("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",false);
		assertMove("d0-d0",true,false);
		assertGameState("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",false,false,false);
	}
	
	/*******************************
	* Placing Town
	*******************************/
	
	@Test
	public void placeWhiteTown() {
		startGame("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true);
		assertMove("d9-d9",true,true);
		assertGameState("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",false,false,false);
	}
	
	@Test
	public void placeBlackTown() {
		startGame("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",false);
		assertMove("f0-f0",false,true);
		assertGameState("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/5B4",true,false,false);
	}
	
	@Test
	public void placeWhiteTownAlreadyPlaced() {
		startGame("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true);
		assertMove("b9-b9",true,false);
		assertGameState("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true,false,false);
	}
	
	@Test
	public void placeBlackTownAlreadyPlaced() {
		startGame("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/5B4",false);
		assertMove("e0-e0",false,false);
		assertGameState("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/5B4",false,false,false);
	}
	
	@Test
	public void placeBlackTownOnWhiteSite() {
		startGame("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",false);
		assertMove("i9-i9",false,false);
		assertGameState("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",false,false,false);
	}
	
	@Test
	public void placeWhiteTownOnBlackSite() {
		startGame("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true);
		assertMove("g0-g0",true,false);
		assertGameState("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true,false,false);
	}
	
	@Test
	public void placeBlackTownOnCorner() {
		startGame("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",false);
		assertMove("a0-a0",false,false);
		assertGameState("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",false,false,false);
	}
	
	@Test
	public void placeWhiteTownOnCorner() {
		startGame("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true);
		assertMove("j9-j9",true,false);
		assertGameState("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true,false,false);
	}
	
	@Test
	public void placeWhiteTownInBoardMiddle() {
		startGame("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true);
		assertMove("c5-c5",true,false);
		assertGameState("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true,false,false);
	}
	
	@Test
	public void placeBlackTownInBoardMiddle() {
		startGame("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",false);
		assertMove("h5-h5",false,false);
		assertGameState("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",false,false,false);
	}
	
	@Test
	public void placeTownAfterEachOther() {
		startGame("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true);
		assertMove("d9-d9",true,true);
		assertGameState("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",false,false,false);
		assertMove("f0-f0",false,true);
		assertGameState("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/5B4",true,false,false);
		assertMove("b9-b9",true,false); //try to place white town again
		assertGameState("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/5B4",true,false,false);
	}
	
	/*******************************
	* Move Town (all negative)
	*******************************/
	
	@Test
	public void moveWhiteTown() {
		startGame("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true);
		assertMove("d9-e8",true,false);
		assertGameState("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true,false,false);
	}
	
	@Test
	public void moveBlackTown() {
		startGame("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/5B4",false);
		assertMove("f0-f1",false,false);
		assertGameState("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/5B4",false,false,false);
	}

	@Test
	public void placeWhiteTownWhileMoving() {
		startGame("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true);
		assertMove("d9-e9",true,false);
		assertGameState("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true,false,false);
	}
	
	@Test
	public void placeBlackTownWhileMoving() {
		startGame("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",false);
		assertMove("f0-f1",false,false);
		assertGameState("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",false,false,false);
	}
	
	/*******************************
	* Move Opponent Figure (all negative)
	*******************************/
	
	@Test
	public void whiteMovesBlackSoldier() {
		startGame("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/5B4",true);
		assertMove("a3-b4",true,false);
		assertGameState("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/5B4",true,false,false);
	}
	
	@Test
	public void blackMovesWhiteSoldier() {
		startGame("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/5B4",false);
		assertMove("d6-d5",false,false);
		assertGameState("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/5B4",false,false,false);
	}
	
	@Test
	public void whiteMovesBlackTown() {
		startGame("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/5B4",true);
		assertMove("f0-f1",true,false);
		assertGameState("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/5B4",true,false,false);
	}
	
	@Test
	public void blackMovesWhiteTown() {
		startGame("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/5B4",false);
		assertMove("d9-c8",false,false);
		assertGameState("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/5B4",false,false,false);
	}
	
	@Test
	public void whiteSidewardsCaptureBlackSoldierBlacksTurn() {
		startGame("5W4/1w1w3w1w/1w1w1w1w1w/1w3w1w1w/3wbw4/4b5/b1b1b1b1b1/b1b3b1b1/b1b3b1b1/3B6",false);
		assertMove("d5-e5",false,false);
		assertGameState("5W4/1w1w3w1w/1w1w1w1w1w/1w3w1w1w/3wbw4/4b5/b1b1b1b1b1/b1b3b1b1/b1b3b1b1/3B6",false,false,false);
	}
	
	/*******************************
	* Capture Sidewards
	*******************************/
	
	@Test
	public void whiteSidewardsMoveTownNotPlaced() {
		startGame("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true);
		assertMove("f6-g6",true,false);
		assertGameState("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",true,false,false);
	}
	
	@Test
	public void blackSidewardsMoveTownNotPlaced() {
		startGame("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",false);
		assertMove("g1-h1",false,false);
		assertGameState("/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/",false,false,false);
	}
	
	@Test
	public void whiteSidewardsMoveOnEmptyField() {
		startGame("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/5B4",true);
		assertMove("f6-g6",true,false);
		assertGameState("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/5B4",true,false,false);
	}
	
	@Test
	public void blackSidewardsMoveOnEmptyField() {
		startGame("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/5B4",false);
		assertMove("g1-h1",false,false);
		assertGameState("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/5B4",false,false,false);
	}
	
	@Test
	public void whiteSidewardsMoveOnFieldWithWhiteSoldier() {
		startGame("3W6/1w1w3w1w/1w1www1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1bbb1b1/b1b3b1b1/5B4",true);
		assertMove("f7-e7",true,false);
		assertGameState("3W6/1w1w3w1w/1w1www1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1bbb1b1/b1b3b1b1/5B4",true,false,false);
	}
	
	@Test
	public void whiteSidewardsMoveOnFieldWithWhiteTown() {
		startGame("4Ww4/1w1w1w1w1w/1w1w1w1w1w/1w1w3w1w///b1b1b1b1b1/b1b1bbb1b1/b1b3b1b1/5B4",true);
		assertMove("f6-g6",true,false);
		assertGameState("4Ww4/1w1w1w1w1w/1w1w1w1w1w/1w1w3w1w///b1b1b1b1b1/b1b1bbb1b1/b1b3b1b1/5B4",true,false,false);
	}
	
	@Test
	public void blackSidewardsMoveOnFieldWithBlackSoldier() {
		startGame("3W6/1w1w3w1w/1w1www1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1bbb1b1/b1b3b1b1/5B4",false);
		assertMove("e2-f5",false,false);
		assertGameState("3W6/1w1w3w1w/1w1www1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1bbb1b1/b1b3b1b1/5B4",false,false,false);
	}
	
	@Test
	public void blackSidewardsMoveOnFieldWithBlackTown() {
		startGame("3W6/1w1w3w1w/1w1www1w1w/1w1w1w1w1w///b1b1b3b1/b1b1b1b1b1/b1b1b1b1b1/5Bb3",false);
		assertMove("g0-f0",false,false);
		assertGameState("3W6/1w1w3w1w/1w1www1w1w/1w1w1w1w1w///b1b1b3b1/b1b1b1b1b1/b1b1b1b1b1/5Bb3",false,false,false);
	}
	
	@Test
	public void whiteSidewardsCaptureOverTwoFields() {
		startGame("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w3w1w//1b3w1b2/2b1b3b1/b1b1b1b1b1/b1b1b1b1b1/5B4",true);
		assertMove("f4-h4",true,false);
		assertGameState("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w3w1w//1b3w1b2/2b1b3b1/b1b1b1b1b1/b1b1b1b1b1/5B4",true,false,false);
	}
	
	@Test
	public void blackSidewardsCaptureOverTwoFiels() {
		startGame("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w3w1w//5w1b2/b1b1b3b1/b1b1b1b1b1/b1b1b1b1b1/5B4",false);
		assertMove("h4-f4",false,false);
		assertGameState("3W6/1w1w1w1w1w/1w1w1w1w1w/1w1w3w1w//5w1b2/b1b1b3b1/b1b1b1b1b1/b1b1b1b1b1/5B4",false,false,false);
	}
	
	@Test
	public void whiteSidewardsCaptureBlackSoldier() {
		startGame("5W4/1w1w3w1w/1w1w1w1w1w/1w3w1w1w/3wbw4/4b5/b1b1b1b1b1/b1b3b1b1/b1b3b1b1/3B6",true);
		assertMove("d5-e5",true,true);
		assertGameState("5W4/1w1w3w1w/1w1w1w1w1w/1w3w1w1w/4ww4/4b5/b1b1b1b1b1/b1b3b1b1/b1b3b1b1/3B6",false,false,false);
	}
	
	@Test
	public void blackSidewardsCaptureWhiteSoldier() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w3w1w1w//3wb5/b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false);
		assertMove("e4-d4",false,true);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w3w1w1w//3b6/b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true,false,false);
	}
	
	@Test
	public void whiteSidewardsCaptureBlackTown() {
		startGame("4bW4/1w1w1w1w1w/1w1w1w1w1w/1w3w1w1w///b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3Bw5",true);
		assertMove("e0-d0",true,true);
		assertGameState("4bW4/1w1w1w1w1w/1w1w1w1w1w/1w3w1w1w///b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3w6",true,true,true);
	}
	
	@Test
	public void blackSidewardsCaptureWhiteTown() {
		startGame("4bW4/1w1w1w1w1w/1w1w1w1w1w/1w5w1w/5w4//b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3Bw5",false);
		assertMove("e9-f9",false,true);
		assertGameState("5b4/1w1w1w1w1w/1w1w1w1w1w/1w5w1w/5w4//b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3Bw5",false,true,false);
	}
	
	/*******************************
	* Move Forward
	*******************************/
	
	@Test
	public void whiteMovesTwoFieldsForward() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true);
		assertMove("d6-d4",true,false);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true,false,false);
	}
	
	@Test
	public void blackMovesTwoFieldsForward() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false);
		assertMove("i3-g5",false,false);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false,false,false);
	}
	
	@Test
	public void whiteMovesOneFieldForwardTwoSidewards() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true);
		assertMove("j6-h5",true,false);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true,false,false);
	}
	
	@Test
	public void blackMovesOneFieldForwardThreeSidewards() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false);
		assertMove("g3-d4",false,false);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false,false,false);
	}
	
	@Test
	public void whiteMoveForward() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true);
		assertMove("b6-b5",true,true);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/3w1w1w1w/1w8//b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false,false,false);
	}

	@Test
	public void blackMoveForward() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/3w1w1w1w/1w8//b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false);
		assertMove("a3-b4",false,true);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/3w1w1w1w/1w8/1b8/2b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true,false,false);
	}

	/*******************************
	 * Capture Forward
	 *******************************/

	@Test
	public void whiteMovesOnBlockedByWhite() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true);
		assertMove("b7-b6",true,false);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true,false,false);
	}

	@Test
	public void blackMovesOnBlockedByBlack() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w3w1w/5w4//b1b1bbb1b1/b1b1b3b1/b1b1b1b1b1/3B6",false);
		assertMove("e2-f3",false,false);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w3w1w/5w4//b1b1bbb1b1/b1b1b3b1/b1b1b1b1b1/3B6",false,false,false);
	}

	@Test
	public void whiteCapturesBlackSoldier() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w3w1w1w/3w6/4b5/b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true);
		assertMove("d5-e4",true,true);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w3w1w1w//4w5/b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false,false,false);
	}

	@Test
	public void blackCapturesWhiteSoldier() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w5w1w/4ww4/4b5/b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false);
		assertMove("e4-e5",false,true);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w5w1w/4bw4//b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true,false,false);
	}

	@Test
	public void whiteCapturesBlackTown() {
		startGame("5W4/1w1wbw1w1w/1w1w1w1w1w/1w3w1w1w///b1b3b1b1/b1b1b1b1b1/b1bwb1b1b1/3B6",true);
		assertMove("d1-d0",true,true);
		assertGameState("5W4/1w1wbw1w1w/1w1w1w1w1w/1w3w1w1w///b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3w6",true,true,true);
	}

	@Test
	public void blackCapturesWhiteTown() {
		startGame("5W4/1w1wbw1w1w/1w1w1w1w1w/1w5w1w/5w4//b1b3b1b1/b1b1b1b1b1/b1bwb1b1b1/3B6",false);
		assertMove("e8-f9",false,true);
		assertGameState("5b4/1w1w1w1w1w/1w1w1w1w1w/1w5w1w/5w4//b1b3b1b1/b1b1b1b1b1/b1bwb1b1b1/3B6",false,true,false);
	}

	/*******************************
	 * Retreat
	 *******************************/

	@Test
	public void whiteRetreatsNotThreatend() {
		startGame("5W4/1w1w1w1w2/1w1w1w1w2/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true);
		assertMove("j6-j8",true,false);
		assertGameState("5W4/1w1w1w1w2/1w1w1w1w2/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true,false,false);
	}

	@Test
	public void whiteRetreatsNotThreatend2() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/3w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B1w4",true);
		assertMove("f0-f2",true,false);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/3w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B1w4",true,false,false);
	}

	@Test
	public void blackRetreatsNotThreatend() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false);
		assertMove("c2-a0",false,false);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false,false,false);
	}
	
	@Test
	public void blackRetreatsNotThreatend2() {
		startGame("4bW4/1w3w1w1w/1w1w1w1w1w/1w1w1w1w1w/3w6//b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false);
		assertMove("e9-c7",false,false);
		assertGameState("4bW4/1w3w1w1w/1w1w1w1w1w/1w1w1w1w1w/3w6//b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false,false,false);
	}

	@Test
	public void whiteRetreatsMissisColumn() {
		startGame("5W4/1w3w1w1w/1w3w1w1w/1w3w1w1w/1bw7//6b1b1/b3b1b1b1/b1b1b1b1b1/3B6",true);
		assertMove("c5-d7",true,false);
		assertGameState("5W4/1w3w1w1w/1w3w1w1w/1w3w1w1w/1bw7//6b1b1/b3b1b1b1/b1b1b1b1b1/3B6",true,false,false);
	}
	
	@Test
	public void blackRetreatsMissisColumn() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w/7b2//b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false);
		assertMove("h5-e3",false,false);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w/7b2//b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false,false,false);
	}

	@Test
	public void whiteRetreatsWhiteInLine() {
		startGame("5W4/1w3w1w1w/1w3w1w1w/1w3w1w1w/2wb6//6b1b1/b3b1b1b1/b1b1b1b1b1/3B6",true);
		assertMove("c5-a7",true,false);
		assertGameState("5W4/1w3w1w1w/1w3w1w1w/1w3w1w1w/2wb6//6b1b1/b3b1b1b1/b1b1b1b1b1/3B6",true,false,false);
	}

	@Test
	public void blackRetreatsWhiteInLine() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w3w/5b4/5w4/b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false);
		assertMove("f5-f3",false,false);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w3w/5b4/5w4/b1b3b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false,false,false);
	}
	
	@Test
	public void blackRetreatsWhiteInLine2() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w3w1w1w/b9/1w8/b3b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false);
		assertMove("a5-c3",false,false);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w3w1w1w/b9/1w8/b3b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false,false,false);
	}
	
	@Test
	public void blackRetreatsBlackInLine() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w/9b/9b/b1b1b1b1b1/b1b1b1b3/b1b1b1b3/3B6",false);
		assertMove("j5-j3",false,false);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w/9b/9b/b1b1b1b1b1/b1b1b1b3/b1b1b1b3/3B6",false,false,false);
	}
	
	@Test
	public void whiteRetreatsTargetBlockedByBlack() {
		startGame("5W4/1w1w1w1w1w/1wbw1w1w1w/3w1w1w1w/1b8//4b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true);
		assertMove("a5-c7",true,false);
		assertGameState("5W4/1w1w1w1w1w/1wbw1w1w1w/3w1w1w1w/1b8//4b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true,false,false);
	}
	
	@Test
	public void whiteRetreatsTargetBlockedByWhite() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w2//9w/b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true);
		assertMove("j4-h6",true,false);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w2//9w/b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true,false,false);
	}
	
	@Test
	public void whiteRetreats() {
		startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/3w1w1w1w//w9/b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true);
		assertMove("a4-a6",true,true);
		assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/w2w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false,false,false);
		}
	
	
	/** start position towns placed
	@Test
	public void blackSidewardsCaptureWhiteTown() {
	startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true);
	assertMove("d9-d9",true,true);
	assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false,false,false);
	}
	*/
	
	/*******************************
	* Move Backward (all negative)
	*******************************/
	
	@Test
	public void whiteMovesBackward() {
	startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true);
	assertMove("j8-j9",true,false);
	assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true,false,false);
	}
	
	@Test
	public void blackMovesBackward() {
	startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w3w1w//5w4/b1b1bbb1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false);
	assertMove("f3-f0",false,false);
	assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w3w1w//5w4/b1b1bbb1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false,false,false);
	}
	
	/*******************************
	* Capture Backward (all negative)
	*******************************/
	
	/*******************************
	* Move From Empty Field (all negative)
	*******************************/
	
	@Test
	public void whiteMovesSidewardsFromEmpty() {
	startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true);
	assertMove("e5-f5",true,false);
	assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",true,false,false);
	}
	
	@Test
	public void blackMovesForwardFromEmpty() {
	startGame("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false);
	assertMove("b3-b4",false,false);
	assertGameState("5W4/1w1w1w1w1w/1w1w1w1w1w/1w1w1w1w1w///b1b1b1b1b1/b1b1b1b1b1/b1b1b1b1b1/3B6",false,false,false);
	}
}
