package invawayders.events
{
	import invawayders.objects.*;
	
	import flash.events.*;
	
	/**
	 * Dispatched from a game object when its state changes or when an event occurs.
	 */
	public class GameObjectEvent extends Event
	{
		/**
		 * Dispatched when a game object is destroyed.
		 */
		public static const GAME_OBJECT_DIE:String = "gameObjectDie";
		
		/**
		 * Dispatched when a game object is hit.
		 */
		public static const GAME_OBJECT_HIT:String = "gameObjectHit";
		
		/**
		 * Dispatched when a game object fires a projectile.
		 */
		public static const GAME_OBJECT_FIRE:String = "gameObjectFire";
		
		/**
		 * Dispatched when a game object is added to teh scene.
		 */
		public static const GAME_OBJECT_ADD:String = "gameObjectAdd";
		
		/**
		 * The game object that is the target of the event.
		 */
		public var gameTarget:GameObject;
		
		/**
		 * The game object that is the trigger of the event.
		 */
		public var gameTrigger:GameObject;
		
		/**
		 * Create a new <code>GameObjectEvent</code>
		 * 
		 * @param type The event type.
		 * @param gameTarget The game object that is the target of the event.
		 * @param gameTrigger The game object that is the trigger of the event.
		 */
		public function GameObjectEvent( type:String, gameTarget:GameObject = null, gameTrigger:GameObject = null)
		{
			super( type, false, false );
			
			this.gameTarget = gameTarget;
			this.gameTrigger = gameTrigger;
		}
		
		/**
		 * Clones the event.
		 * 
		 * @return An exact duplicate of the current object.
		 */
		override public function clone():Event
		{
			return new GameObjectEvent( type, gameTarget, gameTrigger );
		}
	}
}
