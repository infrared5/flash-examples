package invawayders.objects
{
	import away3d.entities.*;
	
	/**
	 * Game object used for the projectile that is created when an invawayder or player dispatches a fire event.
	 */
	public class Projectile extends GameObject
	{
		private var _mesh:Mesh;
		
		public var targets:Vector.<GameObject>;
		
		/**
		 * Creates a new <code>Projectile</code> object.
		 * 
		 * @param mesh The Away3D mesh object used for the projectile in the 3D scene.
		 */
		public function Projectile( mesh:Mesh )
		{
			super();
			
			_mesh = mesh;
			
			addChild( mesh );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function cloneGameObject():GameObject
		{
			return new Projectile( _mesh.clone() as Mesh );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update():void
		{
			super.update();
			
			if( z > 30000 ) {
				clear();
				return;
			}
			
			var target:GameObject;
			var dx:Number, dy:Number, dz:Number, distance:Number;

			// Check for collisions.
			for each ( target in targets) {
				if( target.active ) {

					dz = target.z - z;

					if( Math.abs( dz ) < Math.abs( velocity.z ) ) {
						dx = target.x - x;
						dy = target.y - y;
						distance = Math.sqrt( dx * dx + dy * dy );
						if( distance < GameSettings.impactHitSize * target.scaleX ) {
							target.impact( this );
							clear();
						}
					}
				}

			}

		}
	}
}
