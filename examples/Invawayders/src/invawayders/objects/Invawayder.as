package invawayders.objects
{
	import invawayders.data.*;
	import invawayders.events.*;
	import invawayders.pools.*;
	import invawayders.utils.*;
	
	import away3d.entities.*;
	
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	/**
	 * Game object used for an invawayder in the scene.
	 */
	public class Invawayder extends GameObject
	{
		private var _invawayderData:InvawayderData;
		private var _meshFrame0:Mesh;
		private var _meshFrame1:Mesh;
		private var _fireTimer:Timer;
		private var _targetSpawnZ:Number;
		private var _animationTimer:Timer;
		private var _currentDefinitionIndex:uint;
		private var _life:uint;
		private var _panAmplitude:Number;
		private var _panXFreq:Number;
		private var _panYFreq:Number;
		private var _updateCounter:uint;
		private var _spawnX:Number = 0;
		private var _spawnY:Number = 0;
		private var _targetSpeed:Number = 0;
		
		/**
		 * The data object from the invawayder factory used to initialise the invawayder game object.
		 * 
		 * @see invawayders.InvawayderFactory
		 */
		public function get invawayderData():InvawayderData
		{
			return _invawayderData;
		}
		
		/**
		 * The active cell positions of the invawayder, used to position explosion cells when invawayder dies.
		 */
		public function get cellPositions():Vector.<Point>
		{
			return _currentDefinitionIndex == 0 ? _invawayderData.cellPositions[0] : _invawayderData.cellPositions[1];
		}
		
		/**
		 * Creates a new <code>Invawayder</code> object.
		 * 
		 * @param invawayderData The data object from the invawayder factory used to initialise the invawayder game object.
		 * @param meshFrame0 The Away3D mesh object used for frame 0 of the invawayder in the 3D scene.
		 * @param meshFrame1 The Away3D mesh object used for frame 1 of the invawayder in the 3D scene.
		 */
		public function Invawayder( invawayderData:InvawayderData, meshFrame0:Mesh, meshFrame1:Mesh )
		{
			super();
			
			_invawayderData = invawayderData;
			_meshFrame0 = meshFrame0;
			_meshFrame1 = meshFrame1;
			
			addChild( _meshFrame0 );
			addChild( _meshFrame1 );
			
			_animationTimer = new Timer( MathUtils.rand( GameSettings.invawayderAnimationTimeMS, GameSettings.invawayderAnimationTimeMS * 1.5 ) );
			_animationTimer.addEventListener( TimerEvent.TIMER, onAnimationTimerTick );
			
			_fireTimer = new Timer( getFireRate() );
			_fireTimer.addEventListener( TimerEvent.TIMER, onFireTimerTick );
			
			updateFrame();
		}
		
		/**
		 * Stops the internal timer on the invawayder object.
		 */
		public function stopTimers():void
		{
			_animationTimer.stop();
			_fireTimer.stop();
		}
		
		/**
		 * Resumes the internal timer on the invawayder object.
		 */
		public function resumeTimers():void
		{
			_animationTimer.start();
			_fireTimer.start();
		}
		
		/**
		 * @inheritDoc
		 */
		override public function cloneGameObject():GameObject
		{
			return new Invawayder( _invawayderData, _meshFrame0.clone() as Mesh, _meshFrame1.clone() as Mesh);
		}
		
		/**
		 * @inheritDoc
		 */
		override public function impact( trigger:GameObject ):void
		{
			super.impact( trigger );
			
			_life -= GameSettings.blasterStrength;
			if( _life <= 0 || trigger is Player ) {
				clear();
				dispatchEvent( new GameObjectEvent( GameObjectEvent.GAME_OBJECT_DIE, this, trigger ) );
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update():void
		{
			super.update();
			
			_updateCounter++;
			x = _spawnX + _panAmplitude * Math.sin( _panXFreq * _updateCounter );
			y = _spawnY + _panAmplitude * Math.sin( _panYFreq * _updateCounter );
			
			// Slow down warping in
			if( z < _targetSpawnZ && velocity.z < _targetSpeed )
				velocity.z *= 0.75;
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function add(parent:GameObjectPool):void
		{
			super.add(parent);
			
			_animationTimer.start();
			_fireTimer.start();
			
			_updateCounter = 0;
			_panAmplitude = _invawayderData.panAmplitude;
			_panXFreq = 0.1 * Math.random();
			_panYFreq = 0.1 * Math.random();
			_spawnX = x = MathUtils.rand( -GameSettings.xyRange, GameSettings.xyRange );
			_spawnY = y = MathUtils.rand( -GameSettings.xyRange, GameSettings.xyRange );
			var speed:Number = _invawayderData.speed;
			_targetSpeed = -MathUtils.rand( speed * 0.75, speed * 1.25 );
			z = GameSettings.maxZ; // Warp in...
			velocity.z = MathUtils.rand( -2500, -1500 );
			_targetSpawnZ = MathUtils.rand( 15000, 20000 );
			scaleX = scaleY = scaleZ = _invawayderData.scale;
			_life = _invawayderData.life;
		}
		
		/**
		 * @inheritDoc
		 */		
		override public function clear():void
		{
			super.clear();
			
			_animationTimer.reset();
			_fireTimer.reset();
		}
		
		/**
		 * Handler for fire timer events, broadcast when the invawayder has fired a projectile.
		 */
		private function onFireTimerTick( event:TimerEvent ):void
		{
			_fireTimer.delay = getFireRate();
			dispatchEvent( new GameObjectEvent( GameObjectEvent.GAME_OBJECT_FIRE, this ) );
		}
		
		/**
		 * Handler for animation timer events, broadcast when the invawayder has updated its animation frame.
		 */
		private function onAnimationTimerTick( event:TimerEvent ):void
		{
			updateFrame();
		}
		
		/**
		 * Returns a new fire rate based on the fire rate of the invawayder type and a random element.
		 */
		private function getFireRate():uint
		{
			var rate:uint = _invawayderData.fireRate;
			return Math.floor( MathUtils.rand( rate, rate * 1.5 ) );
		}
		
		/**
		 * Updates the animation frame of the invawayder.
		 */
		private function updateFrame():void
		{
			_meshFrame0.visible = !_meshFrame0.visible;
			_meshFrame1.visible = !_meshFrame0.visible;
			_currentDefinitionIndex = _meshFrame0.visible ? 0 : 1;
		}
	}
}
