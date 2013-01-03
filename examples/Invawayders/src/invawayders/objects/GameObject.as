package invawayders.objects
{
	import invawayders.events.*;
	import invawayders.pools.*;
	
	import away3d.containers.*;
	import away3d.errors.*;
	
	import flash.geom.*;
	
	/**
	 * Base game object.
	 */
	public class GameObject extends ObjectContainer3D
	{
		/**
		 * The linear velocity vector of the game object.
		 */
		public var velocity:Vector3D = new Vector3D();
		
		/**
		 * The rotational velocity vector of the game object.
		 */
		public var rotationalVelocity:Vector3D = new Vector3D();
		
		/**
		 * Determines if the game object is currently active within the scene.
		 */
		public var active:Boolean;
		
		/**
		 * Updates the timestep of the game object.
		 */
		public function update():void
		{
			// Move.
			x += velocity.x;
			y += velocity.y;
			z += velocity.z;
			
			// Rotate.
			rotationX += rotationalVelocity.x;
			rotationY += rotationalVelocity.y;
			rotationZ += rotationalVelocity.z;
		}
		
		/**
		 * Returns a clone of the game object.
		 * 
		 * @return A clone of the game object.
		 */
		public function cloneGameObject():GameObject
		{
			throw new AbstractMethodError();
		}
		
		/**
		 * Registers an impact on the game object from the given trigger.
		 * 
		 * @param trigger The game object from which an impact was triggered.
		 */
		public function impact( trigger:GameObject ):void 
		{
			dispatchEvent( new GameObjectEvent( GameObjectEvent.GAME_OBJECT_HIT, this, trigger ) );
		}
		
		/**
		 * Adds the game object to the scene and registers it as active.
		 * 
		 * @param parent The game object pool to which the game object is aded.
		 */
		public function add(parent:GameObjectPool):void
		{
			active = true;
			
			dispatchEvent( new GameObjectEvent( GameObjectEvent.GAME_OBJECT_ADD, this ) );
			
			transform = new Matrix3D();
			velocity = new Vector3D();
			rotationalVelocity = new Vector3D();
			
			parent.addChild(this);
		}
		
		/**
		 * Clears the game object from the scene and registers it as inactive.
		 */
		public function clear():void
		{
			active = false;
			
			if (parent)
				parent.removeChild(this);
		}
	}
}