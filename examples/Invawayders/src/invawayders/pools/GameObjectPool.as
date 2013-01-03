package invawayders.pools
{
	import invawayders.objects.*;
	
	import away3d.containers.*;
	
	/**
	 * Base class for a pool of game objects
	 */
	public class GameObjectPool extends ObjectContainer3D
	{
		protected var _gameObject : GameObject;
		protected var _gameObjects:Vector.<GameObject>  = new Vector.<GameObject>();
		
		/**
		 * Returns all gameobjects in the pool.
		 */
		public function get gameObjects():Vector.<GameObject>
		{
			return _gameObjects;
		}
		
		/**
		 * Creates a new <code>GameObjectPool</code> class
		 */
		public function GameObjectPool( gameObject:GameObject)
		{
			super();
			
			_gameObject = gameObject;
		}
		
		/**
		 * Clears all active game objects in the pool from the game area.
		 * 
		 * @see invawayders.objects.GameObject#clear
		 */
		public function clear():void
		{
			var gameObject:GameObject;
			for each ( gameObject in _gameObjects)
				if( gameObject.active )
					gameObject.clear();
		}
		
		/**
		 * Updates all active game objects in the pool.
		 * 
		 * @see invawayders.objects.GameObject#update
		 */
		public function update():void
		{
			var gameObject:GameObject;
			for each ( gameObject in _gameObjects) {
				if( gameObject.active ) {
					gameObject.update();
					
					// clear objects that have gone outside of the scene range.
					if( gameObject.z < GameSettings.minZ || gameObject.z > GameSettings.maxZ )
						gameObject.clear();
				}
			}
		}
		
		/**
		 * Returns an active game object in the pool that is currently unused.
		 * If no unused objects exist, a new game object is created and added to the pool.
		 * 
		 * @return An active unused game object.
		 */
		public function getGameObject():GameObject
		{
			// Adds an unused game object or creates a new game object if none is found.
			var gameObject:GameObject;
			for each ( gameObject in _gameObjects ) {
				if( !gameObject.active ) {
					gameObject.add(this);
					return gameObject;
				}
			}
			
			gameObject = _gameObject.cloneGameObject();
			
			gameObject.add(this);
			_gameObjects.push( gameObject );
			
			return gameObject;
		}
	}
}
