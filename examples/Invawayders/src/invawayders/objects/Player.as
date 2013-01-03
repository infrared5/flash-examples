package invawayders.objects
{
	import invawayders.events.*;
	import invawayders.utils.*;
	
	import away3d.cameras.*;
	import away3d.entities.*;
	import away3d.materials.*;
	import away3d.primitives.*;
	
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	/**
	 * Game object used for the player in the scene.
	 */
	public class Player extends GameObject
	{
		private var _camera:Camera3D;
		private var _shakeTimer:Timer;
		private var _shakeT:Number = 0;
		private var _shakeTimerCount:uint = 10;
		
		private var _fireReleased:Boolean = true;
		private var _fireReleaseTimer:Timer;
		private var _leftBlaster:Mesh;
		private var _rightBlaster:Mesh;
		
		public var targets:Vector.<GameObject>;
		
		public var playerFireCounter:uint;
		
		public var lives:uint;
		
		/**
		 * Creates a new <code>Player</code> object.
		 * 
		 * @param camera The Away3D camera object controlled by the player.
		 * @param material The material used for the player's blaster objects.
		 */
		public function Player( camera:Camera3D, material:MaterialBase )
		{
			super();
			
			addChild( camera );

			_camera = camera;
			
			// Blasters.
			_leftBlaster = new Mesh( new CubeGeometry( 25, 25, 500 ), material );
			_rightBlaster = _leftBlaster.clone() as Mesh;
			
			_leftBlaster.position = new Vector3D( -GameSettings.blasterOffsetH, GameSettings.blasterOffsetV, GameSettings.blasterOffsetD );
			_rightBlaster.position = new Vector3D( GameSettings.blasterOffsetH, GameSettings.blasterOffsetV, GameSettings.blasterOffsetD );
			
			addChild( _leftBlaster );
			addChild( _rightBlaster );
			
			// used to skae the camera after a hit
			_shakeTimer = new Timer( 25, _shakeTimerCount );
			_shakeTimer.addEventListener( TimerEvent.TIMER, onShakeTimerTick );
			_shakeTimer.addEventListener( TimerEvent.TIMER_COMPLETE, onShakeTimerComplete );
			
			// Used for rapid fire.
			_fireReleaseTimer = new Timer( GameSettings.blasterFireRateMS, 1 );
			_fireReleaseTimer.addEventListener( TimerEvent.TIMER_COMPLETE, onFireReleaseTimerComplete );
		}
		
		/**
		 * updates the firing state of the player's blaster objects.
		 */
		public function updateBlasters():void
		{
			if(_fireReleased) {
				playerFireCounter++;
				
				//kick back on the blasters
				var blaster:Mesh = playerFireCounter % 2 ? _rightBlaster : _leftBlaster;
				blaster.z -= 500;
				
				dispatchEvent( new GameObjectEvent( GameObjectEvent.GAME_OBJECT_FIRE, this ) );
				
				_fireReleased = false;
				_fireReleaseTimer.reset();
				_fireReleaseTimer.start();
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update():void
		{
			super.update();
			
			var dx:Number, dy:Number, dz:Number;
			
			// Check for collisions with invawayders.
			var target:GameObject;
			for each ( target in targets ) {
				if( target.active ) {

					dz = target.z - z;

					if( Math.abs( dz ) < Math.abs( target.velocity.z ) ) {
						dx = target.x - x;
						dy = target.y - y;
						if( Math.sqrt( dx * dx + dy * dy ) < GameSettings.impactHitSize ) {
							impact( target );
							target.impact(this);
						}
					}
				}
			}
			
			// Restore blasters from recoil.
			_leftBlaster.z += 0.25 * (GameSettings.blasterOffsetD - _leftBlaster.z);
			_rightBlaster.z += 0.25 * (GameSettings.blasterOffsetD - _rightBlaster.z);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function impact( trigger:GameObject ):void
		{
			if (!lives)
				return;
			
			//decrease the number of lives
			lives--;
			
			super.impact( trigger );
			
			//shake the camera to give the impression of impact
			_shakeT = 1;
			_shakeTimer.reset();
			_shakeTimer.start();
			
			//check to see if player is dead
			if (!lives)
				dispatchEvent( new GameObjectEvent( GameObjectEvent.GAME_OBJECT_DIE, this, trigger ) );
		}
		
		/**
		 * Handler for shake timer tick events, broadcast for a short time after the player has been hit by a projectile or invawayder. 
		 */
		private function onShakeTimerTick( event:TimerEvent ):void
		{
			var shakeRange:Number = GameSettings.playerHitShake * _shakeT;
			_camera.x = MathUtils.rand( -shakeRange, shakeRange );
			_camera.y = MathUtils.rand( -shakeRange, shakeRange );
			_shakeT = 1 - _shakeTimer.currentCount / _shakeTimerCount;
		}
		
		/**
		 * Handler for shake timer complete events, broadcast when the shake timer has completed. 
		 */
		private function onShakeTimerComplete( event:TimerEvent ):void
		{
			_camera.x = 0;
			_camera.y = 0;
		}
		
		/**
		 * Handler for fire release timer complete events, broadcast when the fire release timer has completed. 
		 */
		private function onFireReleaseTimerComplete( event:TimerEvent ):void
		{
			_fireReleased = true;
		}
	}
}
