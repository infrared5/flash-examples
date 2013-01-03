package invawayders.utils
{
	import flash.net.*;
	
	/**
	 * Saves and loads the high score value of the game.
	 */
	public class SaveStateManager
	{
		private const INVAWAYDERS_SO_NAME:String = "invawaydersUserData";
		
		/**
		 * Saves the highscore value to a local shared object.
		 * 
		 * @param highScore The highscore value to be saved.
		 */
		public function saveHighScore( highScore:uint ):void
		{
			var sharedObject:SharedObject = SharedObject.getLocal( INVAWAYDERS_SO_NAME );
			sharedObject.data.highScore = highScore;
			sharedObject.flush();
		}
		
		/**
		 * Loads the highscore value from an existing shared object.
		 * 
		 * @return The last known highscore saved.
		 */
		public function loadHighScore():uint
		{
			var sharedObject:SharedObject = SharedObject.getLocal( INVAWAYDERS_SO_NAME );
			return sharedObject.data.highScore;
		}
	}
}
