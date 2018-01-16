package de.tuberlin.sese.swtpp.gameserver.model;

/**
 * Bot class as a special User. Doesn't do much, but can be 
 * used to distinguish bots from other users.
 * Work has to be done by concrete bot implementations.
 *
 */
public abstract class Bot extends User{
	/**
	 * 
	 */
	private static final long serialVersionUID = 6451276549161911816L;
	
	public Bot(String name) {
		super(name,name);
	}
}
