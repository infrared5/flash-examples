package invawayders.objects
{
	import invawayders.pools.*;
	
	import away3d.entities.*;
	
	/**
	 * Game object used for the blast that occurs when an impact is detected.
	 */
	public class Blast extends GameObject
	{
		private var _mesh:Mesh;
		
		/**
		 * Creates a new <code>Blast</code> object.
		 * 
		 * @param mesh The Away3D mesh object used for the blast in the 3D scene.
		 */
		public function Blast( mesh:Mesh )
		{
			super();
			
			_mesh = mesh;
			
			addChild( mesh );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function update():void
		{
			super.update();
			
			scaleX = scaleY = scaleZ += 0.15;
			
			if( scaleX >= 5 )
				clear();
			
		}
		
		/**
		 * @inheritDoc
		 */
		override public function cloneGameObject():GameObject
		{
			return new Blast( _mesh.clone() as Mesh );
		}
		
		/**
		 * @inheritDoc
		 */
		override public function add(parent:GameObjectPool):void 
		{
			super.add(parent);
			
			scaleX = scaleY = scaleZ = 0;
		}
	}
}
