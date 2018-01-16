package de.tuberlin.sese.swtpp.gameserver.model.cannon;

import java.io.BufferedReader;
import java.io.File;
import java.io.IOException;
import java.io.InputStreamReader;

import de.tuberlin.sese.swtpp.gameserver.model.Bot;

/**
 * Bot implementation that launches Haskell program to retrieve single next move.
 *
 */
public class HaskellBot extends Bot implements Runnable{

	/**
	 * 
	 */
	private static final long serialVersionUID = 1371646871809169057L;


	private String path;    // path of bot executable
	private String bot;     // bot executable
	private CannonGame game; // the game this bot plays
	
	public HaskellBot(CannonGame game, String path, String bot) {
		super("HaskellBot");
		this.game = game;
		this.path = path;
		this.bot = bot;
		
		// start a bot poll thread
		new Thread(this).start();
	}
	
	public String getPath() {
		return path;
	}

	public void setPath(String path) {
		this.path = path;
	}

	@Override
	public String getName() {
		return "HaskellBot";
	}
	
	@Override
	public void run() {
		// run until game is finished
		while (!game.isFinished()) {
			try {
				// check every second for changes
				Thread.sleep(1000);
				
				// do move when it's my turn
				if (game.isItMyTurn(this)) {
					executeMove();						
				}
				
			} catch (InterruptedException e) {
				return;
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
		
	}

	private void executeMove() throws IOException, InterruptedException {
		
		// Execute command
		String command = bot + " " + game.getBoard().replaceAll("e", "") + " " + (game.isWhiteNext()? "w": "b");
		System.out.println("bot command:" + command);
		
		Process child = Runtime.getRuntime().exec(command, null, new File(path));

		// get command line response (wait for bot to finish)
		BufferedReader bri = new BufferedReader
		        (new InputStreamReader(child.getInputStream()));
		
		child.waitFor();
		
		// get result into single string
		String result = "";
		while (bri.ready()) result += bri.readLine();
		
		System.out.println("bot answer: " + result + ".");
		// give up when bot didn't find a move (but should have)
		if (result == "") game.giveUp(game.getPlayer(this));
		else {
			if (!game.tryMove(result, game.getPlayer(this))) {
				// give up when move was illegal
				game.giveUp(game.getPlayer(this));
			} 
		}
	}

}
