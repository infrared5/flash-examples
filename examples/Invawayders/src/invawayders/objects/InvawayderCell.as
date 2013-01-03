package invawayders.objects
{
	import invawayders.pools.*;
	import invawayders.utils.*;
	
	import away3d.entities.*;
	
	import flash.events.*;
	import flash.utils.*;
	
	/**
	 * Game object used for an invawayder cell that forms the invawayder as it explodes after being killed.
	 */
	public class InvawayderCell extends GameObject
	{
		private var _mesh:Mesh;
		private var _deathTimer:Timer;
		private var _startFlashingOnCount:uint;
		
		/**
		 * Creates a new <code>InvawayderCell</code> object.
		 * 
		 * @param mesh The Away3D mesh object used for the cell in the 3D scene.
		 */
		public function InvawayderCell( mesh:Mesh )
		{
			super();
			
			_mesh = mesh;
			
			addChild( mesh );
			
			var flashCount:uint = MathUtils.rand(15, 25);
			
			_startFlashingOnCount = flashCount * 0.75;
			
			_deathTimer = new Timer( MathUtils.rand(30, 50), flashCount );
			_deathTimer.addEventListener( TimerEvent.TIMER, onDeathTimerTick );
			_deathTimer.addEventListener( TimerEvent.TIMER_COMPLETE, onDeathTimerComplete );
		}
		
		override public function cloneGameObject():GameObject
		{
			return new InvawayderCell( _mesh.clone() as Mesh );
		}
		
		override public function add(parent:GameObjectPool):void
		{
			super.add(parent);
			
			visible = true;
			
			_deathTimer.start();
		}
		
		override public function clear():void
		{
			super.clear();
			
			_deathTimer.reset();
		}
		
		private function onDeathTimerComplete( event:TimerEvent ):void
		{
			clear();
		}
		
		private function onDeathTimerTick( event:TimerEvent ):void
		{
			if( _deathTimer.currentCount > _startFlashingOnCount )
				visible = !visible;
		}
	}
}
