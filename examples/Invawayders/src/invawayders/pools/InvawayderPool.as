package invawayders.pools
{
	import invawayders.objects.*;
	
	/**
	 * Game object pool for all invvawayder game objects.
	 */
	public class InvawayderPool extends GameObjectPool
	{
		/**
		 * Creates a new <code>InvawayderPool</code> object.
		 */
		public function InvawayderPool()
		{
			super(null);
		}
		
		/**
		 * Stops the internal timers on all active invawayder objects.
		 * 
		 * @see invawayders.objects.Invawayder#stopTimers
		 */
		public function stopTimers():void
		{
			var invawayder:Invawayder;
			for each ( invawayder in _gameObjects)
				if( invawayder.active )
					invawayder.stopTimers();
		}
		
		/**
		 * Resumes the internal timers on all active invawayder objects.
		 * 
		 * @see invawayders.objects.Invawayder#resumeTimers
		 */
		public function resumeTimers():void
		{
			var invawayder:Invawayder;
			for each ( invawayder in _gameObjects)
				if( invawayder.active )
					invawayder.resumeTimers();
		}
		
		/**
		 * Returns an active invawayder object in the pool that is currently unused and is of the specified type.
		 * If no unused objects exist, a null value is returned.
		 * 
		 * @param id An unsigned integer representing the type of invawayder to be returned.
		 * 
		 * @return An active unused invawayder object of the specified type.
		 */
		public function getInvawayderOfType( id:uint ):Invawayder
		{
			// Adds an unused item or creates a new item if none are found.
			var invawayder:Invawayder;
			for each ( invawayder in _gameObjects) {
				if( !invawayder.active && invawayder.invawayderData.id == id ) {
					invawayder.add(this);
					return invawayder;
				}
			}
			
			return null;
		}
	}
}
